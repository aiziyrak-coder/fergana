# 🚀 Serverga Deploy Qilish Qo'llanmasi

## ✅ GitHub Push Muvaffaqiyatli

### Push Qilingan Repository'lar:
- ✅ **Backend**: https://github.com/aiziyrak-coder/shaxarApi.git
- ✅ **Frontend**: https://github.com/aiziyrak-coder/shaxar.git

---

## 📋 Serverga Deploy Qadamlari

### 1. Server'ga SSH orqali ulanish
```bash
ssh root@167.71.53.238
# yoki
ssh user@ferganaapi.cdcgroup.uz
```

### 2. Backend Deploy

```bash
# Backend papkasiga o'tish
cd /var/www/smartcity-backend
# yoki
cd /path/to/backend

# Git'dan yangilash
git pull origin master

# Virtual environment'ni faollashtirish (agar kerak bo'lsa)
source venv/bin/activate

# Dependencies yangilash (agar kerak bo'lsa)
pip install -r requirements.txt

# Migration'larni bajarish
python manage.py migrate

# Static fayllarni yig'ish
python manage.py collectstatic --noinput

# Gunicorn'ni qayta ishga tushirish
sudo systemctl restart gunicorn
# yoki
sudo systemctl restart smartcity-backend

# Nginx'ni qayta yuklash
sudo nginx -t
sudo systemctl reload nginx
```

### 3. Frontend Deploy

```bash
# Frontend papkasiga o'tish
cd /var/www/smartcity-frontend
# yoki
cd /path/to/frontend

# Git'dan yangilash
git pull origin master

# Dependencies yangilash (agar kerak bo'lsa)
npm install

# Production build yaratish
npm run build

# Build fayllarni nginx'ga ko'chirish
sudo cp -r dist/* /var/www/html/
# yoki
sudo cp -r dist/* /usr/share/nginx/html/
```

### 4. Tekshirish

```bash
# Backend tekshirish
curl https://ferganaapi.cdcgroup.uz/api/auth/validate/
# Response: {"valid": false} yoki {"valid": true}

# Frontend tekshirish
curl https://fergana.cdcgroup.uz
# HTML qaytarishi kerak

# Log'larni tekshirish
sudo tail -f /var/log/nginx/ferganaapi-error.log
sudo tail -f /var/www/smartcity-backend/django.log
```

---

## 🔧 O'zgarishlar

### Backend O'zgarishlari:
1. ✅ Deduplication qo'shildi (WasteBin, Truck, Facility, Room, Boiler, IoTDevice)
2. ✅ Transaction handling qo'shildi
3. ✅ validate_token endpoint yaxshilandi (GET/POST support)
4. ✅ IoT sensor validation yaxshilandi
5. ✅ Logging yaxshilandi

### Frontend O'zgarishlari:
1. ✅ ErrorBoundary komponenti qo'shildi
2. ✅ Race condition fix (polling)
3. ✅ Console.log optimizatsiyasi (production mode)
4. ✅ Error handling yaxshilandi

---

## ⚠️ Muhim Eslatmalar

1. **Database Migration**: Migration'larni bajarishni unutmang
2. **Static Files**: collectstatic bajarilishi kerak
3. **Service Restart**: Gunicorn va Nginx'ni qayta ishga tushirish kerak
4. **Environment Variables**: .env fayllarini tekshiring
5. **Permissions**: Fayl ruxsatlarini tekshiring

---

## 🐛 Muammo Bo'lsa

### Backend ishlamasa:
```bash
# Gunicorn status
sudo systemctl status gunicorn

# Log'larni ko'rish
sudo journalctl -u gunicorn -f

# Qayta ishga tushirish
sudo systemctl restart gunicorn
```

### Frontend ishlamasa:
```bash
# Nginx status
sudo systemctl status nginx

# Nginx config tekshirish
sudo nginx -t

# Qayta ishga tushirish
sudo systemctl restart nginx
```

---

## 📞 Yordam

Agar muammo bo'lsa:
1. Log'larni tekshiring
2. Service status'ni tekshiring
3. Network connectivity'ni tekshiring
4. Database connection'ni tekshiring

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
**Status**: ✅ GitHub'ga push qilindi, serverga deploy qilish kerak
