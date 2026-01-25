# 🚀 Frontend Deploy - Copy-Paste Buyruqlar

## Serverda Bajarish Kerak Bo'lgan Buyruqlar:

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

# 8. Test
curl http://fergana.cdcgroup.uz
```

---

## Agar Frontend Papkasi Yo'q Bo'lsa:

```bash
# Papka yaratish va clone qilish
sudo mkdir -p /var/www/smartcity-frontend
cd /var/www/smartcity-frontend
sudo git clone https://github.com/aiziyrak-coder/shaxar.git .

# Keyin yuqoridagi qadamlarni bajaring
```

---

## Tekshirish:

```bash
# Build fayllar mavjudligini tekshirish
ls -la /var/www/html/smartcity/index.html

# Frontend test
curl http://fergana.cdcgroup.uz
# HTML content qaytarishi kerak
```
