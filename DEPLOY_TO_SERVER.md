# 🚀 Server'ga Deploy Qilish (Ma'lumotlar Saqlanadi)

## ⚠️ MUHIM: Ma'lumotlar O'chib Ketmaydi!

Database backup allaqachon olingan:
```
✓ backups/db_backup_20260113_025605.sqlite3 (656 KB)
```

---

## 📋 Deploy Jarayoni

### 1️⃣ Server'ga Ulanish

```bash
ssh root@167.71.53.238
```

### 2️⃣ Backend Database Backup (Server'da)

```bash
# Backend papkasiga o'ting
cd /var/www/smartcity-backend

# Backup yaratish
python3 backup_database.py
```

**Kutilgan natija:**
```
Database backup boshlandi...
==================================================
[SUCCESS] Database backup yaratildi!
[FILE] backups/db_backup_YYYYMMDD_HHMMSS.sqlite3
[SIZE] XXX.XX KB
==================================================
```

### 3️⃣ Deploy Qilish

```bash
# Deploy scriptini ishlatish
chmod +x deploy.sh
./deploy.sh
```

**Yoki manual:**

```bash
# Backend yangilash
cd /var/www/smartcity-backend
git pull origin master

# Virtual environment aktivlash
source venv/bin/activate

# Dependencies (agar kerak bo'lsa)
pip install -r requirements.txt

# Migration (ma'lumotlar saqlanadi!)
python manage.py migrate

# Static files
python manage.py collectstatic --noinput

# Gunicorn restart
sudo systemctl restart gunicorn

# Frontend yangilash
cd /var/www/smartcity-frontend
git pull origin master
npm install
npm run build
sudo rm -rf /var/www/html/smartcity/*
sudo cp -r dist/* /var/www/html/smartcity/

# Nginx restart
sudo systemctl restart nginx
```

---

## 🔍 Tekshirish

### Service Status
```bash
sudo systemctl status gunicorn
sudo systemctl status nginx
```

### Loglarni Ko'rish
```bash
# Real-time logs
sudo journalctl -u gunicorn -f

# Nginx errors
sudo tail -f /var/log/nginx/error.log
```

### Database Tekshirish
```bash
cd /var/www/smartcity-backend
python manage.py shell
```

```python
from smartcity_app.models import Organization, WasteBin
print(f"Organizations: {Organization.objects.count()}")
print(f"Waste Bins: {WasteBin.objects.count()}")
# Ma'lumotlar saqlanishi kerak!
```

---

## 🌐 Test Qilish

### URL'larni Tekshirish
- ✅ Frontend: https://fergana.cdcgroup.uz
- ✅ Backend: https://ferganaapi.cdcgroup.uz
- ✅ Admin: https://ferganaapi.cdcgroup.uz/admin

### Login Test
1. Browser'da frontend'ni oching
2. Login qiling: `fergana` / `123`
3. Dashboard ochilishi kerak
4. Barcha ma'lumotlar ko'rinishi kerak

### Console Tekshirish (F12)
- ✅ CSRF xatosi yo'q
- ✅ Tailwind CDN warning yo'q
- ✅ API requestlar ishlayapti

---

## 🔄 Agar Muammo Bo'lsa

### Database Restore (faqat zarurat bo'lsa!)
```bash
cd /var/www/smartcity-backend

# Eng yangi backup'ni topish
ls -lh backups/

# Restore qilish (EHTIYOT BO'LING!)
# cp backups/db_backup_YYYYMMDD_HHMMSS.sqlite3 db.sqlite3

# Service restart
sudo systemctl restart gunicorn
```

### Service Restart
```bash
sudo systemctl restart gunicorn
sudo systemctl restart nginx
```

### Cache Tozalash
```bash
# Browser cache tozalang (CTRL+SHIFT+DELETE)
# Yoki incognito/private mode ishlatng
```

---

## ✅ Deploy Success Checklist

- [ ] Server'ga ulandi
- [ ] Database backup olindi (server'da)
- [ ] Backend git pull ishladi
- [ ] Frontend git pull ishladi
- [ ] Frontend build yaratildi
- [ ] Services restart qilindi
- [ ] URL'lar ochiladi
- [ ] Login ishlaydi
- [ ] Ma'lumotlar ko'rinadi
- [ ] CSRF/Tailwind xatolari yo'q

---

## 📊 O'zgarishlar Xulosasi

### Backend
- ✅ CSRF o'chirildi (Token auth ishlatiladi)
- ✅ CORS production uchun sozlandi
- ✅ Database backup script qo'shildi
- ⚠️ Barcha mavjud ma'lumotlar SAQLANADI

### Frontend
- ✅ Tailwind CSS to'g'ri o'rnatildi
- ✅ Production build optimallashtirildi
- ✅ CDN o'chirildi
- ✅ API URL yangilandi

---

## 🔐 Xavfsizlik

### Ma'lumotlar Saqlanadi ✅
- Database fayli o'zgartirilmaydi
- Migration faqat struktura yangilaydi
- Backup har doim olinadi
- Rollback mumkin

### Token Authentication
- CSRF o'rniga Token ishlatiladi
- Har bir request'da token tekshiriladi
- Xavfsizroq va zamonaviy

---

## 📞 Yordam

Muammo yuzaga kelsa:
1. Loglarni tekshiring: `sudo journalctl -u gunicorn -f`
2. Service status: `sudo systemctl status gunicorn nginx`
3. Database backup'dan restore qiling (agar kerak bo'lsa)

---

**Eslatma:** Deploy jarayonida ma'lumotlar HECH QACHON o'chib ketmaydi! Backup olingan va migrate faqat struktura yangilaydi, ma'lumotlarni o'zgartirmaydi.
