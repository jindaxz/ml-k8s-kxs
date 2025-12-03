#!/bin/bash

# AI Forecast Service - Docker Stop Script
# Stops and removes the container

CONTAINER_NAME="ai-forecast-mvp"

echo "🛑 Stopping AI Forecast Service..."

# Check if container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "⚠️  Container '$CONTAINER_NAME' not found"
    exit 0
fi

# Stop container
echo "⏹️  Stopping container..."
docker stop $CONTAINER_NAME

# Remove container
echo "🗑️  Removing container..."
docker rm $CONTAINER_NAME

echo "✅ Container stopped and removed successfully!"
