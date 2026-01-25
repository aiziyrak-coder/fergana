# 🔍 Debug Nginx va Gunicorn Connection

## Muammo: Bad Request (400)

### Tekshirish qadamlari:

```bash
# 1. Nginx config'ni tekshirish - port to'g'rimi?
sudo cat /etc/nginx/sites-available/ferganaapi.cdcgroup.uz | grep proxy_pass

# 2. Gunicorn qaysi port'da ishlayapti?
sudo systemctl show smartcity-gunicorn.service -p ExecStart

# 3. Gunicorn haqiqatan 8002 port'da ishlayaptimi?
ss -tlnp | grep 8002
# yoki
netstat -tlnp | grep 8002

# 4. Localhost'da test qilish
curl http://127.0.0.1:8002/api/auth/validate/

# 5. Nginx log'larni tekshirish
sudo tail -20 /var/log/nginx/ferganaapi-error.log
sudo tail -20 /var/log/nginx/ferganaapi-access.log

# 6. Gunicorn log'larni tekshirish
sudo tail -20 /var/www/smartcity-backend/gunicorn-error.log
```

---

## Yechimlar:

### Variant 1: Nginx config'ni qayta yozish

```bash
sudo tee /etc/nginx/sites-available/ferganaapi.cdcgroup.uz > /dev/null <<'EOF'
server {
    listen 80;
    server_name ferganaapi.cdcgroup.uz;

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
EOF

sudo nginx -t
sudo systemctl reload nginx
```

### Variant 2: Gunicorn'ni 8000 port'ga o'zgartirish

```bash
# Service file'ni tahrirlash
sudo nano /etc/systemd/system/smartcity-gunicorn.service

# --bind 127.0.0.1:8002 ni --bind 127.0.0.1:8000 ga o'zgartirish

# Service'ni qayta ishga tushirish
sudo systemctl daemon-reload
sudo systemctl restart smartcity-gunicorn

# Nginx config'ni 8000 ga qaytarish
sudo sed -i 's|proxy_pass http://127.0.0.1:8002;|proxy_pass http://127.0.0.1:8000;|g' /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
sudo nginx -t
sudo systemctl reload nginx
```

---

## Tekshirish:

```bash
# 1. Port tekshirish
ss -tlnp | grep -E "8000|8002"

# 2. Localhost test
curl http://127.0.0.1:8002/api/auth/validate/

# 3. External test
curl http://ferganaapi.cdcgroup.uz/api/auth/validate/
```
