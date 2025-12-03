#!/bin/bash

# AI Forecast Service - Docker Restart Script
# Restarts the running container

CONTAINER_NAME="ai-forecast-mvp"

echo "🔄 Restarting AI Forecast Service..."

# Check if container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "⚠️  Container '$CONTAINER_NAME' not found"
    echo "💡 Run './scripts/docker-run.sh' to start the container"
    exit 1
fi

# Restart container
echo "♻️  Restarting container..."
docker restart $CONTAINER_NAME

# Wait a moment
sleep 2

# Show logs
echo "📋 Recent logs:"
docker logs --tail 20 $CONTAINER_NAME

echo ""
echo "✅ Container restarted successfully!"
echo "🌐 Service available at: http://localhost:8080"
