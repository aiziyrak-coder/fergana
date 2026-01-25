#!/bin/bash
# ============================================
# ✅ Deploy Tekshirish Script
# ============================================

echo "╔════════════════════════════════════════════════════════════╗"
echo "║              DEPLOYMENT TEKSHIRISH                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# ============================================
# STEP 1: GUNICORN TEKSHIRISH
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 STEP 1: Gunicorn Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if pgrep -f gunicorn > /dev/null; then
    GUNICORN_PID=$(pgrep -f gunicorn | head -1)
    echo "  ✅ Gunicorn: RUNNING"
    echo "  📊 PID: $GUNICORN_PID"
    echo "  📋 Process'lar:"
    ps aux | grep gunicorn | grep -v grep
else
    echo "  ❌ Gunicorn: NOT RUNNING"
    echo "  🔧 Qayta ishga tushirilmoqda..."
    cd /var/www/smartcity-backend
    source venv/bin/activate
    nohup gunicorn smartcity_backend.wsgi:application \
        --bind 127.0.0.1:8002 \
        --workers 4 \
        --timeout 120 \
        --access-logfile gunicorn-access.log \
        --error-logfile gunicorn-error.log \
        > gunicorn.log 2>&1 &
    sleep 3
    if pgrep -f gunicorn > /dev/null; then
        echo "  ✅ Gunicorn qayta ishga tushirildi!"
    else
        echo "  ❌ Gunicorn ishga tushirishda muammo!"
        tail -20 gunicorn-error.log
    fi
fi

# ============================================
# STEP 2: NGINX TEKSHIRISH
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 STEP 2: Nginx Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if systemctl is-active --quiet nginx; then
    echo "  ✅ Nginx: RUNNING"
    sudo systemctl status nginx --no-pager | head -5
else
    echo "  ❌ Nginx: NOT RUNNING"
    echo "  🔧 Qayta ishga tushirilmoqda..."
    sudo systemctl restart nginx
    sleep 2
    if systemctl is-active --quiet nginx; then
        echo "  ✅ Nginx qayta ishga tushirildi!"
    else
        echo "  ❌ Nginx ishga tushirishda muammo!"
        sudo systemctl status nginx
    fi
fi

# ============================================
# STEP 3: BACKEND API TEKSHIRISH
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 STEP 3: Backend API Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8002/api/organizations/ 2>/dev/null || echo "000")
if [ "$BACKEND_STATUS" = "200" ] || [ "$BACKEND_STATUS" = "401" ]; then
    echo "  ✅ Backend API: OK (Status: $BACKEND_STATUS)"
    echo "  📍 URL: http://localhost:8002/api/organizations/"
else
    echo "  ❌ Backend API: FAILED (Status: $BACKEND_STATUS)"
    echo "  📋 Log'lar:"
    tail -10 /var/www/smartcity-backend/gunicorn-error.log 2>/dev/null || echo "  Log topilmadi"
fi

# ============================================
# STEP 4: FRONTEND TEKSHIRISH
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 STEP 4: Frontend Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://fergana.cdcgroup.uz 2>/dev/null || echo "000")
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "  ✅ Frontend: OK (Status: $FRONTEND_STATUS)"
    echo "  📍 URL: https://fergana.cdcgroup.uz"
else
    echo "  ⚠️  Frontend: Check manually (Status: $FRONTEND_STATUS)"
    echo "  📋 Nginx log'lar:"
    sudo tail -10 /var/log/nginx/error.log 2>/dev/null || echo "  Log topilmadi"
fi

# ============================================
# STEP 5: FRONTEND BUILD TEKSHIRISH
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 STEP 5: Frontend Build Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "/var/www/html" ]; then
    HTML_FILES=$(ls -1 /var/www/html/*.html 2>/dev/null | wc -l)
    ASSETS_FILES=$(ls -1 /var/www/html/assets/*.js 2>/dev/null | wc -l)
    echo "  ✅ HTML fayllar: $HTML_FILES"
    echo "  ✅ JS fayllar: $ASSETS_FILES"
    if [ "$HTML_FILES" -gt 0 ] && [ "$ASSETS_FILES" -gt 0 ]; then
        echo "  ✅ Frontend build fayllar mavjud!"
    else
        echo "  ⚠️  Frontend build fayllar to'liq emas"
    fi
else
    echo "  ❌ /var/www/html papkasi topilmadi!"
fi

# ============================================
# SUMMARY
# ============================================
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    TEKSHIRISH YAKUNLANDI                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "🌐 URLs:"
echo "   Frontend: https://fergana.cdcgroup.uz"
echo "   Backend:  https://ferganaapi.cdcgroup.uz"
echo ""
echo "📊 Status:"
echo "   Gunicorn: $(pgrep -f gunicorn > /dev/null && echo '✅ RUNNING' || echo '❌ STOPPED')"
echo "   Nginx:    $(systemctl is-active --quiet nginx && echo '✅ RUNNING' || echo '❌ STOPPED')"
echo "   Backend:  $([ "$BACKEND_STATUS" = "200" ] || [ "$BACKEND_STATUS" = "401" ] && echo '✅ OK' || echo '❌ FAILED')"
echo "   Frontend: $([ "$FRONTEND_STATUS" = "200" ] && echo '✅ OK' || echo '⚠️  CHECK')"
echo ""
