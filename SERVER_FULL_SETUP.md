# 🚀 Server'ni Noldan Setup Qilish

## 📋 Hozirgi Holat
Server'da hech narsa yo'q. Biz noldan setup qilamiz.

---

## 1️⃣ Server Ma'lumotlari
- **IP:** 167.71.53.238
- **OS:** Ubuntu
- **User:** root

---

## 2️⃣ Kerakli Package'larni O'rnatish

```bash
# SSH ulanish
ssh root@167.71.53.238

# System update
sudo apt update && sudo apt upgrade -y

# Python va kerakli tools
sudo apt install -y python3 python3-pip python3-venv

# Node.js va npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Nginx
sudo apt install -y nginx

# Git
sudo apt install -y git

# Tekshirish
python3 --version
node --version
npm --version
nginx -v
git --version
```

---

## 3️⃣ Papkalarni Yaratish

```bash
# Asosiy papkalar
sudo mkdir -p /var/www/smartcity-backend
sudo mkdir -p /var/www/smartcity-frontend
sudo mkdir -p /var/www/html/smartcity

# Permissions
sudo chown -R $USER:$USER /var/www/smartcity-backend
sudo chown -R $USER:$USER /var/www/smartcity-frontend
sudo chown -R $USER:$USER /var/www/html/smartcity
```

---

## 4️⃣ Backend Setup

```bash
# Clone repository
cd /var/www
git clone https://github.com/aiziyrak-coder/shaxarApi.git smartcity-backend
cd smartcity-backend

# Virtual environment
python3 -m venv venv
source venv/bin/activate

# Dependencies
pip install -r requirements.txt

# Database setup
python manage.py migrate

# Create superuser (optional)
# python manage.py createsuperuser

# Superuser'larni yaratish (script bor)
python create_superusers.py

# Static files
python manage.py collectstatic --noinput

# Test
python manage.py runserver 0.0.0.0:8000
# CTRL+C to stop
```

---

## 5️⃣ Frontend Setup

```bash
# Clone repository
cd /var/www
git clone https://github.com/aiziyrak-coder/shaxar.git smartcity-frontend
cd smartcity-frontend

# Install dependencies
npm install

# Build
npm run build

# Copy to nginx directory
sudo cp -r dist/* /var/www/html/smartcity/
```

---

## 6️⃣ Gunicorn Setup

```bash
# Gunicorn o'rnatish
cd /var/www/smartcity-backend
source venv/bin/activate
pip install gunicorn

# Gunicorn service file
sudo nano /etc/systemd/system/gunicorn.service
```

**Service file mazmuni:**
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

**Serviceni ishga tushirish:**
```bash
sudo systemctl daemon-reload
sudo systemctl start gunicorn
sudo systemctl enable gunicorn
sudo systemctl status gunicorn
```

---

## 7️⃣ Nginx Configuration

### Backend (API)
```bash
sudo nano /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
```

**Config:**
```nginx
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
    }

    location /static/ {
        alias /var/www/smartcity-backend/static/;
    }

    location /media/ {
        alias /var/www/smartcity-backend/media/;
    }
}
```

### Frontend
```bash
sudo nano /etc/nginx/sites-available/fergana.cdcgroup.uz
```

**Config:**
```nginx
server {
    listen 80;
    server_name fergana.cdcgroup.uz;

    root /var/www/html/smartcity;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### Enable sites
```bash
# Symlinks yaratish
sudo ln -s /etc/nginx/sites-available/ferganaapi.cdcgroup.uz /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/fergana.cdcgroup.uz /etc/nginx/sites-enabled/

# Default site o'chirish (agar kerak bo'lsa)
sudo rm /etc/nginx/sites-enabled/default

# Test va restart
sudo nginx -t
sudo systemctl restart nginx
```

---

## 8️⃣ SSL Certificate (HTTPS)

```bash
# Certbot o'rnatish
sudo apt install -y certbot python3-certbot-nginx

# SSL olish (domenlar DNS bilan bog'langan bo'lishi kerak)
sudo certbot --nginx -d fergana.cdcgroup.uz
sudo certbot --nginx -d ferganaapi.cdcgroup.uz

# Auto-renewal
sudo certbot renew --dry-run
```

---

## 9️⃣ Test

### Services
```bash
sudo systemctl status gunicorn
sudo systemctl status nginx
```

### URL'lar
- Frontend: http://fergana.cdcgroup.uz (yoki https)
- Backend: http://ferganaapi.cdcgroup.uz (yoki https)
- Admin: http://ferganaapi.cdcgroup.uz/admin

### Login
- Username: `fergana`
- Password: `123`

---

## 🔟 Troubleshooting

### Gunicorn ishlamasa:
```bash
# Loglarni ko'rish
sudo journalctl -u gunicorn -f

# Manual test
cd /var/www/smartcity-backend
source venv/bin/activate
gunicorn smartcity_backend.wsgi:application
```

### Nginx xatosi:
```bash
# Error logs
sudo tail -f /var/log/nginx/error.log

# Config test
sudo nginx -t
```

### Permissions
```bash
sudo chown -R www-data:www-data /var/www/smartcity-backend/media
sudo chown -R www-data:www-data /var/www/smartcity-backend/static
```

---

## ✅ TEZKOR SETUP (Copy-Paste)

```bash
# 1. SSH
ssh root@167.71.53.238

# 2. Packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv git nginx
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 3. Papkalar
sudo mkdir -p /var/www/smartcity-backend /var/www/smartcity-frontend /var/www/html/smartcity

# 4. Backend
cd /var/www
git clone https://github.com/aiziyrak-coder/shaxarApi.git smartcity-backend
cd smartcity-backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python create_superusers.py
python manage.py collectstatic --noinput
pip install gunicorn

# 5. Frontend
cd /var/www
git clone https://github.com/aiziyrak-coder/shaxar.git smartcity-frontend
cd smartcity-frontend
npm install
npm run build
sudo cp -r dist/* /var/www/html/smartcity/

# 6. Services (manu config kerak - yuqorida)
# Gunicorn service file yarating
# Nginx config fayllarini yarating
# Services'ni restart qiling
```

---

**Vaqt:** ~20-30 daqiqa  
**Qiyinlik:** O'rta  
**Natija:** To'liq ishlaydigan server

Agar muammo bo'lsa, har bir bosqichni alohida-alohida bajaring!
