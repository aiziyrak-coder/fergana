#!/bin/bash
# Smart City Server Full Setup Script
# Copy-paste this entire script to your server

set -e  # Exit on error

echo "========================================"
echo "Smart City Server Setup"
echo "========================================"
echo ""

# 1. Update system
echo "[1/9] Updating system..."
sudo apt update && sudo apt upgrade -y

# 2. Install Python
echo "[2/9] Installing Python..."
sudo apt install -y python3 python3-pip python3-venv

# 3. Install Node.js
echo "[3/9] Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 4. Install Nginx & Git
echo "[4/9] Installing Nginx & Git..."
sudo apt install -y nginx git

# 5. Create directories
echo "[5/9] Creating directories..."
sudo mkdir -p /var/www/smartcity-backend
sudo mkdir -p /var/www/smartcity-frontend
sudo mkdir -p /var/www/html/smartcity

# 6. Backend setup
echo "[6/9] Setting up Backend..."
cd /var/www
git clone https://github.com/aiziyrak-coder/shaxarApi.git smartcity-backend
cd smartcity-backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install gunicorn
python manage.py migrate
python create_superusers.py
python manage.py collectstatic --noinput

# 7. Frontend setup
echo "[7/9] Setting up Frontend..."
cd /var/www
git clone https://github.com/aiziyrak-coder/shaxar.git smartcity-frontend
cd smartcity-frontend
npm install
npm run build
sudo cp -r dist/* /var/www/html/smartcity/

# 8. Gunicorn service
echo "[8/9] Creating Gunicorn service..."
sudo tee /etc/systemd/system/gunicorn.service > /dev/null <<EOF
[Unit]
Description=Gunicorn daemon for Smart City Backend
After=network.target

[Service]
User=root
Group=www-data
WorkingDirectory=/var/www/smartcity-backend
Environment="PATH=/var/www/smartcity-backend/venv/bin"
ExecStart=/var/www/smartcity-backend/venv/bin/gunicorn \
    --workers 3 \
    --bind 127.0.0.1:8000 \
    --timeout 120 \
    smartcity_backend.wsgi:application

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start gunicorn
sudo systemctl enable gunicorn

# 9. Nginx configuration
echo "[9/9] Configuring Nginx..."

# Backend config
sudo tee /etc/nginx/sites-available/ferganaapi.cdcgroup.uz > /dev/null <<'EOF'
server {
    listen 80;
    server_name ferganaapi.cdcgroup.uz;

    client_max_body_size 20M;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static/ {
        alias /var/www/smartcity-backend/static/;
    }

    location /media/ {
        alias /var/www/smartcity-backend/media/;
    }
}
EOF

# Frontend config
sudo tee /etc/nginx/sites-available/fergana.cdcgroup.uz > /dev/null <<'EOF'
server {
    listen 80;
    server_name fergana.cdcgroup.uz;

    root /var/www/html/smartcity;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

# Enable sites
sudo ln -sf /etc/nginx/sites-available/ferganaapi.cdcgroup.uz /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/fergana.cdcgroup.uz /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test and restart Nginx
sudo nginx -t
sudo systemctl restart nginx

echo ""
echo "========================================"
echo "Setup completed successfully!"
echo "========================================"
echo ""
echo "Services:"
sudo systemctl status gunicorn --no-pager | head -5
sudo systemctl status nginx --no-pager | head -5
echo ""
echo "URLs:"
echo "- Frontend: http://fergana.cdcgroup.uz"
echo "- Backend:  http://ferganaapi.cdcgroup.uz"
echo "- Admin:    http://ferganaapi.cdcgroup.uz/admin"
echo ""
echo "Login: fergana / 123"
echo ""
