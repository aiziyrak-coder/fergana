#!/bin/bash
# Create Nginx Config Files - Boshqa dasturlarga ta'sir qilmaslik uchun

echo "=========================================="
echo "🔧 CREATING NGINX CONFIG FILES"
echo "=========================================="

# ============================================
# 1️⃣ BACKEND CONFIG - ferganaapi.cdcgroup.uz
# ============================================
echo ""
echo "1️⃣ Creating backend config..."

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
        
        # Timeouts
        proxy_connect_timeout 120s;
        proxy_send_timeout 120s;
        proxy_read_timeout 120s;
    }

    location /static/ {
        alias /var/www/smartcity-backend/static/;
        expires 30d;
        add_header Cache-Control "public";
    }

    location /media/ {
        alias /var/www/smartcity-backend/media/;
        expires 7d;
        add_header Cache-Control "public";
    }
}
EOF

echo "✅ Backend config created: /etc/nginx/sites-available/ferganaapi.cdcgroup.uz"

# ============================================
# 2️⃣ FRONTEND CONFIG - fergana.cdcgroup.uz
# ============================================
echo ""
echo "2️⃣ Creating frontend config..."

sudo tee /etc/nginx/sites-available/fergana.cdcgroup.uz > /dev/null <<'EOF'
server {
    listen 80;
    server_name fergana.cdcgroup.uz;

    root /var/www/html/smartcity;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /assets {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

echo "✅ Frontend config created: /etc/nginx/sites-available/fergana.cdcgroup.uz"

# ============================================
# 3️⃣ ENABLE SITES
# ============================================
echo ""
echo "3️⃣ Enabling sites..."

# Remove broken symlinks first
sudo rm -f /etc/nginx/sites-enabled/ferganaapi.cdcgroup.uz
sudo rm -f /etc/nginx/sites-enabled/fergana.cdcgroup.uz

# Create new symlinks
sudo ln -sf /etc/nginx/sites-available/ferganaapi.cdcgroup.uz /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/fergana.cdcgroup.uz /etc/nginx/sites-enabled/

echo "✅ Sites enabled"

# ============================================
# 4️⃣ CHECK FOR DUPLICATES
# ============================================
echo ""
echo "4️⃣ Checking for duplicate server_name..."

# Check for ferganaapi duplicates
FERGANAAPI_DUPS=$(sudo grep -r "server_name.*ferganaapi" /etc/nginx/sites-enabled/ 2>/dev/null | grep -v "ferganaapi.cdcgroup.uz" | wc -l)

if [ "$FERGANAAPI_DUPS" -gt 0 ]; then
    echo "⚠️ Found other ferganaapi configs (these are for other apps, keeping them):"
    sudo grep -r "server_name.*ferganaapi" /etc/nginx/sites-enabled/ | grep -v "ferganaapi.cdcgroup.uz"
    echo ""
    echo "⚠️ Our config uses 'ferganaapi.cdcgroup.uz' (full domain), so no conflict"
else
    echo "✅ No conflicts found"
fi

# ============================================
# 5️⃣ NGINX TEST
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
    echo "Please check: sudo nginx -t"
    exit 1
fi

# ============================================
# 7️⃣ VERIFY
# ============================================
echo ""
echo "=========================================="
echo "✅ NGINX CONFIG CREATION COMPLETE"
echo "=========================================="
echo ""
echo "Enabled sites:"
ls -la /etc/nginx/sites-enabled/ | grep -E "ferganaapi\.cdcgroup\.uz|fergana\.cdcgroup\.uz"
echo ""
echo "Test commands:"
echo "  curl http://ferganaapi.cdcgroup.uz/api/auth/validate/"
echo "  curl http://fergana.cdcgroup.uz"
echo ""
echo "⚠️ Note: Other applications' configs are preserved in /etc/nginx/sites-available/"
echo "   Only our configs (ferganaapi.cdcgroup.uz and fergana.cdcgroup.uz) are enabled"
echo ""
