from fastapi import FastAPI
from app.schemas import PredictRequest, PredictResponse, ForecastResponse
from app.models import SimpleForecaster
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="AI Forecast Service",
    description="Simple time series forecasting API",
    version="0.1.0"
)

forecaster = SimpleForecaster()

@app.get("/")
def root():
    return {
        "service": "AI Forecast Service",
        "version": "0.1.0",
        "status": "running"
    }

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "model_loaded": forecaster.is_ready()
    }

@app.post("/predict", response_model=PredictResponse)
def predict(request: PredictRequest):
    """单点预测"""
    logger.info(f"Predicting for data: {request.data}")
    prediction = forecaster.predict_single(request.data)
    return PredictResponse(
        prediction=prediction,
        confidence=0.85
    )

@app.post("/forecast/{days}", response_model=ForecastResponse)
def forecast(days: int, request: PredictRequest):
    """多步预测"""
    logger.info(f"Forecasting {days} days ahead")
    if days > 30:
        days = 30

    predictions = forecaster.forecast_multi(request.data, days)
    return ForecastResponse(
        days=days,
        predictions=predictions,
        confidence=0.80
    )

@app.post("/train")
def train_model():
    """训练模型（使用示例数据）"""
    forecaster.train()
    return {
        "status": "trained",
        "message": "Model trained with sample data"
    }
