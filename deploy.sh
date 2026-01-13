#!/bin/bash

echo "🚀 Starting Smart City Deployment..."
echo "=================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
BACKEND_DIR="/var/www/smartcity-backend"
FRONTEND_DIR="/var/www/smartcity-frontend"
NGINX_DIR="/var/www/html/smartcity"

# Backend Deployment
echo -e "${BLUE}📦 Deploying Backend...${NC}"
cd $BACKEND_DIR || exit

echo "  - Pulling latest changes..."
git pull origin master

echo "  - Activating virtual environment..."
source venv/bin/activate

echo "  - Installing dependencies..."
pip install -r requirements.txt

echo "  - Running migrations..."
python manage.py migrate

echo "  - Collecting static files..."
python manage.py collectstatic --noinput

echo "  - Restarting Gunicorn..."
sudo systemctl restart gunicorn

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Backend deployed successfully!${NC}"
else
    echo -e "${RED}❌ Backend deployment failed!${NC}"
    exit 1
fi

# Frontend Deployment
echo -e "${BLUE}🎨 Deploying Frontend...${NC}"
cd $FRONTEND_DIR || exit

echo "  - Pulling latest changes..."
git pull origin master

echo "  - Installing dependencies..."
npm install

echo "  - Building production..."
npm run build

echo "  - Copying build files..."
sudo rm -rf $NGINX_DIR/*
sudo cp -r dist/* $NGINX_DIR/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Frontend deployed successfully!${NC}"
else
    echo -e "${RED}❌ Frontend deployment failed!${NC}"
    exit 1
fi

# Restart Nginx
echo -e "${BLUE}🔄 Restarting Nginx...${NC}"
sudo systemctl restart nginx

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Nginx restarted successfully!${NC}"
else
    echo -e "${RED}❌ Nginx restart failed!${NC}"
    exit 1
fi

# Check service status
echo ""
echo -e "${BLUE}📊 Service Status:${NC}"
echo "=================================="
echo -e "${BLUE}Gunicorn:${NC}"
sudo systemctl status gunicorn --no-pager | grep "Active:"
echo -e "${BLUE}Nginx:${NC}"
sudo systemctl status nginx --no-pager | grep "Active:"

echo ""
echo -e "${GREEN}=================================="
echo "✅ Deployment completed successfully!"
echo "==================================${NC}"
echo ""
echo "🌐 Frontend: https://fergana.cdcgroup.uz"
echo "🔌 Backend:  https://ferganaapi.cdcgroup.uz"
echo ""
