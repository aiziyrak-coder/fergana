#!/bin/bash
# Frontend Deploy Script

echo "=========================================="
echo "🚀 DEPLOYING FRONTEND"
echo "=========================================="

# ============================================
# 1️⃣ FRONTEND PAPKASIGA O'TISH
# ============================================
echo ""
echo "1️⃣ Navigating to frontend directory..."

cd /var/www/smartcity-frontend || {
    echo "❌ Frontend directory not found: /var/www/smartcity-frontend"
    echo "Creating directory..."
    sudo mkdir -p /var/www/smartcity-frontend
    cd /var/www/smartcity-frontend
}

# ============================================
# 2️⃣ GIT'DAN YANGILASH
# ============================================
echo ""
echo "2️⃣ Pulling latest changes from Git..."

if [ -d ".git" ]; then
    git pull origin master
    if [ $? -ne 0 ]; then
        echo "⚠️ Git pull failed, continuing with existing code..."
    else
        echo "✅ Git pull successful"
    fi
else
    echo "⚠️ Not a git repository, skipping git pull"
fi

# ============================================
# 3️⃣ DEPENDENCIES YANGILASH
# ============================================
echo ""
echo "3️⃣ Installing/updating dependencies..."

if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
else
    echo "Updating dependencies..."
    npm install
fi

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

# ============================================
# 4️⃣ BUILD QILISH
# ============================================
echo ""
echo "4️⃣ Building frontend..."

# Eski build'ni o'chirish
if [ -d "dist" ]; then
    echo "Removing old build..."
    rm -rf dist
fi

# Yangi build yaratish
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build successful"
else
    echo "❌ Build failed"
    exit 1
fi

# ============================================
# 5️⃣ BUILD FAYLLARNI NGINX'GA KO'CHIRISH
# ============================================
echo ""
echo "5️⃣ Copying build files to nginx directory..."

# Nginx directory'ni yaratish (agar yo'q bo'lsa)
sudo mkdir -p /var/www/html/smartcity

# Eski fayllarni backup qilish (ixtiyoriy)
if [ -d "/var/www/html/smartcity" ] && [ "$(ls -A /var/www/html/smartcity)" ]; then
    echo "Creating backup..."
    sudo cp -r /var/www/html/smartcity /var/www/html/smartcity.backup.$(date +%Y%m%d_%H%M%S)
fi

# Yangi build'ni ko'chirish
echo "Copying new build..."
sudo cp -r dist/* /var/www/html/smartcity/

# Ruxsatlarni to'g'rilash
sudo chown -R www-data:www-data /var/www/html/smartcity
sudo chmod -R 755 /var/www/html/smartcity

echo "✅ Build files copied"

# ============================================
# 6️⃣ NGINX RELOAD
# ============================================
echo ""
echo "6️⃣ Reloading Nginx..."

sudo nginx -t && sudo systemctl reload nginx

if [ $? -eq 0 ]; then
    echo "✅ Nginx reloaded"
else
    echo "⚠️ Nginx reload had issues, but continuing..."
fi

# ============================================
# 7️⃣ TEKSHIRISH
# ============================================
echo ""
echo "=========================================="
echo "✅ FRONTEND DEPLOY COMPLETE"
echo "=========================================="
echo ""
echo "Test commands:"
echo "  curl http://fergana.cdcgroup.uz"
echo "  curl -I http://fergana.cdcgroup.uz"
echo ""
echo "Build location: /var/www/html/smartcity"
echo ""
