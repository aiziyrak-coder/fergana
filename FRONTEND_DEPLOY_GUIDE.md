# 🚀 Frontend Deploy Qo'llanmasi

## 📋 Serverda Bajarish Kerak Bo'lgan Qadamlar

### Variant 1: Avtomatik Script (Tavsiya etiladi)

```bash
cd /var/www/smartcity-frontend

# Script'ni yuklab olish (agar GitHub'dan)
wget https://raw.githubusercontent.com/aiziyrak-coder/shaxar/master/DEPLOY_FRONTEND.sh
# yoki local'dan ko'chirish

# Script'ni ishga tushirish
chmod +x DEPLOY_FRONTEND.sh
./DEPLOY_FRONTEND.sh
```

### Variant 2: Qo'lda (Step-by-step)

```bash
# 1. Frontend papkasiga o'tish
cd /var/www/smartcity-frontend

# 2. Git'dan yangilash
git pull origin master

# 3. Dependencies yangilash
npm install

# 4. Build qilish
npm run build

# 5. Build fayllarni nginx'ga ko'chirish
sudo mkdir -p /var/www/html/smartcity
sudo cp -r dist/* /var/www/html/smartcity/

# 6. Ruxsatlarni to'g'rilash
sudo chown -R www-data:www-data /var/www/html/smartcity
sudo chmod -R 755 /var/www/html/smartcity

# 7. Nginx reload
sudo nginx -t && sudo systemctl reload nginx
```

---

## 🔍 Tekshirish

### 1. Build Tekshirish

```bash
# Build fayllar mavjudligini tekshirish
ls -la /var/www/html/smartcity/

# index.html mavjudligini tekshirish
ls -la /var/www/html/smartcity/index.html
```

### 2. Frontend Test

```bash
# Frontend test
curl http://fergana.cdcgroup.uz

# HTML content qaytarishi kerak
# Agar 404 yoki boshqa xatolik bo'lsa, nginx config'ni tekshiring
```

### 3. Browser'da Tekshirish

- Browser'da oching: `http://fergana.cdcgroup.uz`
- Login sahifasi ko'rinishi kerak
- Console'da xatoliklar yo'qligini tekshiring

---

## 🐛 Muammo Bo'lsa

### Build Xatosi

```bash
# Node.js versiyasini tekshirish
node --version
# Node.js 18+ bo'lishi kerak

# npm versiyasini tekshirish
npm --version

# node_modules'ni tozalash va qayta o'rnatish
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Nginx 404 Xatosi

```bash
# Nginx config'ni tekshirish
sudo cat /etc/nginx/sites-available/fergana.cdcgroup.uz

# root path to'g'rimi?
# Kutilayotgan: root /var/www/html/smartcity;

# Fayllar mavjudligini tekshirish
ls -la /var/www/html/smartcity/index.html
```

### Permission Xatosi

```bash
# Ruxsatlarni to'g'rilash
sudo chown -R www-data:www-data /var/www/html/smartcity
sudo chmod -R 755 /var/www/html/smartcity
```

---

## 📝 Qisqa Copy-Paste Buyruqlar

```bash
cd /var/www/smartcity-frontend
git pull origin master
npm install
npm run build
sudo mkdir -p /var/www/html/smartcity
sudo cp -r dist/* /var/www/html/smartcity/
sudo chown -R www-data:www-data /var/www/html/smartcity
sudo chmod -R 755 /var/www/html/smartcity
sudo nginx -t && sudo systemctl reload nginx
curl http://fergana.cdcgroup.uz
```

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
