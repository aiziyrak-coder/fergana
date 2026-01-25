# 🚀 Frontend Yangilanishini Deploy Qilish

## Qisqa Copy-Paste Buyruqlar

```bash
# 1. Frontend papkasiga o'tish
cd /var/www/smartcity-frontend

# 2. Git pull - yangi o'zgarishlarni olish
git pull origin master

# 3. Frontend build qilish
npm run build

# 4. Build fayllarni Nginx papkasiga ko'chirish
sudo mkdir -p /var/www/html/smartcity
sudo cp -r dist/* /var/www/html/smartcity/

# 5. Ruxsatlarni to'g'rilash
sudo chown -R www-data:www-data /var/www/html/smartcity
sudo chmod -R 755 /var/www/html/smartcity

# 6. Nginx reload
sudo systemctl reload nginx

# 7. Test
curl https://fergana.cdcgroup.uz
```

---

## Avtomatik Script

```bash
cd /var/www/smartcity-frontend
wget https://raw.githubusercontent.com/aiziyrak-coder/shaxarApi/master/DEPLOY_FRONTEND_UPDATE.sh
chmod +x DEPLOY_FRONTEND_UPDATE.sh
sudo ./DEPLOY_FRONTEND_UPDATE.sh
```

---

## Qo'lda (Step-by-step)

### 1. Frontend Papkasiga O'tish

```bash
cd /var/www/smartcity-frontend
```

### 2. Git Pull - Yangi O'zgarishlarni Olish

```bash
git pull origin master
```

### 3. Node Modules Tekshirish (Agar Kerak Bo'lsa)

```bash
# Agar node_modules yo'q bo'lsa
npm install
```

### 4. Frontend Build Qilish

```bash
npm run build
```

### 5. Build Fayllarni Nginx Papkasiga Ko'chirish

```bash
# Nginx papkasini yaratish
sudo mkdir -p /var/www/html/smartcity

# Build fayllarni ko'chirish
sudo cp -r dist/* /var/www/html/smartcity/

# Ruxsatlarni to'g'rilash
sudo chown -R www-data:www-data /var/www/html/smartcity
sudo chmod -R 755 /var/www/html/smartcity
```

### 6. Nginx Reload

```bash
sudo systemctl reload nginx
```

### 7. Tekshirish

```bash
# Browser'da ochish
https://fergana.cdcgroup.uz

# Yoki curl bilan test
curl https://fergana.cdcgroup.uz
```

---

## Muammo Bo'lsa

### Build Xatosi

```bash
# Node modules'ni qayta o'rnatish
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Nginx Xatosi

```bash
# Nginx config'ni tekshirish
sudo nginx -t

# Nginx log'larni ko'rish
sudo tail -50 /var/log/nginx/error.log
```

### Ruxsat Muammosi

```bash
# Ruxsatlarni to'g'rilash
sudo chown -R www-data:www-data /var/www/html/smartcity
sudo chmod -R 755 /var/www/html/smartcity
```

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
