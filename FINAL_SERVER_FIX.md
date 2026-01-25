# 🔧 Final Server Fix - Muammolarni Hal Qilish

## ✅ Muvaffaqiyatli:
- ✅ Gunicorn service ishga tushdi (`smartcity-gunicorn.service`)
- ✅ Gunicorn process'lar ishlayapti
- ✅ External API ishlayapti (`https://ferganaapi.cdcgroup.uz/api/auth/validate/`)

## ⚠️ Muammolar:

### 1. Localhost API ishlamayapti
- `curl http://localhost:8000/api/auth/validate/` - "Not Found" qaytardi
- **Sabab**: Gunicorn boshqa port'da ishlayotgan bo'lishi mumkin yoki nginx config muammosi

### 2. Nginx Warning
- `conflicting server name "ferganaapi.cdcgroup.uz"` - Duplicate server_name bor

### 3. Python Command
- `python` topilmayapti, `python3` ishlatish kerak

---

## 🔧 Yechimlar:

### 1. Gunicorn Port'ni Tekshirish va Tuzatish

```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Gunicorn qaysi port'da ishlayotganini tekshirish
netstat -tlnp | grep gunicorn
# yoki
ss -tlnp | grep gunicorn
# yoki
lsof -i -P -n | grep gunicorn

# Service file'ni tekshirish
cat /etc/systemd/system/smartcity-gunicorn.service

# Agar port 8002 bo'lsa, nginx config'ni tekshirish
sudo cat /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
```

### 2. Nginx Config'ni Tuzatish

```bash
# Nginx config'ni tekshirish
sudo nginx -T | grep -A 20 "ferganaapi.cdcgroup.uz"

# Duplicate server_name'ni topish
sudo grep -r "server_name.*ferganaapi.cdcgroup.uz" /etc/nginx/

# Asosiy config faylini tekshirish
sudo cat /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
sudo cat /etc/nginx/sites-enabled/ferganaapi.cdcgroup.uz

# Agar duplicate bo'lsa, bitta faylni o'chirish
sudo rm /etc/nginx/sites-enabled/ferganaapi.cdcgroup.uz.old  # agar mavjud bo'lsa
```

### 3. Migration va Collectstatic (To'g'ri Format)

```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Migration'larni bajarish (python3 ishlatish)
python3 manage.py migrate

# Static fayllarni yig'ish
python3 manage.py collectstatic --noinput
```

### 4. Gunicorn Service'ni To'g'ri Sozlash

Agar gunicorn 8002 port'da ishlayotgan bo'lsa:

```bash
# Service file'ni tahrirlash
sudo nano /etc/systemd/system/smartcity-gunicorn.service
```

Quyidagicha bo'lishi kerak:
```ini
[Unit]
Description=Gunicorn for Smart City (Fergana)
After=network.target

[Service]
User=root
Group=www-data
WorkingDirectory=/var/www/smartcity-backend
Environment="PATH=/var/www/smartcity-backend/venv/bin"
ExecStart=/var/www/smartcity-backend/venv/bin/gunicorn \
    --workers 4 \
    --bind 127.0.0.1:8000 \
    --timeout 120 \
    --access-logfile /var/www/smartcity-backend/gunicorn-access.log \
    --error-logfile /var/www/smartcity-backend/gunicorn-error.log \
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
sudo systemctl restart smartcity-gunicorn
```

### 5. Nginx Config'ni To'g'rilash

```bash
sudo nano /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
```

Quyidagicha bo'lishi kerak:
```nginx
server {
    listen 80;
    server_name ferganaapi.cdcgroup.uz;

    client_max_body_size 20M;

    location / {
        proxy_pass http://127.0.0.1:8000;  # Gunicorn port'ini tekshiring
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

Keyin:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 🔍 Tekshirish

```bash
# Gunicorn port'ni tekshirish
ss -tlnp | grep gunicorn
# yoki
netstat -tlnp | grep gunicorn

# Localhost API test
curl http://localhost:8000/api/auth/validate/
# Kutilayotgan: {"valid":false,"error":"No valid authentication"}

# External API test
curl https://ferganaapi.cdcgroup.uz/api/auth/validate/
# Kutilayotgan: {"valid":false,"error":"No valid authentication"}

# Service status
sudo systemctl status smartcity-gunicorn

# Log'lar
tail -f /var/www/smartcity-backend/gunicorn-error.log
tail -f /var/log/nginx/ferganaapi-error.log
```

---

## 📝 Qisqa Buyruqlar (Copy-Paste)

```bash
# 1. Port tekshirish
ss -tlnp | grep gunicorn

# 2. Migration va Static
cd /var/www/smartcity-backend
source venv/bin/activate
python3 manage.py migrate
python3 manage.py collectstatic --noinput

# 3. Nginx duplicate tekshirish
sudo grep -r "server_name.*ferganaapi" /etc/nginx/sites-enabled/

# 4. Service restart
sudo systemctl daemon-reload
sudo systemctl restart smartcity-gunicorn

# 5. Nginx reload
sudo nginx -t && sudo systemctl reload nginx

# 6. Test
curl http://localhost:8000/api/auth/validate/
curl https://ferganaapi.cdcgroup.uz/api/auth/validate/
```

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
