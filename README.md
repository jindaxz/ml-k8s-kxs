# K8s AI Forecasting System

Distributed AI forecasting system from local Kubernetes to AWS cloud

## 🎯 Project Status

**MVP Completed** ✅ (2025-11-28)

Core functionality validated, service running via Docker container.

## 📁 Project Structure

```
k8s-kxs/
├── app/                   # Application code
│   ├── main.py           # FastAPI main application
│   ├── models.py         # ML models
│   └── schemas.py        # Data models
├── k8s/                  # Kubernetes resources
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── tests/                # Tests
├── Dockerfile            # Container image
├── requirements.txt      # Python dependencies
├── test-mvp.sh          # MVP test script
└── README.md
```

## 🚀 Quick Start

### Prerequisites

- Docker Desktop (with Kubernetes enabled)
- Python 3.9+
- curl / jq (for testing)

### Run MVP

```bash
# 1. Clone repository
cd /home/osx/Documents/projects/k8s-kxs

# 2. Build image
docker build -t ai-forecast:v1 .

# 3. Run service
docker run -d -p 8080:8000 --name ai-forecast-mvp ai-forecast:v1

# 4. Test service
./test-mvp.sh

# Or manual testing
curl http://localhost:8080/health
curl -X POST http://localhost:8080/train
curl -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json" \
  -d '{"data": [10, 20, 30, 40, 50]}'

# 5. Access API documentation
open http://localhost:8080/docs
```

### Stop Service

```bash
docker stop ai-forecast-mvp
docker rm ai-forecast-mvp
```

## 📊 Core Features

- ✅ **Health Check**: `GET /health`
- ✅ **Model Training**: `POST /train`
- ✅ **Single Prediction**: `POST /predict`
- ✅ **Multi-step Forecast**: `POST /forecast/{days}`
- ✅ **API Documentation**: `/docs` (Swagger UI)

## 🛠 Tech Stack

### Current (MVP)
- **Backend**: FastAPI + Python 3.9
- **ML**: scikit-learn (LinearRegression)
- **Container**: Docker
- **API Documentation**: Swagger / OpenAPI

### Planned
- **Orchestration**: Kubernetes + Helm
- **Distributed Computing**: Ray
- **Monitoring**: Prometheus + Grafana
- **Frontend**: React / Vue
- **Cloud Platform**: AWS EKS

## 📈 Development Roadmap

### ✅ Completed
- [x] Project planning and architecture design
- [x] FastAPI service development
- [x] ML model implementation
- [x] Docker containerization
- [x] MVP functionality validation

### 🚧 In Progress
- [ ] K8s deployment (image distribution issue pending)

### 📋 Planned
- V1.1: K8s deployment refinement
- V1.2: Helm Chart packaging
- V1.3: Ingress configuration
- V1.4: Monitoring and logging
- V1.5: Improved ML models (Prophet/LSTM)
- V2.0: Ray distributed computing
- V2.1: Frontend dashboard
- V3.0: AWS EKS deployment

See [mvp-next-steps.md](docs/mvp-next-steps.md) for details

## 📚 Documentation

- [Project Overview](docs/project.md) - Project background and goals (Chinese)
- [Implementation Plan](docs/implementation-plan.md) - Complete technical implementation plan
- [MVP Plan](docs/mvp-plan.md) - MVP detailed steps
- [MVP Deployment Summary](docs/mvp-deployment-summary.md) - MVP completion status
- [Next Steps](docs/mvp-next-steps.md) - Follow-up iteration plan

## 🔍 Known Issues

### K8s Multi-node Image Distribution

**Issue**: Unable to properly distribute local images in Docker Desktop Kubernetes multi-node environment

**Temporary Solution**: Use Docker directly (MVP validated)

**Permanent Solutions**: Choose one of the following
1. Use Kind cluster (recommended)
2. Push images to Docker Hub
3. Configure local Registry

See [mvp-next-steps.md](docs/mvp-next-steps.md) for details

## 🎓 Learning Resources

### Kubernetes
- [Official Documentation](https://kubernetes.io/docs/)
- [Training Repository](https://github.com/jasonumiker/kubernetes-training)
- [Kind Documentation](https://kind.sigs.k8s.io/)

### Ray
- [Ray Documentation](https://docs.ray.io/)
- [Ray on K8s](https://docs.ray.io/en/latest/cluster/kubernetes/index.html)

### FastAPI
- [Official Documentation](https://fastapi.tiangolo.com/)

## 🤝 Contributing

This is a learning project, suggestions for improvements are welcome!

## 📝 License

MIT License

---

**Project Start Date**: 2025-11-28
**MVP Completion Date**: 2025-11-28
**Current Version**: v0.1.0 (MVP)
