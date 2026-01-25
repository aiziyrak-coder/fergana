#!/bin/bash
# Backend 500 xatoliklarni tuzatish va deploy qilish

echo "🔧 Backend o'zgarishlarini deploy qilish..."

# 1. Backend papkasiga o'tish
cd /var/www/smartcity-backend

# 2. Git pull - yangi o'zgarishlarni olish
echo "📥 Git pull qilmoqda..."
git pull origin master

# 3. O'zgarishlar bor-yo'qligini tekshirish
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  O'zgarishlar bor, lekin commit qilinmagan"
    git status
else
    echo "✅ Barcha o'zgarishlar commit qilingan"
fi

# 4. Gunicorn'ni restart qilish
echo "🔄 Gunicorn'ni restart qilmoqda..."
sudo systemctl restart smartcity-gunicorn

# 5. Gunicorn statusini tekshirish
echo "📊 Gunicorn status:"
sudo systemctl status smartcity-gunicorn --no-pager -l

# 6. Test
echo "🧪 Endpoint'larni test qilmoqda..."
echo ""
echo "1. Air Sensors:"
curl -s https://ferganaapi.cdcgroup.uz/api/air-sensors/ | head -c 200
echo ""
echo ""
echo "2. SOS Columns:"
curl -s https://ferganaapi.cdcgroup.uz/api/sos-columns/ | head -c 200
echo ""
echo ""
echo "3. IoT Devices (authentication talab qilmasligi kerak):"
curl -s https://ferganaapi.cdcgroup.uz/api/iot-devices/ | head -c 200
echo ""

echo "✅ Deploy tugadi!"
