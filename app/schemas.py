from pydantic import BaseModel, Field
from typing import List

class PredictRequest(BaseModel):
    data: List[float] = Field(
        ...,
        description="Historical time series data",
        example=[1.0, 2.0, 3.0, 4.0, 5.0]
    )

class PredictResponse(BaseModel):
    prediction: float
    confidence: float

class ForecastResponse(BaseModel):
    days: int
    predictions: List[float]
    confidence: float
