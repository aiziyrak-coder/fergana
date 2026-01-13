# 🚀 Smart City Deployment Guide

## Server Ma'lumotlari
- **Server IP**: 167.71.53.238
- **Frontend**: https://fergana.cdcgroup.uz
- **Backend**: https://ferganaapi.cdcgroup.uz
- **Platform**: DigitalOcean

---

## 📋 Deploy Qilish Bosqichlari

### 1️⃣ Serverga Ulanish
```bash
ssh root@167.71.53.238
```

### 2️⃣ Repository'ni Yangilash

#### Backend
```bash
cd /var/www/smartcity-backend  # yoki qayerda joylashgan bo'lsa
git pull origin master
```

#### Frontend
```bash
cd /var/www/smartcity-frontend  # yoki qayerda joylashgan bo'lsa
git pull origin master
```

### 3️⃣ Backend Deploy

```bash
cd /var/www/smartcity-backend

# Virtual environment aktivlash
source venv/bin/activate

# Dependencies o'rnatish
pip install -r requirements.txt

# Migrations
python manage.py migrate

# Static files yig'ish
python manage.py collectstatic --noinput

# Gunicorn restart
sudo systemctl restart gunicorn
sudo systemctl restart nginx
```

### 4️⃣ Frontend Deploy

```bash
cd /var/www/smartcity-frontend

# Dependencies o'rnatish
npm install

# Build
npm run build

# Build fayllarni nginx papkasiga ko'chirish
sudo rm -rf /var/www/html/smartcity/*
sudo cp -r dist/* /var/www/html/smartcity/

# Nginx restart
sudo systemctl restart nginx
```

---

## 🔧 Kerakli Sozlamalar

### Backend Environment Variables
`/var/www/smartcity-backend/.env` faylini yarating:

```bash
DEBUG=False
SECRET_KEY=your-production-secret-key-here-very-long-and-random
ALLOWED_HOSTS=ferganaapi.cdcgroup.uz,167.71.53.238
```

### Nginx Configuration

**Frontend** (`/etc/nginx/sites-available/fergana.cdcgroup.uz`):
```nginx
server {
    listen 80;
    server_name fergana.cdcgroup.uz;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name fergana.cdcgroup.uz;

    ssl_certificate /etc/letsencrypt/live/fergana.cdcgroup.uz/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/fergana.cdcgroup.uz/privkey.pem;

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

**Backend** (`/etc/nginx/sites-available/ferganaapi.cdcgroup.uz`):
```nginx
server {
    listen 80;
    server_name ferganaapi.cdcgroup.uz;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name ferganaapi.cdcgroup.uz;

    ssl_certificate /etc/letsencrypt/live/ferganaapi.cdcgroup.uz/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ferganaapi.cdcgroup.uz/privkey.pem;

    client_max_body_size 20M;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static/ {
        alias /var/www/smartcity-backend/static/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    location /media/ {
        alias /var/www/smartcity-backend/media/;
        expires 7d;
    }
}
```

### Gunicorn Service

`/etc/systemd/system/gunicorn.service`:
```ini
[Unit]
Description=Gunicorn daemon for Smart City Backend
After=network.target

[Service]
User=root
Group=www-data
WorkingDirectory=/var/www/smartcity-backend
Environment="PATH=/var/www/smartcity-backend/venv/bin"
ExecStart=/var/www/smartcity-backend/venv/bin/gunicorn \
    --workers 3 \
    --bind 127.0.0.1:8000 \
    --timeout 120 \
    smartcity_backend.wsgi:application

[Install]
WantedBy=multi-user.target
```

---

## 🔄 Quick Deploy Script

`deploy.sh` faylini yarating:

```bash
#!/bin/bash

echo "🚀 Starting deployment..."

# Backend
echo "📦 Deploying Backend..."
cd /var/www/smartcity-backend
git pull origin master
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
sudo systemctl restart gunicorn

# Frontend
echo "🎨 Deploying Frontend..."
cd /var/www/smartcity-frontend
git pull origin master
npm install
npm run build
sudo rm -rf /var/www/html/smartcity/*
sudo cp -r dist/* /var/www/html/smartcity/

# Restart services
echo "🔄 Restarting services..."
sudo systemctl restart nginx

echo "✅ Deployment completed!"
```

Uni ishga tushiring:
```bash
chmod +x deploy.sh
./deploy.sh
```

---

## 🐛 Debugging

### Loglarni ko'rish
```bash
# Nginx error logs
sudo tail -f /var/log/nginx/error.log

# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Gunicorn logs
sudo journalctl -u gunicorn -f

# Django logs
tail -f /var/www/smartcity-backend/django.log
```

### Service holatini tekshirish
```bash
sudo systemctl status nginx
sudo systemctl status gunicorn
```

### Port tekshirish
```bash
sudo netstat -tulpn | grep :8000
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443
```

---

## 📝 O'zgartirishlar

### O'zgartirilgan fayllar:
1. ✅ `frontend/services/api.ts` - API URL tuzatildi
2. ✅ `frontend/services/auth.ts` - API URL tuzatildi
3. ✅ `backend/smartcity_backend/settings.py` - CORS, CSRF, ALLOWED_HOSTS
4. ✅ Security sozlamalari qo'shildi (HTTPS cookies)

### GitHub'ga push qilish:
```bash
# Backend
cd /path/to/smartApiFull
git add .
git commit -m "Fix: Update production URLs and CORS settings"
git push origin master

# Frontend
cd /path/to/smartFrontFull
git add .
git commit -m "Fix: Update API URLs for production"
git push origin master
```

---

## 🔐 Login Ma'lumotlari
- **Django Admin**: admin / 123
- **Farg'ona Shahar**: fergan / 123

---

**Developer:** CDCGroup  
**Last Updated:** January 2026
