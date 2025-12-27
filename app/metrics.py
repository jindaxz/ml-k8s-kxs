"""Prometheus metrics for AI Forecast service"""
from prometheus_client import Counter, Histogram, Gauge
import time
from functools import wraps

# Counter: 累计值（只增不减）
prediction_counter = Counter(
    'ai_forecast_predictions_total',
    'Total number of predictions made',
    ['endpoint', 'status']
)

forecast_counter = Counter(
    'ai_forecast_forecasts_total',
    'Total number of forecasts made',
    ['days']
)

model_train_counter = Counter(
    'ai_forecast_model_train_total',
    'Total number of model training operations'
)

# Histogram: 分布统计（延迟、大小等）
prediction_duration = Histogram(
    'ai_forecast_prediction_duration_seconds',
    'Time spent processing prediction',
    buckets=[0.01, 0.05, 0.1, 0.5, 1.0, 2.5, 5.0, 10.0]
)

forecast_duration = Histogram(
    'ai_forecast_forecast_duration_seconds',
    'Time spent processing forecast',
    buckets=[0.01, 0.05, 0.1, 0.5, 1.0, 2.5, 5.0, 10.0]
)

# Gauge: 瞬时值（可升可降）
model_ready = Gauge(
    'ai_forecast_model_ready',
    'Model readiness status (1=ready, 0=not ready)'
)

active_predictions = Gauge(
    'ai_forecast_active_predictions',
    'Number of predictions currently being processed'
)

# 装饰器：自动记录函数执行时间
def track_time(metric: Histogram):
    """Decorator to track function execution time"""
    def decorator(func):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            start_time = time.time()
            try:
                result = await func(*args, **kwargs)
                return result
            finally:
                duration = time.time() - start_time
                metric.observe(duration)
        return wrapper
    return decorator
