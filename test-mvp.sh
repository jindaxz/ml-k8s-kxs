#!/bin/bash

# AI Forecast Service MVP Test Script

set -e

echo "========================================="
echo "  AI Forecast Service MVP Tests"
echo "========================================="
echo ""

SERVICE_URL="http://localhost:8080"

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}0. Validate Helm chart...${NC}"
if ! command -v helm >/dev/null 2>&1; then
  echo "Helm CLI is required for chart validation. Install Helm 3+." >&2
  exit 1
fi
helm lint helm/ai-forecast
echo ""

echo -e "${BLUE}1. Check service health status...${NC}"
curl -s $SERVICE_URL/health | jq '.'
echo ""

echo -e "${BLUE}2. Train model...${NC}"
curl -s -X POST $SERVICE_URL/train | jq '.'
echo ""

echo -e "${BLUE}3. Single prediction test...${NC}"
curl -s -X POST $SERVICE_URL/predict \
  -H "Content-Type: application/json" \
  -d '{"data": [10, 20, 30, 40, 50]}' | jq '.'
echo ""

echo -e "${BLUE}4. 7-day forecast test...${NC}"
curl -s -X POST $SERVICE_URL/forecast/7 \
  -H "Content-Type: application/json" \
  -d '{"data": [10, 20, 30, 40, 50]}' | jq '.'
echo ""

echo -e "${BLUE}5. 30-day forecast test...${NC}"
curl -s -X POST $SERVICE_URL/forecast/30 \
  -H "Content-Type: application/json" \
  -d '{"data": [5, 10, 15, 20, 25, 30]}' | jq '.'
echo ""

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  All tests completed!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Access API documentation: $SERVICE_URL/docs"
echo ""
