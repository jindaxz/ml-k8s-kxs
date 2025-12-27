from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from prometheus_fastapi_instrumentator import Instrumentator
from app.schemas import PredictRequest, PredictResponse, ForecastResponse
from app.models import SimpleForecaster
from app.metrics import (
    prediction_counter, forecast_counter, model_train_counter,
    prediction_duration, forecast_duration, model_ready,
    active_predictions, track_time
)
import logging
from pythonjsonlogger import jsonlogger
import uuid

# 配置 JSON 日志
logHandler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter(
    '%(asctime)s %(name)s %(levelname)s %(message)s %(pathname)s %(lineno)d'
)
logHandler.setFormatter(formatter)
logger = logging.getLogger(__name__)
logger.addHandler(logHandler)
logger.setLevel(logging.INFO)

app = FastAPI(
    title="AI Forecast Service",
    description="Simple time series forecasting API with monitoring",
    version="1.4.0"
)

# 初始化 Prometheus 指标收集
instrumentator = Instrumentator(
    should_group_status_codes=False,
    should_ignore_untemplated=True,
    should_respect_env_var=True,
    should_instrument_requests_inprogress=True,
    excluded_handlers=["/metrics"],
    env_var_name="ENABLE_METRICS",
    inprogress_name="http_requests_inprogress",
    inprogress_labels=True,
)
instrumentator.instrument(app).expose(
    app,
    include_in_schema=False,
    should_gzip=True,
    endpoint="/metrics"
)

forecaster = SimpleForecaster()

# 添加请求 ID 中间件
@app.middleware("http")
async def add_request_id(request: Request, call_next):
    request_id = str(uuid.uuid4())
    request.state.request_id = request_id
    response = await call_next(request)
    response.headers["X-Request-ID"] = request_id
    return response

@app.on_event("startup")
async def startup_event():
    logger.info("Application starting up")
    if forecaster.is_ready():
        model_ready.set(1)
    else:
        model_ready.set(0)

@app.get("/")
def root():
    return {
        "service": "AI Forecast Service",
        "version": "1.4.0",
        "status": "running"
    }

@app.get("/health")
def health_check():
    ready = forecaster.is_ready()
    model_ready.set(1 if ready else 0)
    return {
        "status": "healthy" if ready else "degraded",
        "model_loaded": ready
    }

@app.post("/predict", response_model=PredictResponse)
@track_time(prediction_duration)
async def predict(request: PredictRequest, req: Request):
    """Single-step prediction with metrics"""
    request_id = req.state.request_id
    active_predictions.inc()
    try:
        logger.info(
            "Processing prediction",
            extra={
                "request_id": request_id,
                "data_length": len(request.data)
            }
        )
        prediction = forecaster.predict_single(request.data)
        prediction_counter.labels(endpoint="predict", status="success").inc()

        return PredictResponse(
            prediction=prediction,
            confidence=0.85
        )
    except Exception as e:
        prediction_counter.labels(endpoint="predict", status="error").inc()
        logger.error(
            "Prediction failed",
            extra={
                "request_id": request_id,
                "error": str(e)
            }
        )
        raise
    finally:
        active_predictions.dec()

@app.post("/forecast/{days}", response_model=ForecastResponse)
@track_time(forecast_duration)
async def forecast(days: int, request: PredictRequest, req: Request):
    """Multi-step forecast with metrics"""
    request_id = req.state.request_id
    if days > 30:
        days = 30

    logger.info(
        "Processing forecast",
        extra={
            "request_id": request_id,
            "days": days,
            "data_length": len(request.data)
        }
    )

    predictions = forecaster.forecast_multi(request.data, days)
    forecast_counter.labels(days=str(days)).inc()

    return ForecastResponse(
        days=days,
        predictions=predictions,
        confidence=0.80
    )

@app.post("/train")
async def train_model(req: Request):
    """Train model with sample data"""
    request_id = req.state.request_id
    logger.info("Training model", extra={"request_id": request_id})

    forecaster.train()
    model_train_counter.inc()
    model_ready.set(1)

    return {
        "status": "trained",
        "message": "Model trained with sample data"
    }
