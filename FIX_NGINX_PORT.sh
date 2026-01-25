#!/bin/bash
# Fix Nginx Port - Gunicorn 8002 port'da ishlayapti

echo "=========================================="
echo "🔧 FIXING NGINX PORT CONFIGURATION"
echo "=========================================="

# ============================================
# 1️⃣ GUNICORN PORT'NI TEKSHIRISH
# ============================================
echo ""
echo "1️⃣ Checking Gunicorn port..."

GUNICORN_PORT=$(sudo systemctl show smartcity-gunicorn.service -p ExecStart | grep -oP '--bind \S+:\K\d+' || echo "8002")
echo "Gunicorn is running on port: $GUNICORN_PORT"

# ============================================
# 2️⃣ NGINX CONFIG'NI YANGILASH
# ============================================
echo ""
echo "2️⃣ Updating Nginx config to use port $GUNICORN_PORT..."

sudo sed -i "s|proxy_pass http://127.0.0.1:8000;|proxy_pass http://127.0.0.1:$GUNICORN_PORT;|g" /etc/nginx/sites-available/ferganaapi.cdcgroup.uz

echo "✅ Nginx config updated"

# ============================================
# 3️⃣ NGINX TEST VA RELOAD
# ============================================
echo ""
echo "3️⃣ Testing Nginx config..."

if sudo nginx -t; then
    echo "✅ Nginx config is valid"
    
    echo ""
    echo "4️⃣ Reloading Nginx..."
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
# 5️⃣ TEKSHIRISH
# ============================================
echo ""
echo "=========================================="
echo "✅ PORT FIX COMPLETE"
echo "=========================================="
echo ""
echo "Test commands:"
echo "  curl http://ferganaapi.cdcgroup.uz/api/auth/validate/"
echo ""
echo "Expected: {\"valid\":false,\"error\":\"No valid authentication\"}"
echo ""
