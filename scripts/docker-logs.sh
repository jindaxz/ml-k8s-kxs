#!/bin/bash

# AI Forecast Service - Docker Logs Script
# View container logs with follow mode

CONTAINER_NAME="ai-forecast-mvp"

echo "📋 Showing logs for $CONTAINER_NAME (Ctrl+C to exit)..."
echo ""

# Check if container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "⚠️  Container '$CONTAINER_NAME' not found"
    echo "💡 Run './scripts/docker-run.sh' to start the container"
    exit 1
fi

# Follow logs
docker logs -f $CONTAINER_NAME
