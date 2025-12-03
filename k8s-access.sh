#!/bin/bash

# K8s Service Access Script

echo "========================================="
echo "  K8s AI Forecast Service Access"
echo "========================================="
echo ""

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl not found. Please install kubectl first."
    exit 1
fi

# Check if service exists
if ! kubectl get deployment ai-forecast -n ai-forecast &> /dev/null; then
    echo "Error: ai-forecast deployment not found."
    echo "Deploy first with: kubectl apply -f k8s/"
    exit 1
fi

echo "Starting port-forward to K8s service..."
echo "Service will be accessible at: http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop port forwarding"
echo ""

# Start port forward
kubectl port-forward -n ai-forecast service/ai-forecast 8080:8000
