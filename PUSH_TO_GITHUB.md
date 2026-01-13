# 🚀 GitHub'ga Push Qilish Yo'riqnomasi

## 📋 Amal qilish tartibi

### 1️⃣ Backend Repository'ni yangilash

```bash
# Backend papkasiga o'ting
cd E:\Smartcity\backend

# Git holatini tekshiring
git status

# Barcha o'zgarishlarni qo'shing
git add .

# Commit yarating
git commit -m "Fix: Update production URLs and security settings

- Updated ALLOWED_HOSTS for production
- Added production domains to CORS_ALLOWED_ORIGINS
- Added production domains to CSRF_TRUSTED_ORIGINS
- Enabled secure cookies for HTTPS
- Added environment-based DEBUG setting"

# GitHub'ga push qiling
git push origin master
```

### 2️⃣ Frontend Repository'ni yangilash

```bash
# Frontend papkasiga o'ting
cd E:\Smartcity\frontend

# Git holatini tekshiring
git status

# Barcha o'zgarishlarni qo'shing
git add .

# Commit yarating
git commit -m "Fix: Update API URLs for production

- Changed API base URL from smartcityapi.aiproduct.uz to ferganaapi.cdcgroup.uz
- Updated auth service base URL
- Fixed production API endpoint configuration"

# GitHub'ga push qiling
git push origin master
```

### 3️⃣ Server'ga Deploy qilish

SSH orqali serverga ulaning:

```bash
ssh root@167.71.53.238
```

Keyin deploy scriptini ishga tushiring:

```bash
cd /var/www/smartcity-backend
chmod +x deploy.sh
./deploy.sh
```

## ✅ O'zgartirilgan fayllar ro'yxati

### Backend
- `smartcity_backend/settings.py`
  - ✅ ALLOWED_HOSTS yangilandi
  - ✅ CORS_ALLOWED_ORIGINS yangilandi
  - ✅ CSRF_TRUSTED_ORIGINS yangilandi
  - ✅ DEBUG environment variable orqali boshqariladi
  - ✅ Secure cookies yoqildi

### Frontend
- `services/api.ts`
  - ✅ API_BASE_URL yangilandi
- `services/auth.ts`
  - ✅ baseUrl yangilandi

### Qo'shimcha fayllar (serverga ko'chiriladi)
- ✅ `deploy.sh` - Deploy script
- ✅ `nginx-frontend.conf` - Frontend nginx config
- ✅ `nginx-backend.conf` - Backend nginx config
- ✅ `gunicorn.service` - Gunicorn service file
- ✅ `check-services.sh` - Health check script
- ✅ `logs.sh` - Log viewer
- ✅ `backup.sh` - Backup script
- ✅ `DEPLOY_GUIDE.md` - Deploy yo'riqnomasi
- ✅ `README.md` - Projekt hujjati
- ✅ `CHANGELOG.md` - O'zgarishlar tarixi

## 🔍 Tekshiruv

Push qilgandan so'ng, GitHub'da o'zgarishlarni tekshiring:

- Backend: https://github.com/backend-developer-hojiakbar/smartApiFull
- Frontend: https://github.com/backend-developer-hojiakbar/smartFrontFull

## ⚠️ Muhim eslatmalar

1. **Parol va tokenlarni commit qilmang!**
   - `.env` fayllari `.gitignore` da bo'lishi kerak
   - Secret key'lar va parollar environment variable'larda bo'lishi kerak

2. **Production ma'lumotlarini tekshiring:**
   - Database backup olinganmi?
   - SSL sertifikatlar aktivmi?

3. **Server sozlamalarini yangilang:**
   ```bash
   # Server'da .env faylini yarating
   nano /var/www/smartcity-backend/.env
   ```
   
   Quyidagi ma'lumotlarni kiriting:
   ```env
   DEBUG=False
   SECRET_KEY=your-very-secret-key-change-this-in-production
   ALLOWED_HOSTS=ferganaapi.cdcgroup.uz,167.71.53.238
   ```

## 🐛 Muammolar

Agar push qilishda muammo bo'lsa:

### Authentication error
```bash
# GitHub tokenni yangilang yoki SSH key o'rnating
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Merge conflicts
```bash
# Remote o'zgarishlarni oling
git pull origin master

# Konfliktlarni hal qiling
# Keyin qayta push qiling
git add .
git commit -m "Merge conflicts resolved"
git push origin master
```

### Permission denied
```bash
# SSH key o'rnating yoki HTTPS ishlatishga o'ting
git remote set-url origin https://github.com/backend-developer-hojiakbar/smartApiFull.git
```

## 📞 Yordam

Muammo yuzaga kelsa, quyidagi buyruqlarni ishga tushiring:

```bash
# Git holatini tekshirish
git status

# O'zgarishlarni ko'rish
git diff

# Oxirgi commitlar
git log --oneline -5

# Remote repositorylar
git remote -v
```

---

**Omad!** 🚀
