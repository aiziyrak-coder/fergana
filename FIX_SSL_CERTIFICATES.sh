#!/bin/bash
# Fix SSL Certificates - Let's Encrypt sertifikatlarini yaratish/yangilash

echo "=========================================="
echo "🔒 FIXING SSL CERTIFICATES"
echo "=========================================="

# ============================================
# 1️⃣ CERTBOT O'RNATISH
# ============================================
echo ""
echo "1️⃣ Checking Certbot installation..."

if ! command -v certbot &> /dev/null; then
    echo "⚠️ Certbot not found, installing..."
    sudo apt-get update
    sudo apt-get install -y certbot python3-certbot-nginx
    echo "✅ Certbot installed"
else
    echo "✅ Certbot is installed"
    certbot --version
fi

# ============================================
# 2️⃣ SSL SERTIFIKATLARNI TEKSHIRISH
# ============================================
echo ""
echo "2️⃣ Checking existing SSL certificates..."

# Backend domain
BACKEND_DOMAIN="ferganaapi.cdcgroup.uz"
BACKEND_CERT="/etc/letsencrypt/live/${BACKEND_DOMAIN}/fullchain.pem"

# Frontend domain
FRONTEND_DOMAIN="fergana.cdcgroup.uz"
FRONTEND_CERT="/etc/letsencrypt/live/${FRONTEND_DOMAIN}/fullchain.pem"

if [ -f "$BACKEND_CERT" ]; then
    echo "✅ Backend SSL certificate exists: $BACKEND_CERT"
    echo "   Expiry date:"
    sudo openssl x509 -enddate -noout -in "$BACKEND_CERT"
else
    echo "❌ Backend SSL certificate NOT found: $BACKEND_CERT"
fi

if [ -f "$FRONTEND_CERT" ]; then
    echo "✅ Frontend SSL certificate exists: $FRONTEND_CERT"
    echo "   Expiry date:"
    sudo openssl x509 -enddate -noout -in "$FRONTEND_CERT"
else
    echo "❌ Frontend SSL certificate NOT found: $FRONTEND_CERT"
fi

# ============================================
# 3️⃣ SSL SERTIFIKATLARNI YARATISH
# ============================================
echo ""
echo "3️⃣ Creating SSL certificates..."

# Check if certificates need to be created
CREATE_BACKEND=false
CREATE_FRONTEND=false

if [ ! -f "$BACKEND_CERT" ]; then
    CREATE_BACKEND=true
    echo "   Will create certificate for: $BACKEND_DOMAIN"
fi

if [ ! -f "$FRONTEND_CERT" ]; then
    CREATE_FRONTEND=true
    echo "   Will create certificate for: $FRONTEND_DOMAIN"
fi

if [ "$CREATE_BACKEND" = true ] || [ "$CREATE_FRONTEND" = true ]; then
    echo ""
    echo "⚠️ Creating SSL certificates with Certbot..."
    echo "   This will use Let's Encrypt (free SSL certificates)"
    echo ""
    
    # Create certificates
    if [ "$CREATE_BACKEND" = true ]; then
        echo "Creating certificate for $BACKEND_DOMAIN..."
        sudo certbot --nginx -d "$BACKEND_DOMAIN" --non-interactive --agree-tos --email admin@cdcgroup.uz --redirect
    fi
    
    if [ "$CREATE_FRONTEND" = true ]; then
        echo "Creating certificate for $FRONTEND_DOMAIN..."
        sudo certbot --nginx -d "$FRONTEND_DOMAIN" --non-interactive --agree-tos --email admin@cdcgroup.uz --redirect
    fi
    
    echo "✅ SSL certificates created"
else
    echo "✅ All SSL certificates already exist"
fi

# ============================================
# 4️⃣ NGINX CONFIG'NI SSL UCHUN YANGILASH
# ============================================
echo ""
echo "4️⃣ Updating Nginx config for SSL..."

# Backend config with SSL
if [ -f "$BACKEND_CERT" ]; then
    echo "Updating backend config with SSL..."
    sudo tee /etc/nginx/sites-available/ferganaapi.cdcgroup.uz > /dev/null <<EOF
# HTTP to HTTPS redirect
server {
    listen 80;
    server_name ferganaapi.cdcgroup.uz;
    return 301 https://\$server_name\$request_uri;
}

# HTTPS server
server {
    listen 443 ssl http2;
    server_name ferganaapi.cdcgroup.uz;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/ferganaapi.cdcgroup.uz/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ferganaapi.cdcgroup.uz/privkey.pem;
    
    # SSL Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    client_max_body_size 20M;

    location / {
        proxy_pass http://127.0.0.1:8002;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        proxy_connect_timeout 120s;
        proxy_send_timeout 120s;
        proxy_read_timeout 120s;
    }

    location /static/ {
        alias /var/www/smartcity-backend/static/;
        expires 30d;
    }

    location /media/ {
        alias /var/www/smartcity-backend/media/;
        expires 7d;
    }
}
EOF
    echo "✅ Backend config updated with SSL"
fi

# Frontend config with SSL
if [ -f "$FRONTEND_CERT" ]; then
    echo "Updating frontend config with SSL..."
    sudo tee /etc/nginx/sites-available/fergana.cdcgroup.uz > /dev/null <<EOF
# HTTP to HTTPS redirect
server {
    listen 80;
    server_name fergana.cdcgroup.uz;
    return 301 https://\$server_name\$request_uri;
}

# HTTPS server
server {
    listen 443 ssl http2;
    server_name fergana.cdcgroup.uz;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/fergana.cdcgroup.uz/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/fergana.cdcgroup.uz/privkey.pem;
    
    # SSL Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    root /var/www/html/smartcity;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location /assets {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
    echo "✅ Frontend config updated with SSL"
fi

# ============================================
# 5️⃣ NGINX TEST VA RELOAD
# ============================================
echo ""
echo "5️⃣ Testing Nginx config..."

if sudo nginx -t; then
    echo "✅ Nginx config is valid"
    
    echo ""
    echo "6️⃣ Reloading Nginx..."
    sudo systemctl reload nginx
    
    if [ $? -eq 0 ]; then
        echo "✅ Nginx reloaded successfully"
    else
        echo "❌ Nginx reload failed"
        exit 1
    fi
else
    echo "❌ Nginx config has errors!"
    exit 1
fi

# ============================================
# 7️⃣ TEKSHIRISH
# ============================================
echo ""
echo "=========================================="
echo "✅ SSL CERTIFICATE FIX COMPLETE"
echo "=========================================="
echo ""
echo "Test commands:"
echo "  curl https://ferganaapi.cdcgroup.uz/api/auth/validate/"
echo "  curl https://fergana.cdcgroup.uz"
echo ""
echo "Certificate locations:"
if [ -f "$BACKEND_CERT" ]; then
    echo "  Backend: $BACKEND_CERT"
fi
if [ -f "$FRONTEND_CERT" ]; then
    echo "  Frontend: $FRONTEND_CERT"
fi
echo ""
echo "To renew certificates automatically:"
echo "  sudo certbot renew --dry-run"
echo ""
