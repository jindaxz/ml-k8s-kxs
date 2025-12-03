#!/bin/bash

# AI Forecast Service - Docker Run Script
# Automatically handles container cleanup and restart

set -e

CONTAINER_NAME="ai-forecast-mvp"
IMAGE_NAME="ai-forecast:v1"
PORT_MAPPING="8080:8000"

echo "🚀 Starting AI Forecast Service..."

# Stop and remove existing container if present
echo "🧹 Cleaning up existing container..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true

# Rebuild image if requested
if [ "$1" == "-b" ] || [ "$1" == "--build" ]; then
    echo "🔨 Building Docker image..."
    docker build -t $IMAGE_NAME .
fi

# Run new container
echo "🐳 Starting container..."
docker run -d \
    -p $PORT_MAPPING \
    --name $CONTAINER_NAME \
    $IMAGE_NAME

# Wait for container to start
echo "⏳ Waiting for container to start..."
sleep 2

# Show logs
echo "📋 Container logs:"
docker logs $CONTAINER_NAME

# Show status
echo ""
echo "✅ Container started successfully!"
echo "📊 Container status:"
docker ps --filter name=$CONTAINER_NAME --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🌐 Service available at: http://localhost:8080"
echo "📖 API docs: http://localhost:8080/docs"
echo ""
echo "💡 Useful commands:"
echo "  - View logs: ./scripts/docker-logs.sh"
echo "  - Stop service: ./scripts/docker-stop.sh"
echo "  - Restart: ./scripts/docker-restart.sh"
echo "  - Test API: ./test-mvp.sh"
