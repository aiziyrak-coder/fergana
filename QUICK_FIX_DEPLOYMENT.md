# 🚀 Quick Fix Deployment Issues

## Muammolar:
1. ❌ Pillow==10.0.1 Python 3.13 bilan muammo
2. ❌ Gunicorn service topilmayapti

## ✅ Yechim:

### 1. Pillow Muammosini Hal Qilish

```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Eski Pillow'ni o'chirish
pip uninstall -y Pillow

# Yangi versiyani o'rnatish (Python 3.13 uchun mos)
pip install --upgrade Pillow>=10.4.0

# Yoki requirements.txt'ni yangilash
pip install -r requirements.txt
```

### 2. Gunicorn Service Muammosini Hal Qilish

#### Variant 1: Service mavjud bo'lsa
```bash
# Service nomini topish
systemctl list-unit-files | grep -i gunicorn
systemctl list-unit-files | grep -i smartcity

# Service'ni qayta ishga tushirish
sudo systemctl daemon-reload
sudo systemctl restart gunicorn
# yoki
sudo systemctl restart smartcity-backend
```

#### Variant 2: Service yo'q bo'lsa (Manual start)
```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Eski process'larni o'chirish
pkill -9 gunicorn
lsof -ti:8000 | xargs kill -9 2>/dev/null || true
lsof -ti:8002 | xargs kill -9 2>/dev/null || true

# Gunicorn'ni qo'lda ishga tushirish
nohup gunicorn smartcity_backend.wsgi:application \
    --bind 127.0.0.1:8000 \
    --workers 4 \
    --timeout 120 \
    --access-logfile /var/www/smartcity-backend/gunicorn-access.log \
    --error-logfile /var/www/smartcity-backend/gunicorn-error.log \
    --log-level info \
    > /var/www/smartcity-backend/gunicorn.log 2>&1 &

# Tekshirish
sleep 3
pgrep -f gunicorn
curl http://localhost:8000/api/auth/validate/
```

### 3. Avtomatik Fix Script

```bash
# Script'ni yuklab olish va ishga tushirish
cd /var/www/smartcity-backend
wget https://raw.githubusercontent.com/aiziyrak-coder/shaxarApi/master/FIX_SERVER_DEPLOYMENT.sh
# yoki
# Local'dan ko'chirish
chmod +x FIX_SERVER_DEPLOYMENT.sh
./FIX_SERVER_DEPLOYMENT.sh
```

### 4. Tekshirish

```bash
# Pillow tekshirish
python3 -c "import PIL; print(f'Pillow: {PIL.__version__}')"

# Gunicorn tekshirish
pgrep -f gunicorn
netstat -tlnp | grep gunicorn

# API tekshirish
curl http://localhost:8000/api/auth/validate/
curl https://ferganaapi.cdcgroup.uz/api/auth/validate/

# Log'lar
tail -f /var/www/smartcity-backend/gunicorn-error.log
```

---

## 📝 Requirements.txt Yangilandi

`requirements.txt` faylida Pillow versiyasi yangilandi:
- ❌ Eski: `Pillow==10.0.1`
- ✅ Yangi: `Pillow>=10.4.0` (Python 3.13 uchun mos)

---

## 🔧 Service Yaratish (Ixtiyoriy)

Agar service yaratmoqchi bo'lsangiz:

```bash
sudo nano /etc/systemd/system/gunicorn.service
```

Quyidagi kontentni yozing:
```ini
[Unit]
Description=Gunicorn daemon for Smart City Backend
After=network.target

[Service]
Type=notify
User=root
Group=www-data
WorkingDirectory=/var/www/smartcity-backend
Environment="PATH=/var/www/smartcity-backend/venv/bin"
Environment="DJANGO_SETTINGS_MODULE=smartcity_backend.settings"
ExecStart=/var/www/smartcity-backend/venv/bin/gunicorn \
    --workers 4 \
    --bind 127.0.0.1:8000 \
    --timeout 120 \
    --access-logfile /var/log/gunicorn-access.log \
    --error-logfile /var/log/gunicorn-error.log \
    --log-level info \
    smartcity_backend.wsgi:application
Restart=on-failure
RestartSec=5s

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

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
