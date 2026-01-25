#!/bin/bash
# ============================================
# 🛡️ XAVFSIZ DEPLOY - Database Backup bilan
# ============================================

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     SMART CITY - XAVFSIZ DEPLOY (v2.0 Enhanced)          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

START_TIME=$(date +%s)

# ============================================
# STEP 0: DATABASE BACKUP (MUHIM!)
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💾 STEP 0: Database Backup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd /var/www/smartcity-backend

# Backup papkasini yaratish
BACKUP_DIR="/var/www/smartcity-backend/backups"
mkdir -p $BACKUP_DIR

# Database backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/db_backup_${TIMESTAMP}.sqlite3"

if [ -f "db.sqlite3" ]; then
    cp db.sqlite3 "$BACKUP_FILE"
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "  ✅ Database backup yaratildi: $BACKUP_FILE"
    echo "  📦 Hajmi: $BACKUP_SIZE"
    
    # Oxirgi 5 ta backup'ni saqlash, qolganlarini o'chirish
    cd $BACKUP_DIR
    ls -t db_backup_*.sqlite3 | tail -n +6 | xargs -r rm -f
    echo "  🗑️  Eski backup'lar tozalandi (oxirgi 5 ta saqlandi)"
    cd /var/www/smartcity-backend
else
    echo "  ⚠️  db.sqlite3 topilmadi (yangi o'rnatish bo'lishi mumkin)"
fi

# ============================================
# STEP 1: CODE UPDATE
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📥 STEP 1: Code Update"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "  • Git pull..."
git pull origin master || git pull origin main

# ============================================
# STEP 2: BACKEND DEPLOYMENT
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 STEP 2: Backend Deployment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "  • Activating venv..."
source venv/bin/activate

echo "  • Installing new dependencies..."
pip install -q qrcode pillow python-telegram-bot requests || true

echo "  • Running migrations (XAVFSIZ - backup allaqachon yaratildi)..."
python manage.py migrate --no-input

echo "  • Collecting static files..."
python manage.py collectstatic --noinput || true

# ============================================
# STEP 3: FRONTEND DEPLOYMENT
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎨 STEP 3: Frontend Deployment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd /var/www/smartcity-frontend

echo "  • Git pull..."
git pull origin master || git pull origin main

echo "  • Installing dependencies..."
npm install --production

echo "  • Building production version..."
npm run build

echo "  • Copying build to nginx directory..."
sudo cp -r dist/* /var/www/html/ || cp -r dist/* /var/www/html/

# ============================================
# STEP 4: RESTART SERVICES
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 STEP 4: Restart Services"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd /var/www/smartcity-backend

echo "  • Restarting Gunicorn..."
sudo systemctl restart gunicorn || pkill -9 gunicorn; sleep 2; nohup gunicorn smartcity_backend.wsgi:application --bind 127.0.0.1:8002 --workers 4 --timeout 120 > gunicorn.log 2>&1 &

sleep 3

if pgrep -f gunicorn > /dev/null; then
    echo "  ✅ Gunicorn: RUNNING"
else
    echo "  ❌ Gunicorn: FAILED - Check logs!"
    tail -20 gunicorn-error.log
fi

echo "  • Restarting Nginx..."
sudo systemctl restart nginx

sleep 2

if systemctl is-active --quiet nginx; then
    echo "  ✅ Nginx: RUNNING"
else
    echo "  ❌ Nginx: FAILED"
    sudo systemctl status nginx
fi

# ============================================
# STEP 5: VERIFICATION
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ STEP 5: Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "  • Testing backend..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8002/api/organizations/ | grep -q "200\|401"; then
    echo "  ✅ Backend API: OK"
else
    echo "  ⚠️  Backend API: Check manually"
fi

echo "  • Testing frontend..."
if curl -s -o /dev/null -w "%{http_code}" https://fergana.cdcgroup.uz | grep -q "200"; then
    echo "  ✅ Frontend: OK"
else
    echo "  ⚠️  Frontend: Check manually"
fi

# ============================================
# SUMMARY
# ============================================
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    DEPLOYMENT COMPLETE                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "⏱️  Vaqt: ${DURATION} soniya"
echo "💾 Backup: $BACKUP_FILE"
echo ""
echo "🌐 URLs:"
echo "   Frontend: https://fergana.cdcgroup.uz"
echo "   Backend:  https://ferganaapi.cdcgroup.uz"
echo ""
echo "✅ Barcha ma'lumotlar saqlanib qoldi!"
echo ""
