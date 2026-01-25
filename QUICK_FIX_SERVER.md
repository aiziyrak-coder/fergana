# 🔧 Server Muammolarini Hal Qilish

## ❌ Muammolar:

1. **`tsc: not found`** - TypeScript compiler topilmadi
2. **`gunicorn.service not found`** - Gunicorn service topilmadi

---

## ✅ HAL QILISH

### 1️⃣ Frontend - TypeScript O'rnatish

```bash
cd /var/www/smartcity-frontend

# Production emas, barcha dependencies (dev dependencies bilan)
npm install

# Build qilish
npm run build

# Nginx papkasiga ko'chirish
sudo cp -r dist/* /var/www/html/
```

**Sabab:** `npm install --production` faqat production dependencies o'rnatadi, lekin build uchun TypeScript (dev dependency) kerak.

---

### 2️⃣ Gunicorn - Qo'lda Ishga Tushirish

```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Eski process'larni to'xtatish
pkill -9 gunicorn || true
sleep 2

# Gunicorn'ni ishga tushirish
nohup gunicorn smartcity_backend.wsgi:application \
    --bind 127.0.0.1:8002 \
    --workers 4 \
    --timeout 120 \
    --access-logfile gunicorn-access.log \
    --error-logfile gunicorn-error.log \
    > gunicorn.log 2>&1 &

sleep 3

# Tekshirish
pgrep -f gunicorn
```

---

## 🚀 BIR QATORDA HAL QILISH

```bash
# Frontend
cd /var/www/smartcity-frontend
npm install
npm run build
sudo cp -r dist/* /var/www/html/

# Backend - Gunicorn
cd /var/www/smartcity-backend
source venv/bin/activate
pkill -9 gunicorn || true
sleep 2
nohup gunicorn smartcity_backend.wsgi:application \
    --bind 127.0.0.1:8002 \
    --workers 4 \
    --timeout 120 \
    --access-logfile gunicorn-access.log \
    --error-logfile gunicorn-error.log \
    > gunicorn.log 2>&1 &

# Nginx
sudo systemctl restart nginx

# Tekshirish
curl http://localhost:8002/api/organizations/
curl https://fergana.cdcgroup.uz
```

---

## 🔄 Gunicorn Service Yaratish (Ixtiyoriy)

Agar keyinchalik `systemctl restart gunicorn` ishlatmoqchi bo'lsangiz:

```bash
sudo nano /etc/systemd/system/gunicorn.service
```

Quyidagi kontentni yozing:

```ini
[Unit]
Description=Gunicorn daemon for Smart City Backend
After=network.target

[Service]
User=root
Group=root
WorkingDirectory=/var/www/smartcity-backend
ExecStart=/var/www/smartcity-backend/venv/bin/gunicorn \
    --bind 127.0.0.1:8002 \
    --workers 4 \
    --timeout 120 \
    --access-logfile /var/www/smartcity-backend/gunicorn-access.log \
    --error-logfile /var/www/smartcity-backend/gunicorn-error.log \
    smartcity_backend.wsgi:application

[Install]
WantedBy=multi-user.target
```

Keyin:

```bash
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl start gunicorn
sudo systemctl status gunicorn
```

---

## ✅ Tekshirish

```bash
# Gunicorn process
pgrep -f gunicorn

# Backend API
curl http://localhost:8002/api/organizations/

# Frontend
curl https://fergana.cdcgroup.uz

# Log'lar
tail -f /var/www/smartcity-backend/gunicorn-error.log
```

---

## 🆘 Muammo Bo'lsa

### Frontend build ishlamasa:

```bash
cd /var/www/smartcity-frontend
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Gunicorn ishlamasa:

```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Log'larni ko'rish
tail -50 gunicorn-error.log

# Qayta ishga tushirish
pkill -9 gunicorn
sleep 2
nohup gunicorn smartcity_backend.wsgi:application \
    --bind 127.0.0.1:8002 \
    --workers 4 \
    --timeout 120 \
    --access-logfile gunicorn-access.log \
    --error-logfile gunicorn-error.log \
    > gunicorn.log 2>&1 &
```

---

✅ **Tayyor!** Barcha muammolar hal qilindi!
