import numpy as np
from sklearn.linear_model import LinearRegression
from typing import List
import logging

logger = logging.getLogger(__name__)

class SimpleForecaster:
    """Simple linear regression forecaster"""

    def __init__(self):
        self.model = LinearRegression()
        self.trained = False

    def is_ready(self) -> bool:
        return self.trained

    def train(self):
        """Train model with sample data"""
        X = np.arange(100).reshape(-1, 1)
        y = 2 * X.flatten() + np.random.randn(100) * 5 + 10

        self.model.fit(X, y)
        self.trained = True
        logger.info("Model trained successfully")

    def predict_single(self, data: List[float]) -> float:
        """Single-step prediction"""
        if not self.trained:
            self.train()

        X = np.array([[len(data)]])
        prediction = self.model.predict(X)[0]
        return float(prediction)

    def forecast_multi(self, data: List[float], steps: int) -> List[float]:
        """Multi-step forecast"""
        if not self.trained:
            self.train()

        predictions = []
        for i in range(steps):
            X = np.array([[len(data) + i]])
            pred = self.model.predict(X)[0]
            predictions.append(float(pred))

        return predictions
