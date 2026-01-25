#!/bin/bash
# Final Nginx Fix - Config to'g'ri, lekin nginx cache qilgan bo'lishi mumkin

echo "=========================================="
echo "🔧 FINAL NGINX FIX"
echo "=========================================="

# ============================================
# 1️⃣ CONFIG'NI TEKSHIRISH
# ============================================
echo ""
echo "1️⃣ Checking Nginx config..."

PROXY_PASS=$(sudo grep "proxy_pass" /etc/nginx/sites-available/ferganaapi.cdcgroup.uz | grep -oP 'http://\S+')
echo "Current proxy_pass: $PROXY_PASS"

if [[ "$PROXY_PASS" == *"8002"* ]]; then
    echo "✅ Config is correct (port 8002)"
else
    echo "❌ Config is wrong, fixing..."
    sudo sed -i 's|proxy_pass http://127.0.0.1:8000;|proxy_pass http://127.0.0.1:8002;|g' /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
    echo "✅ Config fixed"
fi

# ============================================
# 2️⃣ NGINX TEST
# ============================================
echo ""
echo "2️⃣ Testing Nginx config..."

if sudo nginx -t; then
    echo "✅ Nginx config is valid"
else
    echo "❌ Nginx config has errors!"
    exit 1
fi

# ============================================
# 3️⃣ NGINX TO'LIQ RESTART
# ============================================
echo ""
echo "3️⃣ Restarting Nginx (full restart, not just reload)..."

# Reload avval
sudo systemctl reload nginx
sleep 2

# Agar hali ham ishlamasa, to'liq restart
echo "Performing full restart..."
sudo systemctl restart nginx

if [ $? -eq 0 ]; then
    echo "✅ Nginx restarted successfully"
else
    echo "❌ Nginx restart failed"
    exit 1
fi

# ============================================
# 4️⃣ TEKSHIRISH
# ============================================
echo ""
echo "4️⃣ Testing connection..."

sleep 2

# Localhost test
echo "Testing localhost:8002..."
LOCAL_TEST=$(curl -s http://127.0.0.1:8002/api/auth/validate/)
if [[ "$LOCAL_TEST" == *"valid"* ]]; then
    echo "✅ Localhost test: OK"
else
    echo "❌ Localhost test failed: $LOCAL_TEST"
fi

# External test
echo "Testing external API..."
EXTERNAL_TEST=$(curl -s http://ferganaapi.cdcgroup.uz/api/auth/validate/)
if [[ "$EXTERNAL_TEST" == *"valid"* ]]; then
    echo "✅ External test: OK"
    echo "Response: $EXTERNAL_TEST"
else
    echo "⚠️ External test: $EXTERNAL_TEST"
    echo ""
    echo "Checking Nginx error log..."
    sudo tail -10 /var/log/nginx/ferganaapi-error.log
fi

# ============================================
# 5️⃣ XULOSA
# ============================================
echo ""
echo "=========================================="
echo "✅ NGINX FIX COMPLETE"
echo "=========================================="
echo ""
echo "If external test still fails, check:"
echo "  1. Nginx error log: sudo tail -f /var/log/nginx/ferganaapi-error.log"
echo "  2. Nginx access log: sudo tail -f /var/log/nginx/ferganaapi-access.log"
echo "  3. Gunicorn log: sudo tail -f /var/www/smartcity-backend/gunicorn-error.log"
echo ""
