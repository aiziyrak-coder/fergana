#!/bin/bash
# Fix Nginx Duplicate server_name - Faqat bizning config'larni qoldirish

echo "=========================================="
echo "🔧 FIXING NGINX DUPLICATES"
echo "=========================================="

# ============================================
# 1️⃣ DUPLICATE'LARNI TOPISH
# ============================================
echo ""
echo "1️⃣ Finding duplicate server_name configs..."

echo ""
echo "ferganaapi.cdcgroup.uz configs:"
sudo grep -r "server_name.*ferganaapi.cdcgroup.uz" /etc/nginx/sites-enabled/ 2>/dev/null

echo ""
echo "fergana.cdcgroup.uz configs:"
sudo grep -r "server_name.*fergana.cdcgroup.uz" /etc/nginx/sites-enabled/ 2>/dev/null

# ============================================
# 2️⃣ BIZNING CONFIG'LARNI TOPISH
# ============================================
echo ""
echo "2️⃣ Identifying our config files..."

OUR_BACKEND="/etc/nginx/sites-enabled/ferganaapi.cdcgroup.uz"
OUR_FRONTEND="/etc/nginx/sites-enabled/fergana.cdcgroup.uz"

# ============================================
# 3️⃣ DUPLICATE'LARNI O'CHIRISH
# ============================================
echo ""
echo "3️⃣ Removing duplicate configs..."

# Find all files with ferganaapi.cdcgroup.uz
FERGANAAPI_FILES=$(sudo grep -l "server_name.*ferganaapi.cdcgroup.uz" /etc/nginx/sites-enabled/* 2>/dev/null)

# Find all files with fergana.cdcgroup.uz
FERGANA_FILES=$(sudo grep -l "server_name.*fergana.cdcgroup.uz" /etc/nginx/sites-enabled/* 2>/dev/null)

# Remove duplicates (keep only our files)
for file in $FERGANAAPI_FILES; do
    if [ "$file" != "$OUR_BACKEND" ] && [ -L "$file" ]; then
        echo "⚠️ Removing duplicate: $file"
        sudo rm -f "$file"
    fi
done

for file in $FERGANA_FILES; do
    if [ "$file" != "$OUR_FRONTEND" ] && [ -L "$file" ]; then
        echo "⚠️ Removing duplicate: $file"
        sudo rm -f "$file"
    fi
done

# ============================================
# 4️⃣ ESHKI CONFIG'LARNI TEKSHIRISH
# ============================================
echo ""
echo "4️⃣ Checking for old configs (fergana, ferganaapi without .cdcgroup.uz)..."

# Check if old configs exist and might conflict
OLD_FERGANAAPI=$(ls /etc/nginx/sites-enabled/ | grep "^ferganaapi$" || true)
OLD_FERGANA=$(ls /etc/nginx/sites-enabled/ | grep "^fergana$" || true)

if [ ! -z "$OLD_FERGANAAPI" ]; then
    echo "⚠️ Found old config: ferganaapi (might conflict)"
    echo "   Checking if it has ferganaapi.cdcgroup.uz..."
    if sudo grep -q "server_name.*ferganaapi.cdcgroup.uz" /etc/nginx/sites-enabled/ferganaapi 2>/dev/null; then
        echo "   ⚠️ This file also has ferganaapi.cdcgroup.uz, disabling it..."
        sudo rm -f /etc/nginx/sites-enabled/ferganaapi
    else
        echo "   ✅ This file doesn't conflict (different domain)"
    fi
fi

if [ ! -z "$OLD_FERGANA" ]; then
    echo "⚠️ Found old config: fergana (might conflict)"
    echo "   Checking if it has fergana.cdcgroup.uz..."
    if sudo grep -q "server_name.*fergana.cdcgroup.uz" /etc/nginx/sites-enabled/fergana 2>/dev/null; then
        echo "   ⚠️ This file also has fergana.cdcgroup.uz, disabling it..."
        sudo rm -f /etc/nginx/sites-enabled/fergana
    else
        echo "   ✅ This file doesn't conflict (different domain)"
    fi
fi

# ============================================
# 5️⃣ NGINX TEST
# ============================================
echo ""
echo "5️⃣ Testing Nginx config..."

if sudo nginx -t 2>&1 | grep -q "conflicting server name"; then
    echo "⚠️ Still have conflicts, showing details:"
    sudo nginx -t 2>&1 | grep "conflicting server name"
    echo ""
    echo "Please check manually:"
    echo "  sudo grep -r 'server_name.*ferganaapi.cdcgroup.uz' /etc/nginx/sites-enabled/"
    echo "  sudo grep -r 'server_name.*fergana.cdcgroup.uz' /etc/nginx/sites-enabled/"
else
    echo "✅ No conflicts found!"
    
    echo ""
    echo "6️⃣ Reloading Nginx..."
    sudo systemctl reload nginx
    
    if [ $? -eq 0 ]; then
        echo "✅ Nginx reloaded successfully"
    else
        echo "❌ Nginx reload failed"
        exit 1
    fi
fi

# ============================================
# 7️⃣ FINAL CHECK
# ============================================
echo ""
echo "=========================================="
echo "✅ DUPLICATE FIX COMPLETE"
echo "=========================================="
echo ""
echo "Enabled configs for our domains:"
ls -la /etc/nginx/sites-enabled/ | grep -E "ferganaapi\.cdcgroup\.uz|fergana\.cdcgroup\.uz"
echo ""
echo "Test commands:"
echo "  curl http://ferganaapi.cdcgroup.uz/api/auth/validate/"
echo "  curl http://fergana.cdcgroup.uz"
echo ""
