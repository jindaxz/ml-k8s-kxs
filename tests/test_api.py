from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["status"] == "running"

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert "status" in response.json()

def test_predict():
    response = client.post(
        "/predict",
        json={"data": [1.0, 2.0, 3.0, 4.0, 5.0]}
    )
    assert response.status_code == 200
    assert "prediction" in response.json()

def test_forecast():
    response = client.post(
        "/forecast/7",
        json={"data": [1.0, 2.0, 3.0, 4.0, 5.0]}
    )
    assert response.status_code == 200
    assert response.json()["days"] == 7
    assert len(response.json()["predictions"]) == 7
