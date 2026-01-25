#!/bin/bash
# Fix Server Deployment Issues
# This script fixes Pillow installation and Gunicorn service issues

echo "=========================================="
echo "🔧 FIXING SERVER DEPLOYMENT ISSUES"
echo "=========================================="

cd /var/www/smartcity-backend
source venv/bin/activate

# ============================================
# 1️⃣ FIX PILLOW - Update to compatible version
# ============================================
echo ""
echo "1️⃣ Fixing Pillow installation..."

# Uninstall old Pillow
pip uninstall -y Pillow 2>/dev/null || true

# Install compatible Pillow version for Python 3.13
echo "Installing Pillow 10.4.0 (compatible with Python 3.13)..."
pip install --upgrade Pillow>=10.4.0

if [ $? -eq 0 ]; then
    echo "✅ Pillow installed successfully"
else
    echo "⚠️ Pillow installation had issues, trying alternative..."
    pip install --upgrade Pillow --no-cache-dir
fi

# ============================================
# 2️⃣ FIX GUNICORN SERVICE
# ============================================
echo ""
echo "2️⃣ Fixing Gunicorn service..."

# Check if gunicorn service exists
if systemctl list-unit-files | grep -q "gunicorn.service"; then
    echo "✅ Gunicorn service found"
    SERVICE_NAME="gunicorn"
elif systemctl list-unit-files | grep -q "smartcity"; then
    echo "✅ Smartcity service found"
    SERVICE_NAME=$(systemctl list-unit-files | grep smartcity | head -1 | awk '{print $1}')
else
    echo "⚠️ Gunicorn service not found, checking running processes..."
    
    # Check if gunicorn is running
    if pgrep -f gunicorn > /dev/null; then
        echo "✅ Gunicorn is running as process"
        echo "Killing old gunicorn processes..."
        pkill -9 gunicorn
        sleep 2
    fi
    
    # Start gunicorn manually
    echo "Starting gunicorn manually..."
    cd /var/www/smartcity-backend
    source venv/bin/activate
    
    # Kill any existing gunicorn on port 8000 or 8002
    lsof -ti:8000 | xargs kill -9 2>/dev/null || true
    lsof -ti:8002 | xargs kill -9 2>/dev/null || true
    sleep 1
    
    # Start gunicorn in background
    nohup gunicorn smartcity_backend.wsgi:application \
        --bind 127.0.0.1:8000 \
        --workers 4 \
        --timeout 120 \
        --access-logfile /var/www/smartcity-backend/gunicorn-access.log \
        --error-logfile /var/www/smartcity-backend/gunicorn-error.log \
        --log-level info \
        > /var/www/smartcity-backend/gunicorn.log 2>&1 &
    
    echo "✅ Gunicorn started manually on port 8000"
    sleep 3
    
    # Verify gunicorn is running
    if pgrep -f gunicorn > /dev/null; then
        echo "✅ Gunicorn is running: PID $(pgrep -f gunicorn | head -1)"
    else
        echo "❌ Failed to start gunicorn, check logs:"
        tail -20 /var/www/smartcity-backend/gunicorn-error.log
        exit 1
    fi
    
    SERVICE_NAME="manual"
fi

# If service exists, restart it
if [ "$SERVICE_NAME" != "manual" ]; then
    echo "Restarting $SERVICE_NAME service..."
    sudo systemctl daemon-reload
    sudo systemctl restart $SERVICE_NAME
    
    if [ $? -eq 0 ]; then
        echo "✅ $SERVICE_NAME service restarted"
        sudo systemctl status $SERVICE_NAME --no-pager -l
    else
        echo "⚠️ Failed to restart service, starting manually..."
        pkill -9 gunicorn
        sleep 2
        nohup gunicorn smartcity_backend.wsgi:application \
            --bind 127.0.0.1:8000 \
            --workers 4 \
            --timeout 120 \
            --access-logfile /var/www/smartcity-backend/gunicorn-access.log \
            --error-logfile /var/www/smartcity-backend/gunicorn-error.log \
            > /var/www/smartcity-backend/gunicorn.log 2>&1 &
        echo "✅ Gunicorn started manually"
    fi
fi

# ============================================
# 3️⃣ VERIFY INSTALLATION
# ============================================
echo ""
echo "3️⃣ Verifying installation..."

# Check Pillow
python3 -c "import PIL; print(f'✅ Pillow version: {PIL.__version__}')" 2>/dev/null || echo "❌ Pillow import failed"

# Check Gunicorn
if pgrep -f gunicorn > /dev/null; then
    echo "✅ Gunicorn is running"
    echo "   PID: $(pgrep -f gunicorn | head -1)"
    echo "   Port: $(netstat -tlnp 2>/dev/null | grep gunicorn | awk '{print $4}' | head -1)"
else
    echo "❌ Gunicorn is not running"
fi

# Test API
echo ""
echo "Testing API endpoint..."
sleep 2
API_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/api/auth/validate/ 2>/dev/null || echo "000")
if [ "$API_RESPONSE" = "200" ] || [ "$API_RESPONSE" = "401" ]; then
    echo "✅ API is responding (HTTP $API_RESPONSE)"
else
    echo "⚠️ API test failed (HTTP $API_RESPONSE)"
    echo "   Check logs: tail -f /var/www/smartcity-backend/gunicorn-error.log"
fi

# ============================================
# 4️⃣ RELOAD NGINX
# ============================================
echo ""
echo "4️⃣ Reloading Nginx..."
sudo nginx -t && sudo systemctl reload nginx
if [ $? -eq 0 ]; then
    echo "✅ Nginx reloaded"
else
    echo "⚠️ Nginx reload failed, check config: sudo nginx -t"
fi

echo ""
echo "=========================================="
echo "✅ DEPLOYMENT FIX COMPLETE"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Check API: curl https://ferganaapi.cdcgroup.uz/api/auth/validate/"
echo "2. Check logs: tail -f /var/www/smartcity-backend/gunicorn-error.log"
echo "3. Check status: systemctl status $SERVICE_NAME (if service exists)"
echo ""
