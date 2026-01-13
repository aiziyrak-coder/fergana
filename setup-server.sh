#!/bin/bash

# Smart City Server Setup Script
# Run this on a fresh Ubuntu server

echo "🚀 Smart City Server Setup"
echo "=========================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Update system
echo -e "${BLUE}📦 Updating system...${NC}"
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo -e "${BLUE}📦 Installing dependencies...${NC}"
sudo apt install -y python3-pip python3-venv nginx git curl

# Install Node.js 18
echo -e "${BLUE}📦 Installing Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install certbot for SSL
echo -e "${BLUE}🔒 Installing Certbot...${NC}"
sudo apt install -y certbot python3-certbot-nginx

# Create directories
echo -e "${BLUE}📁 Creating directories...${NC}"
sudo mkdir -p /var/www/smartcity-backend
sudo mkdir -p /var/www/smartcity-frontend
sudo mkdir -p /var/www/html/smartcity

# Clone repositories
echo -e "${BLUE}📥 Cloning repositories...${NC}"
cd /var/www/smartcity-backend
git clone https://github.com/backend-developer-hojiakbar/smartApiFull.git .

cd /var/www/smartcity-frontend
git clone https://github.com/backend-developer-hojiakbar/smartFrontFull.git .

# Setup backend
echo -e "${BLUE}🐍 Setting up backend...${NC}"
cd /var/www/smartcity-backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
python create_superusers.py

# Setup frontend
echo -e "${BLUE}🎨 Setting up frontend...${NC}"
cd /var/www/smartcity-frontend
npm install
npm run build
sudo cp -r dist/* /var/www/html/smartcity/

# Copy service files
echo -e "${BLUE}⚙️ Configuring services...${NC}"
sudo cp /var/www/smartcity-backend/gunicorn.service /etc/systemd/system/
sudo cp /var/www/smartcity-backend/nginx-backend.conf /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
sudo cp /var/www/smartcity-frontend/nginx-frontend.conf /etc/nginx/sites-available/fergana.cdcgroup.uz

# Enable sites
sudo ln -s /etc/nginx/sites-available/ferganaapi.cdcgroup.uz /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/fergana.cdcgroup.uz /etc/nginx/sites-enabled/

# Start services
echo -e "${BLUE}🚀 Starting services...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl start gunicorn
sudo systemctl restart nginx

# Setup SSL (commented out - run manually)
echo -e "${BLUE}🔒 SSL Setup (run manually):${NC}"
echo "sudo certbot --nginx -d fergana.cdcgroup.uz"
echo "sudo certbot --nginx -d ferganaapi.cdcgroup.uz"

echo -e "${GREEN}✅ Setup completed!${NC}"
echo ""
echo "Next steps:"
echo "1. Configure DNS to point to this server"
echo "2. Run SSL setup commands above"
echo "3. Update /var/www/smartcity-backend/.env file"
echo "4. Restart services: sudo systemctl restart gunicorn nginx"
