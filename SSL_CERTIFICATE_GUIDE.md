# 🔒 SSL Certificate Fix Qo'llanmasi

## 🐛 Muammo
- HTTPS qizil ko'rsatilmoqda (SSL sertifikati yo'q)
- Bad Request 400 qaytarmoqda
- SSL sertifikatlari mavjud emas yoki eskirgan

---

## 🔧 Yechim

### Variant 1: Avtomatik Script

```bash
cd /var/www/smartcity-backend
wget https://raw.githubusercontent.com/aiziyrak-coder/shaxarApi/master/FIX_SSL_CERTIFICATES.sh
chmod +x FIX_SSL_CERTIFICATES.sh
sudo ./FIX_SSL_CERTIFICATES.sh
```

### Variant 2: Qo'lda (Step-by-step)

#### 1. Certbot O'rnatish

```bash
# Certbot o'rnatish
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx
```

#### 2. SSL Sertifikatlarni Yaratish

```bash
# Backend uchun SSL sertifikat yaratish
sudo certbot --nginx -d ferganaapi.cdcgroup.uz --non-interactive --agree-tos --email admin@cdcgroup.uz --redirect

# Frontend uchun SSL sertifikat yaratish
sudo certbot --nginx -d fergana.cdcgroup.uz --non-interactive --agree-tos --email admin@cdcgroup.uz --redirect
```

#### 3. Nginx Config'ni SSL Uchun Yangilash

**Backend Config** (`/etc/nginx/sites-available/ferganaapi.cdcgroup.uz`):

```nginx
# HTTP to HTTPS redirect
server {
    listen 80;
    server_name ferganaapi.cdcgroup.uz;
    return 301 https://$server_name$request_uri;
}

# HTTPS server
server {
    listen 443 ssl http2;
    server_name ferganaapi.cdcgroup.uz;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/ferganaapi.cdcgroup.uz/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ferganaapi.cdcgroup.uz/privkey.pem;
    
    # SSL Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    client_max_body_size 20M;

    location / {
        proxy_pass http://127.0.0.1:8002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        proxy_connect_timeout 120s;
        proxy_send_timeout 120s;
        proxy_read_timeout 120s;
    }

    location /static/ {
        alias /var/www/smartcity-backend/static/;
        expires 30d;
    }

    location /media/ {
        alias /var/www/smartcity-backend/media/;
        expires 7d;
    }
}
```

**Frontend Config** (`/etc/nginx/sites-available/fergana.cdcgroup.uz`):

```nginx
# HTTP to HTTPS redirect
server {
    listen 80;
    server_name fergana.cdcgroup.uz;
    return 301 https://$server_name$request_uri;
}

# HTTPS server
server {
    listen 443 ssl http2;
    server_name fergana.cdcgroup.uz;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/fergana.cdcgroup.uz/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/fergana.cdcgroup.uz/privkey.pem;
    
    # SSL Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

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

#### 4. Nginx Test va Reload

```bash
# Test
sudo nginx -t

# Reload
sudo systemctl reload nginx
```

---

## 🔍 Tekshirish

### 1. SSL Sertifikat Mavjudligini Tekshirish

```bash
# Backend sertifikat
ls -la /etc/letsencrypt/live/ferganaapi.cdcgroup.uz/

# Frontend sertifikat
ls -la /etc/letsencrypt/live/fergana.cdcgroup.uz/

# Sertifikat muddatini tekshirish
sudo openssl x509 -enddate -noout -in /etc/letsencrypt/live/ferganaapi.cdcgroup.uz/fullchain.pem
sudo openssl x509 -enddate -noout -in /etc/letsencrypt/live/fergana.cdcgroup.uz/fullchain.pem
```

### 2. HTTPS Test

```bash
# Backend HTTPS test
curl https://ferganaapi.cdcgroup.uz/api/auth/validate/

# Frontend HTTPS test
curl https://fergana.cdcgroup.uz

# SSL sertifikat tekshirish
openssl s_client -connect ferganaapi.cdcgroup.uz:443 -servername ferganaapi.cdcgroup.uz < /dev/null 2>/dev/null | openssl x509 -noout -dates
```

---

## 🐛 Muammo Bo'lsa

### Certbot Xatosi

```bash
# Certbot log'larni tekshirish
sudo tail -50 /var/log/letsencrypt/letsencrypt.log

# Certbot'ni qayta ishga tushirish
sudo certbot renew --dry-run
```

### Domain Validation Xatosi

```bash
# Domain DNS'ni tekshirish
nslookup ferganaapi.cdcgroup.uz
nslookup fergana.cdcgroup.uz

# Domain to'g'ri IP'ga point qilayotganini tekshirish
# Kutilayotgan: 167.71.53.238
```

### Nginx SSL Xatosi

```bash
# Nginx error log
sudo tail -50 /var/log/nginx/error.log

# SSL sertifikat ruxsatlarini tekshirish
sudo ls -la /etc/letsencrypt/live/ferganaapi.cdcgroup.uz/
sudo chmod 755 /etc/letsencrypt/live/
sudo chmod 755 /etc/letsencrypt/archive/
```

---

## 📝 Qisqa Copy-Paste Buyruqlar

```bash
# 1. Certbot o'rnatish
sudo apt-get update && sudo apt-get install -y certbot python3-certbot-nginx

# 2. SSL sertifikatlar yaratish
sudo certbot --nginx -d ferganaapi.cdcgroup.uz --non-interactive --agree-tos --email admin@cdcgroup.uz --redirect
sudo certbot --nginx -d fergana.cdcgroup.uz --non-interactive --agree-tos --email admin@cdcgroup.uz --redirect

# 3. Nginx test va reload
sudo nginx -t && sudo systemctl reload nginx

# 4. Test
curl https://ferganaapi.cdcgroup.uz/api/auth/validate/
curl https://fergana.cdcgroup.uz
```

---

## ⚠️ Muhim Eslatmalar

1. **Domain DNS**: Domain'lar to'g'ri IP'ga (167.71.53.238) point qilishi kerak
2. **Port 80**: Port 80 ochiq bo'lishi kerak (Let's Encrypt validation uchun)
3. **Email**: Certbot email so'raydi, to'g'ri email kiriting
4. **Auto-renewal**: Certbot avtomatik renewal qiladi (cron job)

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
