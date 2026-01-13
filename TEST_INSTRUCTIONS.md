# 🧪 Test Qilish Yo'riqnomasi

## ✅ Tuzatilgan Muammolar

1. ✅ CSRF Token muammosi (403 Forbidden)
2. ✅ Tailwind CSS CDN warning

---

## 🚀 Local Test

### 1️⃣ Backend Ishga Tushirish

**Terminal 1:**
```bash
cd E:\Smartcity\backend
python manage.py runserver
```

**Kutilgan natija:**
```
Starting development server at http://127.0.0.1:8000/
```

### 2️⃣ Frontend Ishga Tushirish

**Terminal 2:**
```bash
cd E:\Smartcity\frontend
npm run dev
```

**Kutilgan natija:**
```
VITE v5.4.21  ready in XXX ms
➜  Local:   http://localhost:5173/
```

### 3️⃣ Browser'da Test

1. **Ochish:** http://localhost:5173
2. **Login qilish:**
   - Username: `fergana`
   - Password: `123`

### 4️⃣ Tekshirish

**Console'da (F12) quyidagilar BO'LMASLIGI kerak:**
- ❌ `cdn.tailwindcss.com should not be used in production`
- ❌ `403 Forbidden`
- ❌ `CSRF Failed`

**Console'da quyidagilar BO'LISHI kerak:**
- ✅ `✅ Login successful`
- ✅ `200 OK` statuslar

---

## 📊 Kutilgan Natija

### Login Muvaffaqiyatli
```javascript
// Console output:
🔐 Sending login request to: https://ferganaapi.cdcgroup.uz/api/auth/login/
📤 Login data: {login: 'fergana', password: '***'}
✅ Login successful, data: {...}
```

### Dashboard Ochiladi
- ✅ Markaz (Dashboard) ko'rinadi
- ✅ Chiqindi statistikasi
- ✅ Issiqlik ma'lumotlari
- ✅ Xarita ishlaydi

---

## 🐛 Agar Muammo Bo'lsa

### CSRF Xatosi Hali Ham Mavjud?

**Backend'ni restart qiling:**
```bash
# CTRL+C backend terminalda
cd E:\Smartcity\backend
python manage.py runserver
```

**Browser cache tozalash:**
1. F12 -> Network tab
2. "Disable cache" ni belgilang
3. Sahifani yangilang (F5)

### Tailwind CSS Ishlamayapti?

**Node modules qayta o'rnatish:**
```bash
cd E:\Smartcity\frontend
rm -rf node_modules
npm install
npm run dev
```

### Login Ishlamayapti?

**Database tekshirish:**
```bash
cd E:\Smartcity\backend
python manage.py shell
```

```python
from smartcity_app.models import Organization
org = Organization.objects.filter(login='fergana').first()
print(f"Org: {org.name if org else 'Not found'}")
print(f"Password: {org.password if org else 'N/A'}")
```

---

## ✅ Test Checklist

### Tekshirish Ro'yxati

- [ ] Backend ishga tushdi (port 8000)
- [ ] Frontend ishga tushdi (port 5173)
- [ ] Browser'da sahifa ochildi
- [ ] Login form ko'rinadi
- [ ] CSRF warning yo'q
- [ ] Tailwind CDN warning yo'q
- [ ] Login ishlaydi
- [ ] Dashboard ochiladi
- [ ] Token saqlandi (localStorage'da)
- [ ] API requestlar ishlaydi
- [ ] Xarita ko'rinadi

### Browser DevTools Tekshirish

**Console (F12 -> Console):**
- Xatolar yo'q bo'lishi kerak
- Warning'lar minimal

**Network (F12 -> Network):**
- Login request: 200 OK
- API requests: 200 OK
- Headers'da Authorization token bor

**Application (F12 -> Application -> Local Storage):**
- `authToken` mavjud
- `organizationId` mavjud (agar kerak bo'lsa)

---

## 📸 Screenshot'lar (Kutilgan)

### 1. Login Screen
```
┌─────────────────────────────┐
│   Farg'ona Shahar          │
│   Situatsion Markazi       │
│                            │
│   [Username: fergana   ]   │
│   [Password: ●●●       ]   │
│   [  Kirish  ]             │
└─────────────────────────────┘
```

### 2. Dashboard
```
┌──────────────────────────────────┐
│ Markaz | Chiqindi | Issiqlik   │
├──────────────────────────────────┤
│  📊 Statistika                   │
│  🗺️  Xarita                      │
│  📈 Grafiklar                    │
└──────────────────────────────────┘
```

---

## 🚀 Production Test

### Server'da Test (SSH)

```bash
ssh root@167.71.53.238

# Backend status
sudo systemctl status gunicorn

# Nginx status
sudo systemctl status nginx

# Loglar
sudo tail -f /var/log/nginx/error.log
```

### Production URL'lar

- **Frontend:** https://fergana.cdcgroup.uz
- **Backend:** https://ferganaapi.cdcgroup.uz
- **Admin:** https://ferganaapi.cdcgroup.uz/admin

---

## 📝 Test Natijalari

### Muvaffaqiyatli Test
```
✅ CSRF muammosi hal qilindi
✅ Tailwind CDN warning yo'qoldi
✅ Login ishlayapti
✅ Dashboard ochildi
✅ API requestlar ishlaydi
```

### Keyingi Qadamlar
1. GitHub'ga push
2. Production deploy
3. Final test production'da

---

**Test vaqti:** ~5 daqiqa  
**Qiyinlik:** Oson  
**Talab:** Browser + Terminal
