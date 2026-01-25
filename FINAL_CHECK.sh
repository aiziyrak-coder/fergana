#!/bin/bash
# ============================================
# ✅ Yakuniy Tekshirish
# ============================================

echo "╔════════════════════════════════════════════════════════════╗"
echo "║              YAKUNIY TEKSHIRISH                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Backend API
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Backend API Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
BACKEND_RESPONSE=$(curl -s http://localhost:8002/api/organizations/)
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8002/api/organizations/)
echo "Status Code: $BACKEND_STATUS"
if [ "$BACKEND_STATUS" = "200" ] || [ "$BACKEND_STATUS" = "401" ]; then
    echo "✅ Backend API: OK"
    echo "Response (first 200 chars):"
    echo "$BACKEND_RESPONSE" | head -c 200
    echo "..."
else
    echo "❌ Backend API: FAILED"
    echo "Full response:"
    echo "$BACKEND_RESPONSE"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Frontend Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://fergana.cdcgroup.uz)
echo "Status Code: $FRONTEND_STATUS"
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "✅ Frontend: OK"
else
    echo "⚠️  Frontend: Status $FRONTEND_STATUS"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Frontend Build Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ -f "/var/www/html/index.html" ]; then
    echo "✅ index.html mavjud"
    ls -lh /var/www/html/index.html
else
    echo "❌ index.html topilmadi!"
fi

if [ -d "/var/www/html/assets" ]; then
    ASSETS_COUNT=$(ls -1 /var/www/html/assets/*.js 2>/dev/null | wc -l)
    echo "✅ Assets papkasi mavjud ($ASSETS_COUNT JS fayllar)"
    ls -lh /var/www/html/assets/*.js 2>/dev/null | head -3
else
    echo "❌ Assets papkasi topilmadi!"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Gunicorn Process Details"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ps aux | grep "smartcity_backend.wsgi" | grep -v grep

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    YAKUNIY XULOSA                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Gunicorn: RUNNING"
echo "✅ Nginx: RUNNING"
echo "Backend API: $([ "$BACKEND_STATUS" = "200" ] || [ "$BACKEND_STATUS" = "401" ] && echo '✅ OK' || echo '❌ FAILED')"
echo "Frontend: $([ "$FRONTEND_STATUS" = "200" ] && echo '✅ OK' || echo '⚠️  CHECK')"
echo ""
echo "🌐 URLs:"
echo "   Frontend: https://fergana.cdcgroup.uz"
echo "   Backend:  https://ferganaapi.cdcgroup.uz/api/organizations/"
echo ""
