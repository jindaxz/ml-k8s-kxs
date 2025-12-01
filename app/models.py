import numpy as np
from sklearn.linear_model import LinearRegression
from typing import List
import logging

logger = logging.getLogger(__name__)

class SimpleForecaster:
    """简单的线性回归预测器"""

    def __init__(self):
        self.model = LinearRegression()
        self.trained = False

    def is_ready(self) -> bool:
        return self.trained

    def train(self):
        """使用示例数据训练模型"""
        X = np.arange(100).reshape(-1, 1)
        y = 2 * X.flatten() + np.random.randn(100) * 5 + 10

        self.model.fit(X, y)
        self.trained = True
        logger.info("Model trained successfully")

    def predict_single(self, data: List[float]) -> float:
        """单步预测"""
        if not self.trained:
            self.train()

        X = np.array([[len(data)]])
        prediction = self.model.predict(X)[0]
        return float(prediction)

    def forecast_multi(self, data: List[float], steps: int) -> List[float]:
        """多步预测"""
        if not self.trained:
            self.train()

        predictions = []
        for i in range(steps):
            X = np.array([[len(data) + i]])
            pred = self.model.predict(X)[0]
            predictions.append(float(pred))

        return predictions
