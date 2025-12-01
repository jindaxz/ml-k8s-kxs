#!/bin/bash

# AI Forecast Service MVP 测试脚本

set -e

echo "========================================="
echo "  AI Forecast Service MVP 测试"
echo "========================================="
echo ""

SERVICE_URL="http://localhost:8080"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}1. 检查服务健康状态...${NC}"
curl -s $SERVICE_URL/health | jq '.'
echo ""

echo -e "${BLUE}2. 训练模型...${NC}"
curl -s -X POST $SERVICE_URL/train | jq '.'
echo ""

echo -e "${BLUE}3. 单点预测测试...${NC}"
curl -s -X POST $SERVICE_URL/predict \
  -H "Content-Type: application/json" \
  -d '{"data": [10, 20, 30, 40, 50]}' | jq '.'
echo ""

echo -e "${BLUE}4. 7天预测测试...${NC}"
curl -s -X POST $SERVICE_URL/forecast/7 \
  -H "Content-Type: application/json" \
  -d '{"data": [10, 20, 30, 40, 50]}' | jq '.'
echo ""

echo -e "${BLUE}5. 30天预测测试...${NC}"
curl -s -X POST $SERVICE_URL/forecast/30 \
  -H "Content-Type: application/json" \
  -d '{"data": [5, 10, 15, 20, 25, 30]}' | jq '.'
echo ""

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  所有测试完成！${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "访问 API 文档: $SERVICE_URL/docs"
echo ""
