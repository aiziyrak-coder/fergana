#!/bin/bash
# ============================================
# ✅ Smart City Gunicorn Tekshirish (Boshqa loyihalarga ta'sir qilmasdan)
# ============================================

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     SMART CITY GUNICORN TEKSHIRISH (Xavfsiz)              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Faqat smartcity Gunicorn process'larini topish
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Smart City Gunicorn Process'lar"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

SMARTCITY_PIDS=$(pgrep -f "smartcity_backend.wsgi" | head -3)
if [ -n "$SMARTCITY_PIDS" ]; then
    echo "  ✅ Smart City Gunicorn: RUNNING"
    echo "  📊 PID'lar: $SMARTCITY_PIDS"
    ps aux | grep "smartcity_backend.wsgi" | grep -v grep
else
    echo "  ❌ Smart City Gunicorn: NOT RUNNING"
    echo "  🔧 Ishga tushirilmoqda..."
    cd /var/www/smartcity-backend
    source venv/bin/activate
    nohup gunicorn smartcity_backend.wsgi:application \
        --bind 127.0.0.1:8002 \
        --workers 2 \
        --timeout 120 \
        --access-logfile gunicorn-access.log \
        --error-logfile gunicorn-error.log \
        > gunicorn.log 2>&1 &
    sleep 3
    if pgrep -f "smartcity_backend.wsgi" > /dev/null; then
        echo "  ✅ Smart City Gunicorn ishga tushirildi!"
    else
        echo "  ❌ Ishga tushirishda muammo!"
    fi
fi

# Backend API test
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Backend API Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8002/api/organizations/)
if [ "$BACKEND_STATUS" = "200" ] || [ "$BACKEND_STATUS" = "401" ]; then
    echo "  ✅ Backend API: OK (Status: $BACKEND_STATUS)"
    echo "  📍 URL: http://localhost:8002/api/organizations/"
    if [ "$BACKEND_STATUS" = "401" ]; then
        echo "  ℹ️  401 - Authentication kerak (bu normal)"
    fi
else
    echo "  ❌ Backend API: FAILED (Status: $BACKEND_STATUS)"
fi

# Frontend test
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Frontend Test"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://fergana.cdcgroup.uz)
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "  ✅ Frontend: OK (Status: $FRONTEND_STATUS)"
    echo "  📍 URL: https://fergana.cdcgroup.uz"
else
    echo "  ⚠️  Frontend: Status $FRONTEND_STATUS"
fi

# Boshqa loyihalar (faqat ko'rsatish, hech narsa qilmaslik)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Boshqa Loyihalar (Faqat Ko'rsatish)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

OTHER_PROJECTS=$(pgrep -f gunicorn | wc -l)
SMARTCITY_COUNT=$(pgrep -f "smartcity_backend.wsgi" | wc -l)
echo "  📊 Jami Gunicorn process'lar: $OTHER_PROJECTS"
echo "  📊 Smart City process'lar: $SMARTCITY_COUNT"
echo "  ✅ Boshqa loyihalar: $(($OTHER_PROJECTS - $SMARTCITY_COUNT)) ta"

# Summary
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    YAKUNIY XULOSA                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Smart City Gunicorn: $([ -n "$SMARTCITY_PIDS" ] && echo 'RUNNING' || echo 'STOPPED')"
echo "✅ Backend API: $([ "$BACKEND_STATUS" = "200" ] || [ "$BACKEND_STATUS" = "401" ] && echo 'OK' || echo 'FAILED')"
echo "✅ Frontend: $([ "$FRONTEND_STATUS" = "200" ] && echo 'OK' || echo 'CHECK')"
echo "✅ Boshqa loyihalar: Hech qanday ta'sir qilinmadi"
echo ""
echo "🌐 URLs:"
echo "   Frontend: https://fergana.cdcgroup.uz"
echo "   Backend:  https://ferganaapi.cdcgroup.uz/api/organizations/"
echo ""
