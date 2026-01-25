# 🚀 Server Commands - Fix va Restart

## ✅ Pillow Muvaffaqiyatli O'rnatildi!
- Pillow 12.1.0 o'rnatildi (Python 3.13 uchun mos)

## 🔧 Gunicorn Service Restart

Service nomi: **`smartcity-gunicorn.service`**

### Service'ni qayta ishga tushirish:

```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Service'ni qayta ishga tushirish
sudo systemctl daemon-reload
sudo systemctl restart smartcity-gunicorn

# Status tekshirish
sudo systemctl status smartcity-gunicorn

# Log'larni ko'rish
sudo journalctl -u smartcity-gunicorn -f
# yoki
tail -f /var/www/smartcity-backend/gunicorn-error.log
```

### Agar service ishlamasa (Manual start):

```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Eski process'larni o'chirish
sudo systemctl stop smartcity-gunicorn
pkill -9 gunicorn
lsof -ti:8000 | xargs kill -9 2>/dev/null || true
lsof -ti:8002 | xargs kill -9 2>/dev/null || true
sleep 2

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

---

## 📝 Migration va Static Files

```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Migration'larni bajarish
python manage.py migrate

# Static fayllarni yig'ish
python manage.py collectstatic --noinput
```

---

## 🔍 Tekshirish

```bash
# Pillow versiyasini tekshirish
python3 -c "import PIL; print(f'Pillow: {PIL.__version__}')"

# Gunicorn process'ni tekshirish
pgrep -f gunicorn
ps aux | grep gunicorn

# Port tekshirish
netstat -tlnp | grep 8000
# yoki
ss -tlnp | grep 8000

# API test
curl http://localhost:8000/api/auth/validate/
curl https://ferganaapi.cdcgroup.uz/api/auth/validate/

# Service status
sudo systemctl status smartcity-gunicorn --no-pager -l
```

---

## 🔄 Nginx Reload

```bash
# Nginx config tekshirish
sudo nginx -t

# Nginx reload
sudo systemctl reload nginx
# yoki
sudo systemctl restart nginx
```

---

## 🐛 Muammo Bo'lsa

### Service ishlamasa:
```bash
# Service log'larni ko'rish
sudo journalctl -u smartcity-gunicorn -n 50 --no-pager

# Service'ni qayta yuklash
sudo systemctl daemon-reload
sudo systemctl restart smartcity-gunicorn

# Agar hali ham ishlamasa, manual start
pkill -9 gunicorn
# Keyin yuqoridagi manual start buyruqlarini ishlating
```

### API javob bermasa:
```bash
# Gunicorn log'larni tekshirish
tail -50 /var/www/smartcity-backend/gunicorn-error.log
tail -50 /var/www/smartcity-backend/gunicorn-access.log

# Django log'larni tekshirish
tail -50 /var/www/smartcity-backend/django.log

# Nginx log'larni tekshirish
tail -50 /var/log/nginx/ferganaapi-error.log
```

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
