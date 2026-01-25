#!/bin/bash
# Frontend yangilanishini deploy qilish

echo "=========================================="
echo "🚀 FRONTEND YANGILANISHINI DEPLOY QILISH"
echo "=========================================="

# ============================================
# 1️⃣ FRONTEND PAPKASIGA O'TISH
# ============================================
echo ""
echo "1️⃣ Frontend papkasiga o'tish..."

cd /var/www/smartcity-frontend

if [ $? -ne 0 ]; then
    echo "❌ Frontend papkasi topilmadi!"
    exit 1
fi

echo "✅ Frontend papkasiga o'tildi: $(pwd)"

# ============================================
# 2️⃣ GIT PULL - YANGI O'ZGARISHLARNI OLISH
# ============================================
echo ""
echo "2️⃣ Git pull - yangi o'zgarishlarni olish..."

git pull origin master

if [ $? -ne 0 ]; then
    echo "❌ Git pull xatosi!"
    exit 1
fi

echo "✅ Yangi o'zgarishlar olindi"

# ============================================
# 3️⃣ NODE MODULES TEKSHIRISH
# ============================================
echo ""
echo "3️⃣ Node modules tekshirish..."

if [ ! -d "node_modules" ]; then
    echo "⚠️ node_modules topilmadi, o'rnatilmoqda..."
    npm install
else
    echo "✅ node_modules mavjud"
fi

# ============================================
# 4️⃣ FRONTEND BUILD QILISH
# ============================================
echo ""
echo "4️⃣ Frontend build qilish..."

npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build xatosi!"
    exit 1
fi

echo "✅ Frontend build qilindi"

# ============================================
# 5️⃣ BUILD FAYLLARNI NGINX PAPKASIGA KO'CHIRISH
# ============================================
echo ""
echo "5️⃣ Build fayllarni Nginx papkasiga ko'chirish..."

# Nginx papkasini yaratish
sudo mkdir -p /var/www/html/smartcity

# Build fayllarni ko'chirish
sudo cp -r dist/* /var/www/html/smartcity/

# Ruxsatlarni to'g'rilash
sudo chown -R www-data:www-data /var/www/html/smartcity
sudo chmod -R 755 /var/www/html/smartcity

echo "✅ Build fayllar ko'chirildi"

# ============================================
# 6️⃣ NGINX RELOAD
# ============================================
echo ""
echo "6️⃣ Nginx reload..."

sudo systemctl reload nginx

if [ $? -eq 0 ]; then
    echo "✅ Nginx reload qilindi"
else
    echo "❌ Nginx reload xatosi!"
    exit 1
fi

# ============================================
# 7️⃣ TEKSHIRISH
# ============================================
echo ""
echo "=========================================="
echo "✅ FRONTEND DEPLOY TUGALLANDI"
echo "=========================================="
echo ""
echo "Test qilish:"
echo "  curl https://fergana.cdcgroup.uz"
echo ""
echo "Browser'da ochish:"
echo "  https://fergana.cdcgroup.uz"
echo ""
