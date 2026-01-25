#!/bin/bash
# Fix Nginx Conflicts - Faqat ferganaapi.cdcgroup.uz uchun sozlash
# Boshqa dasturlarga ta'sir qilmaslik uchun

echo "=========================================="
echo "🔧 FIXING NGINX CONFLICTS"
echo "=========================================="

# ============================================
# 1️⃣ BACKEND CONFIG - Faqat ferganaapi.cdcgroup.uz
# ============================================
echo ""
echo "1️⃣ Backend Nginx config'ni yaratish/yangilash..."

sudo tee /etc/nginx/sites-available/ferganaapi.cdcgroup.uz > /dev/null <<'EOF'
server {
    listen 80;
    server_name ferganaapi.cdcgroup.uz;

    client_max_body_size 20M;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 120s;
        proxy_send_timeout 120s;
        proxy_read_timeout 120s;
    }

    location /static/ {
        alias /var/www/smartcity-backend/static/;
        expires 30d;
        add_header Cache-Control "public";
    }

    location /media/ {
        alias /var/www/smartcity-backend/media/;
        expires 7d;
        add_header Cache-Control "public";
    }
}
EOF

echo "✅ Backend config yaratildi"

# ============================================
# 2️⃣ FRONTEND CONFIG - Faqat fergana.cdcgroup.uz
# ============================================
echo ""
echo "2️⃣ Frontend Nginx config'ni yaratish/yangilash..."

sudo tee /etc/nginx/sites-available/fergana.cdcgroup.uz > /dev/null <<'EOF'
server {
    listen 80;
    server_name fergana.cdcgroup.uz;

    root /var/www/html/smartcity;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /assets {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

echo "✅ Frontend config yaratildi"

# ============================================
# 3️⃣ ENABLE SITES - Faqat bizning site'lar
# ============================================
echo ""
echo "3️⃣ Site'larni enable qilish..."

# Enable our sites
sudo ln -sf /etc/nginx/sites-available/ferganaapi.cdcgroup.uz /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/fergana.cdcgroup.uz /etc/nginx/sites-enabled/

# Default site'ni o'chirish (agar conflict bo'lsa)
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo "⚠️ Default site mavjud, o'chirilmoqda..."
    sudo rm -f /etc/nginx/sites-enabled/default
fi

# Boshqa conflict'li site'larni topish va o'chirish
echo ""
echo "4️⃣ Conflict'li site'larni tekshirish..."

# ferganaapi yoki fergana bilan bog'liq bo'lmagan site'larni ko'rsatish
CONFLICT_SITES=$(ls /etc/nginx/sites-enabled/ 2>/dev/null | grep -v "ferganaapi\|fergana" || true)

if [ ! -z "$CONFLICT_SITES" ]; then
    echo "⚠️ Quyidagi site'lar mavjud (conflict bo'lishi mumkin):"
    echo "$CONFLICT_SITES"
    echo ""
    echo "⚠️ Iltimos, boshqa dasturlar uchun site'larni qo'lda tekshiring!"
    echo "   Boshqa dasturlar uchun site'lar /etc/nginx/sites-available/ da saqlanadi"
    echo "   Faqat bizning site'lar enable qilingan"
else
    echo "✅ Conflict'li site'lar topilmadi"
fi

# ============================================
# 5️⃣ NGINX TEST VA RELOAD
# ============================================
echo ""
echo "5️⃣ Nginx config'ni tekshirish..."

if sudo nginx -t; then
    echo "✅ Nginx config to'g'ri"
    
    echo ""
    echo "6️⃣ Nginx'ni reload qilish..."
    sudo systemctl reload nginx
    
    if [ $? -eq 0 ]; then
        echo "✅ Nginx reload muvaffaqiyatli"
    else
        echo "❌ Nginx reload xatosi"
        exit 1
    fi
else
    echo "❌ Nginx config xatosi!"
    echo "Iltimos, config'ni qo'lda tekshiring: sudo nginx -t"
    exit 1
fi

# ============================================
# 7️⃣ TEKSHIRISH
# ============================================
echo ""
echo "=========================================="
echo "✅ NGINX CONFLICT FIX COMPLETE"
echo "=========================================="
echo ""
echo "Enabled sites:"
ls -la /etc/nginx/sites-enabled/ | grep -v "^total"
echo ""
echo "Test qilish:"
echo "  curl http://ferganaapi.cdcgroup.uz/api/auth/validate/"
echo "  curl http://fergana.cdcgroup.uz"
echo ""
echo "⚠️ Eslatma: Boshqa dasturlar uchun site'lar /etc/nginx/sites-available/ da"
echo "   saqlanadi va zarurat bo'lsa qo'lda enable qilishingiz mumkin"
echo ""
