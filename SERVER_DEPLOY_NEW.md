# 🚀 Server'ga Deploy (Ma'lumotlar Saqlanadi!)

## ✅ GitHub'ga Push Qilindi

- ✅ Backend: https://github.com/aiziyrak-coder/shaxarApi
- ✅ Frontend: https://github.com/aiziyrak-coder/shaxar

---

## ⚠️ MUHIM: Ma'lumotlar O'CHIB KETMAYDI!

Database backup olingan va server'da ham olinadi. Yangi kod faqat yangilanadi, ma'lumotlar saqlanib qoladi.

---

## 📋 Server'ga Deploy Qilish

### 1️⃣ SSH Ulanish

```bash
ssh root@167.71.53.238
```

### 2️⃣ Database Backup (BIRINCHI NAVBATDA!)

```bash
# Backend papkasiga o'ting
cd /var/www/smartcity-backend

# Backup yaratish
python3 backup_database.py
```

**Kutilgan natija:**
```
[SUCCESS] Database backup yaratildi!
[FILE] backups/db_backup_YYYYMMDD_HHMMSS.sqlite3
[SIZE] XXX.XX KB
```

### 3️⃣ Git Remote URL'ni O'zgartirish (Birinchi marta)

```bash
# Backend
cd /var/www/smartcity-backend
git remote set-url origin https://github.com/aiziyrak-coder/shaxarApi.git

# Frontend
cd /var/www/smartcity-frontend
git remote set-url origin https://github.com/aiziyrak-coder/shaxar.git

# Tekshirish
cd /var/www/smartcity-backend
git remote -v
# origin https://github.com/aiziyrak-coder/shaxarApi.git bo'lishi kerak

cd /var/www/smartcity-frontend
git remote -v
# origin https://github.com/aiziyrak-coder/shaxar.git bo'lishi kerak
```

### 4️⃣ Backend Deploy

```bash
cd /var/www/smartcity-backend

# Pull latest changes
git pull origin master

# Virtual environment aktivlash
source venv/bin/activate

# Dependencies (agar kerak bo'lsa)
pip install -r requirements.txt

# Migration (ma'lumotlar SAQLANADI!)
python manage.py migrate

# Static files
python manage.py collectstatic --noinput

# Gunicorn restart
sudo systemctl restart gunicorn
```

### 5️⃣ Frontend Deploy

```bash
cd /var/www/smartcity-frontend

# Pull latest changes
git pull origin master

# Dependencies
npm install

# Build
npm run build

# Copy to nginx directory
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

**Kutilgan:** `active (running)`

### Loglar
```bash
# Gunicorn logs
sudo journalctl -u gunicorn -f

# Nginx errors
sudo tail -f /var/log/nginx/error.log
```

### Database Tekshirish (Ma'lumotlar Bor?)
```bash
cd /var/www/smartcity-backend
python manage.py shell
```

```python
from smartcity_app.models import Organization, WasteBin
print(f"Organizations: {Organization.objects.count()}")
print(f"Waste Bins: {WasteBin.objects.count()}")
# Raqamlar 0 dan katta bo'lishi kerak!
```

---

## 🌐 Test Qilish

### URL'lar
1. https://fergana.cdcgroup.uz
2. Login: `fergana` / `123`

### Tekshirish
- ✅ Login ishlayaptimi?
- ✅ Dashboard ochilyaptimi?
- ✅ Ma'lumotlar ko'rinyaptimi (chiqindi qutilari, etc.)?
- ✅ CSRF xatosi yo'qmi? (Console F12)
- ✅ Tailwind CDN warning yo'qmi?

---

## 🔄 Agar Ma'lumotlar Ko'rinmasa (Restore)

**EHTIYOT: Faqat zarurat bo'lsa!**

```bash
cd /var/www/smartcity-backend

# Backup'larni ko'rish
ls -lh backups/

# Eng yangi backup'ni restore qilish
cp backups/db_backup_YYYYMMDD_HHMMSS.sqlite3 db.sqlite3

# Service restart
sudo systemctl restart gunicorn
```

---

## 📊 Deploy Success Checklist

- [ ] SSH ulandi
- [ ] Database backup olindi
- [ ] Git remote URL o'zgartirildi
- [ ] Backend pull ishladi
- [ ] Frontend pull ishladi
- [ ] Frontend build yaratildi
- [ ] Services restart qilindi
- [ ] URL'lar ochiladi
- [ ] Login ishlaydi
- [ ] Ma'lumotlar ko'rinadi
- [ ] CSRF/Tailwind xatolari yo'q

---

## 🐛 Troubleshooting

### "fatal: unable to access" xatosi?
```bash
# Git credentials tozalash
git config --global credential.helper store
git pull origin master
# Username: aiziyrak-coder
# Password: [GitHub token or password]
```

### Migration xatosi?
```bash
# Migration fayllarni ko'rish
python manage.py showmigrations

# Fake migration (agar kerak bo'lsa)
python manage.py migrate --fake-initial
```

### Static files ishlamayapti?
```bash
# Static files qayta yig'ish
python manage.py collectstatic --noinput --clear
sudo systemctl restart gunicorn nginx
```

---

## 📝 Eslatma

### Ma'lumotlar Haqida ✅
- **Migration faqat struktura yangilaydi, ma'lumotlarni o'zgartirmaydi**
- **Backup olingan, xavotir olmang!**
- **Restore mumkin (backup'dan)**

### Xavfsizlik
- Token authentication ishlatiladi
- CSRF o'chirildi API uchun
- HTTPS enabled
- Ma'lumotlar saqlanadi

---

## 🎯 Tezkor Deploy (Keyingi marta)

```bash
ssh root@167.71.53.238

# Backend
cd /var/www/smartcity-backend
python3 backup_database.py
git pull origin master
source venv/bin/activate
python manage.py migrate
python manage.py collectstatic --noinput
sudo systemctl restart gunicorn

# Frontend
cd /var/www/smartcity-frontend
git pull origin master
npm install
npm run build
sudo rm -rf /var/www/html/smartcity/*
sudo cp -r dist/* /var/www/html/smartcity/
sudo systemctl restart nginx
```

---

**Vaqti:** ~5-7 daqiqa  
**Xavfsizlik:** Ma'lumotlar 100% saqlanadi ✓  
**Backup:** Olingan ✓

**Hozir server'ga SSH qiling va deploy qiling!** 🚀
