# 🛡️ Serverga Xavfsiz Deploy - Database Backup bilan

## ⚠️ MUHIM: Ma'lumotlar O'chib Ketmasligi Uchun

Bu script **avtomatik database backup** yaratadi va faqat keyin migration qiladi.

---

## 📋 Deploy Qadam-baqadam

### 1️⃣ Serverga SSH

```bash
ssh root@167.71.53.238
```

### 2️⃣ Script'ni Yuklash

```bash
cd /var/www/smartcity-backend
wget https://raw.githubusercontent.com/YOUR_REPO/master/DEPLOY_SAFE.sh
chmod +x DEPLOY_SAFE.sh
```

### 3️⃣ Deploy Qilish

```bash
./DEPLOY_SAFE.sh
```

**Script avtomatik:**
1. ✅ Database backup yaratadi (`backups/db_backup_TIMESTAMP.sqlite3`)
2. ✅ Git pull qiladi
3. ✅ Migration qiladi (backup'dan keyin)
4. ✅ Frontend build qiladi
5. ✅ Servislarni qayta ishga tushiradi

---

## 🔄 Qo'lda Deploy (Agar Script Ishlamasa)

### Step 1: Database Backup

```bash
cd /var/www/smartcity-backend

# Backup papkasini yaratish
mkdir -p backups

# Backup yaratish
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp db.sqlite3 "backups/db_backup_${TIMESTAMP}.sqlite3"

echo "✅ Backup yaratildi: backups/db_backup_${TIMESTAMP}.sqlite3"
```

### Step 2: Code Update

```bash
# Backend
cd /var/www/smartcity-backend
git pull origin master

# Frontend
cd /var/www/smartcity-frontend
git pull origin master
```

### Step 3: Backend Migration

```bash
cd /var/www/smartcity-backend
source venv/bin/activate
pip install -q qrcode pillow python-telegram-bot requests
python manage.py migrate --no-input
```

### Step 4: Frontend Build

```bash
cd /var/www/smartcity-frontend
npm install
npm run build
sudo cp -r dist/* /var/www/html/
```

### Step 5: Restart Services

```bash
sudo systemctl restart gunicorn
sudo systemctl restart nginx
```

### Step 6: Tekshirish

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

echo "✅ Database backup'dan qaytarildi: $LATEST_BACKUP"
```

---

## 📊 Backup'lar Ro'yxati

```bash
ls -lh /var/www/smartcity-backend/backups/
```

**Eslatma:** Script avtomatik oxirgi 5 ta backup'ni saqlaydi, qolganlarini o'chiradi.

---

## ✅ Deploy Keyin Tekshirish

1. **Frontend:** https://fergana.cdcgroup.uz
2. **Backend API:** https://ferganaapi.cdcgroup.uz/api/organizations/
3. **Admin Panel:** https://ferganaapi.cdcgroup.uz/admin

**Login:** `fergan` / `123`

---

## 🆘 Muammo Bo'lsa

1. **Backend ishlamasa:**
   ```bash
   sudo journalctl -u gunicorn -f
   tail -50 /var/www/smartcity-backend/gunicorn-error.log
   ```

2. **Frontend ishlamasa:**
   ```bash
   sudo tail -50 /var/log/nginx/error.log
   ```

3. **Database muammosi:**
   ```bash
   # Backup'dan qaytarish
   cd /var/www/smartcity-backend
   cp backups/db_backup_*.sqlite3 db.sqlite3
   ```

---

© 2026 Smart City - CDCGroup
