# 🔧 Gunicorn 502 Bad Gateway Xatolikni Tuzatish

## Muammo
502 Bad Gateway - Gunicorn ishlamayapti yoki Nginx bilan ulanmayapti.

## Yechim

```bash
# 1. Gunicorn statusini tekshirish
sudo systemctl status smartcity-gunicorn

# 2. Agar ishlamayotgan bo'lsa, qayta ishga tushirish
sudo systemctl restart smartcity-gunicorn

# 3. Loglarni tekshirish
sudo journalctl -u smartcity-gunicorn -n 50 --no-pager

# 4. Agar xatolik bo'lsa, Gunicorn'ni qo'lda ishga tushirish
cd /var/www/smartcity-backend
source venv/bin/activate
gunicorn smartcity.wsgi:application --bind 127.0.0.1:8002 --workers 3 --timeout 120

# 5. Nginx config tekshirish
sudo nginx -t

# 6. Nginx reload
sudo systemctl reload nginx
```

## Tekshirish

```bash
# Gunicorn portini tekshirish
sudo netstat -tlnp | grep 8002

# Test
curl http://127.0.0.1:8002/api/air-sensors/
```
