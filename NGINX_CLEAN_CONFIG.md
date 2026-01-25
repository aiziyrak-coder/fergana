# 🔧 Nginx Config - Boshqa Dasturlarga Ta'sir Qilmaslik

## 🎯 Maqsad
Faqat `ferganaapi.cdcgroup.uz` va `fergana.cdcgroup.uz` uchun sozlash.
Boshqa dasturlarga ta'sir qilmaslik.

---

## 📝 Backend Config (ferganaapi.cdcgroup.uz)

**Fayl**: `/etc/nginx/sites-available/ferganaapi.cdcgroup.uz`

```nginx
server {
    listen 80;
    server_name ferganaapi.cdcgroup.uz;  # Faqat bu domain

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
```

---

## 📝 Frontend Config (fergana.cdcgroup.uz)

**Fayl**: `/etc/nginx/sites-available/fergana.cdcgroup.uz`

```nginx
server {
    listen 80;
    server_name fergana.cdcgroup.uz;  # Faqat bu domain

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
```

---

## 🔧 Serverda Bajarish

### Variant 1: Avtomatik Script

```bash
cd /var/www/smartcity-backend
wget https://raw.githubusercontent.com/aiziyrak-coder/shaxarApi/master/FIX_NGINX_CONFLICTS.sh
# yoki local'dan ko'chirish
chmod +x FIX_NGINX_CONFLICTS.sh
sudo ./FIX_NGINX_CONFLICTS.sh
```

### Variant 2: Qo'lda

```bash
# 1. Backend config
sudo nano /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
# Yuqoridagi backend config'ni yozing

# 2. Frontend config
sudo nano /etc/nginx/sites-available/fergana.cdcgroup.uz
# Yuqoridagi frontend config'ni yozing

# 3. Enable sites
sudo ln -sf /etc/nginx/sites-available/ferganaapi.cdcgroup.uz /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/fergana.cdcgroup.uz /etc/nginx/sites-enabled/

# 4. Default site'ni o'chirish (agar conflict bo'lsa)
sudo rm -f /etc/nginx/sites-enabled/default

# 5. Test va reload
sudo nginx -t
sudo systemctl reload nginx
```

---

## 🔍 Tekshirish

### 1. Enabled Site'larni Ko'rish

```bash
ls -la /etc/nginx/sites-enabled/
```

**Kutilayotgan natija:**
- `ferganaapi.cdcgroup.uz` ✅
- `fergana.cdcgroup.uz` ✅
- Boshqa site'lar (boshqa dasturlar uchun) - ularga ta'sir qilmaydi

### 2. Config Test

```bash
sudo nginx -t
```

**Kutilayotgan natija:**
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

**Agar warning bo'lsa:**
```
[warn] conflicting server name "ferganaapi.cdcgroup.uz" on 0.0.0.0:80, ignored
```

Bu warning boshqa config faylida ham `ferganaapi.cdcgroup.uz` borligini ko'rsatadi. Quyidagilarni tekshiring:

```bash
# Barcha config fayllarda ferganaapi'ni qidirish
sudo grep -r "server_name.*ferganaapi" /etc/nginx/

# Duplicate'ni topish va o'chirish
sudo nano /etc/nginx/sites-available/ferganaapi.cdcgroup.uz.old  # agar mavjud bo'lsa
sudo rm /etc/nginx/sites-enabled/ferganaapi.cdcgroup.uz.old  # agar enable qilingan bo'lsa
```

### 3. API Test

```bash
# Backend test
curl http://ferganaapi.cdcgroup.uz/api/auth/validate/
# Kutilayotgan: {"valid":false,"error":"No valid authentication"}

# Frontend test
curl http://fergana.cdcgroup.uz
# Kutilayotgan: HTML content
```

---

## ⚠️ Muhim Eslatmalar

1. **Boshqa Dasturlar**: Boshqa dasturlar uchun site'lar `/etc/nginx/sites-available/` da saqlanadi va zarurat bo'lsa qo'lda enable qilishingiz mumkin.

2. **Default Site**: Agar `default` site conflict qilsa, uni o'chirish mumkin:
   ```bash
   sudo rm -f /etc/nginx/sites-enabled/default
   ```

3. **SSL**: Agar SSL kerak bo'lsa, keyinroq qo'shishingiz mumkin. Hozircha HTTP ishlaydi.

4. **Port Conflict**: Agar 8000 port boshqa dastur tomonidan ishlatilsa, Gunicorn'ni boshqa port'ga o'zgartirishingiz kerak:
   ```bash
   # Service file'ni tahrirlash
   sudo nano /etc/systemd/system/smartcity-gunicorn.service
   # --bind 127.0.0.1:8000 ni o'zgartirish
   ```

---

## 🐛 Muammo Bo'lsa

### Warning: "conflicting server name"

```bash
# Barcha config'larda qidirish
sudo grep -r "server_name" /etc/nginx/sites-enabled/

# Duplicate'ni topish va o'chirish
# Yoki bitta config'ni disable qilish
sudo rm /etc/nginx/sites-enabled/conflict-site.conf
```

### Nginx reload xatosi

```bash
# Xatolikni ko'rish
sudo nginx -t

# Log'larni tekshirish
sudo tail -50 /var/log/nginx/error.log

# Config'ni qayta tekshirish
sudo nginx -T | grep -A 10 "ferganaapi"
```

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
