# 🚀 Serverga Deploy Qilish - Xavfsiz Yo'riqnoma

## ✅ GitHub Push Qilindi!

- ✅ **Backend:** https://github.com/aiziyrak-coder/shaxarApi.git
- ✅ **Frontend:** https://github.com/aiziyrak-coder/shaxar.git

---

## 🛡️ SERVERGA DEPLOY (Database Backup bilan)

### 1️⃣ Serverga SSH

```bash
ssh root@167.71.53.238
```

### 2️⃣ Deploy Script'ni Yuklash

```bash
cd /var/www/smartcity-backend

# Script'ni yuklash
wget -O DEPLOY_SAFE.sh https://raw.githubusercontent.com/aiziyrak-coder/shaxarApi/master/DEPLOY_SERVER_SAFE.sh

# Yoki qo'lda yaratish
nano DEPLOY_SAFE.sh
# (DEPLOY_SERVER_SAFE.sh faylini ko'chirib yozing)
```

### 3️⃣ Script'ni Ishga Tushirish

```bash
chmod +x DEPLOY_SAFE.sh
./DEPLOY_SAFE.sh
```

**Script avtomatik:**
1. ✅ Database backup yaratadi (`backups/db_backup_TIMESTAMP.sqlite3`)
2. ✅ Git pull qiladi
3. ✅ Migration qiladi (backup'dan keyin!)
4. ✅ Frontend build qiladi
5. ✅ Servislarni qayta ishga tushiradi

---

## 🔄 Qo'lda Deploy (Agar Script Ishlamasa)

### Step 1: Database Backup (MUHIM!)

```bash
cd /var/www/smartcity-backend

# Backup papkasini yaratish
mkdir -p backups

# Backup yaratish
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp db.sqlite3 "backups/db_backup_${TIMESTAMP}.sqlite3"

echo "✅ Backup yaratildi: backups/db_backup_${TIMESTAMP}.sqlite3"
ls -lh backups/db_backup_*.sqlite3
```

### Step 2: Backend Update

```bash
cd /var/www/smartcity-backend

# Git pull
git pull origin master

# Virtual environment
source venv/bin/activate

# Dependencies
pip install -q qrcode pillow python-telegram-bot requests

# Migration (BACKUP'DAN KEYIN!)
python manage.py migrate --no-input

# Static files
python manage.py collectstatic --noinput
```

### Step 3: Frontend Update

```bash
cd /var/www/smartcity-frontend

# Git pull
git pull origin master

# Dependencies
npm install --production

# Build
npm run build

# Copy to nginx
sudo cp -r dist/* /var/www/html/
```

### Step 4: Restart Services

```bash
# Gunicorn
sudo systemctl restart gunicorn

# Nginx
sudo systemctl restart nginx

# Status tekshirish
sudo systemctl status gunicorn
sudo systemctl status nginx
```

### Step 5: Tekshirish

```bash
# Backend
curl http://localhost:8002/api/organizations/

# Frontend
curl https://fergana.cdcgroup.uz
```

---

## 🔙 Backup'dan Qaytarish (Agar Muammo Bo'lsa)

```bash
cd /var/www/smartcity-backend

# Oxirgi backup'ni topish
LATEST_BACKUP=$(ls -t backups/db_backup_*.sqlite3 | head -1)

# Backup'dan qaytarish
cp "$LATEST_BACKUP" db.sqlite3

echo "✅ Database qaytarildi: $LATEST_BACKUP"

# Servislarni qayta ishga tushirish
sudo systemctl restart gunicorn
```

---

## 📊 Backup'lar Ro'yxati

```bash
ls -lh /var/www/smartcity-backend/backups/
```

**Eslatma:** Script avtomatik oxirgi 5 ta backup'ni saqlaydi.

---

## ✅ Deploy Keyin Tekshirish

1. **Frontend:** https://fergana.cdcgroup.uz
   - Yangi modullar ko'rinishi kerak
   - Login: `fergan` / `123`

2. **Backend API:** https://ferganaapi.cdcgroup.uz/api/organizations/
   - 200 yoki 401 status code

3. **Admin Panel:** https://ferganaapi.cdcgroup.uz/admin
   - Login: `admin` / `123`

---

## 🆘 Muammo Bo'lsa

### Backend ishlamasa:

```bash
# Log'larni ko'rish
sudo journalctl -u gunicorn -f
tail -50 /var/www/smartcity-backend/gunicorn-error.log

# Qayta ishga tushirish
sudo systemctl restart gunicorn
```

### Frontend ishlamasa:

```bash
# Nginx log'lari
sudo tail -50 /var/log/nginx/error.log

# Qayta ishga tushirish
sudo systemctl restart nginx
```

### Database muammosi:

```bash
# Backup'dan qaytarish
cd /var/www/smartcity-backend
LATEST=$(ls -t backups/db_backup_*.sqlite3 | head -1)
cp "$LATEST" db.sqlite3
sudo systemctl restart gunicorn
```

---

## 📝 Migration Faylini Tekshirish

Agar migration muammo bo'lsa:

```bash
cd /var/www/smartcity-backend
python manage.py showmigrations
python manage.py migrate --plan
```

---

## ✅ Tayyor!

Barcha o'zgarishlar serverga deploy qilindi va database saqlanib qoldi! 🎉

---

© 2026 Smart City - CDCGroup
