#!/bin/bash
# ============================================
# 🔧 Deploy Muammolarini Hal Qilish
# ============================================

echo "╔════════════════════════════════════════════════════════════╗"
echo "║           DEPLOY MUAMMOLARINI HAL QILISH                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# ============================================
# STEP 1: FRONTEND - TypeScript O'rnatish
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 STEP 1: Frontend Dependencies (TypeScript)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd /var/www/smartcity-frontend

echo "  • Barcha dependencies o'rnatilmoqda (dev dependencies bilan)..."
npm install

echo "  • Build qilinmoqda..."
npm run build

if [ -d "dist" ]; then
    echo "  ✅ Build muvaffaqiyatli!"
    echo "  • Nginx papkasiga ko'chirilmoqda..."
    sudo cp -r dist/* /var/www/html/
    echo "  ✅ Frontend deploy qilindi!"
else
    echo "  ❌ Build muvaffaqiyatsiz!"
    exit 1
fi

# ============================================
# STEP 2: GUNICORN - Service Yaratish yoki Qo'lda Ishga Tushirish
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 STEP 2: Gunicorn Ishga Tushirish"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd /var/www/smartcity-backend
source venv/bin/activate

# Eski gunicorn process'larni to'xtatish
echo "  • Eski process'lar to'xtatilmoqda..."
pkill -9 gunicorn || true
sleep 2

# Gunicorn'ni qo'lda ishga tushirish
echo "  • Gunicorn ishga tushirilmoqda..."
nohup gunicorn smartcity_backend.wsgi:application \
    --bind 127.0.0.1:8002 \
    --workers 4 \
    --timeout 120 \
    --access-logfile gunicorn-access.log \
    --error-logfile gunicorn-error.log \
    > gunicorn.log 2>&1 &

sleep 3

# Tekshirish
if pgrep -f gunicorn > /dev/null; then
    echo "  ✅ Gunicorn: RUNNING"
    echo "  📊 PID: $(pgrep -f gunicorn | head -1)"
else
    echo "  ❌ Gunicorn: FAILED"
    echo "  📋 Log'lar:"
    tail -20 gunicorn-error.log 2>/dev/null || echo "  Log fayl topilmadi"
    exit 1
fi

# ============================================
# STEP 3: NGINX RESTART
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 STEP 3: Nginx Restart"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

sudo systemctl restart nginx
sleep 2

if systemctl is-active --quiet nginx; then
    echo "  ✅ Nginx: RUNNING"
else
    echo "  ❌ Nginx: FAILED"
    sudo systemctl status nginx
    exit 1
fi

# ============================================
# STEP 4: VERIFICATION
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ STEP 4: Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "  • Backend API tekshirilmoqda..."
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8002/api/organizations/ || echo "000")
if [ "$BACKEND_STATUS" = "200" ] || [ "$BACKEND_STATUS" = "401" ]; then
    echo "  ✅ Backend API: OK ($BACKEND_STATUS)"
else
    echo "  ⚠️  Backend API: Check manually (Status: $BACKEND_STATUS)"
fi

echo "  • Frontend tekshirilmoqda..."
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://fergana.cdcgroup.uz || echo "000")
if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "  ✅ Frontend: OK ($FRONTEND_STATUS)"
else
    echo "  ⚠️  Frontend: Check manually (Status: $FRONTEND_STATUS)"
fi

# ============================================
# SUMMARY
# ============================================
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    MUAMMOLAR HAL QILINDI                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Frontend: Build qilindi va deploy qilindi"
echo "✅ Gunicorn: Ishga tushirildi"
echo "✅ Nginx: Restart qilindi"
echo ""
echo "🌐 URLs:"
echo "   Frontend: https://fergana.cdcgroup.uz"
echo "   Backend:  https://ferganaapi.cdcgroup.uz"
echo ""
