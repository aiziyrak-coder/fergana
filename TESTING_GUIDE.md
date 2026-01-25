# 🧪 Testing Guide - Professional Code Review

## ✅ Hal Qilingan Muammolar

### 1. Chiqindi Qutilar Takrorlanish Muammosi ✅

**Test Qilish**:
```bash
# 1. Backend'da konteynerlar sonini tekshirish
cd backend
python manage.py shell
>>> from smartcity_app.models import WasteBin, Organization
>>> org = Organization.objects.get(name='Fergana')
>>> bins = WasteBin.objects.filter(organization=org)
>>> print(f"Backend'da konteynerlar soni: {bins.count()}")
# Natija: 18 ta bo'lishi kerak

# 2. Frontend'da tekshirish
# Browser console'da:
# - "⚠️ Duplicate bins detected" xabari ko'rinmasligi kerak
# - Network tab'da /waste-bins/ so'rovida faqat 18 ta konteyner qaytishi kerak
```

**Kutilayotgan Natija**:
- ✅ Backend: 18 ta konteyner
- ✅ Frontend: 18 ta konteyner (takroriy yo'q)
- ✅ Console'da duplicate warning yo'q

---

### 2. IoT Sensor Ma'lumotlari Muammosi ✅

**Test Qilish**:
```bash
# 1. IoT device yaratish (agar yo'q bo'lsa)
cd backend
python manage.py shell
>>> from smartcity_app.models import IoTDevice, Coordinate
>>> coord = Coordinate.objects.create(lat=40.3734, lng=71.7978)
>>> device = IoTDevice.objects.create(
...     device_id="ESP-A4C416",
...     device_type="BOTH",
...     location=coord
... )
>>> print(f"Device yaratildi: {device.device_id}")

# 2. Sensor ma'lumotlarini yuborish
curl -X POST https://ferganaapi.cdcgroup.uz/api/iot-devices/data/update/ \
  -H "Content-Type: application/json" \
  -d '{
    "device_id": "ESP-A4C416",
    "temperature": 22.5,
    "humidity": 45.0
  }'

# 3. Backend log'larini tekshirish
tail -f /var/log/nginx/ferganaapi-error.log
# Yoki Django log:
tail -f /var/www/smartcity-backend/django.log
```

**Kutilayotgan Natija**:
- ✅ Response: `{"message": "Sensor data updated successfully", ...}`
- ✅ Backend log'da: `✅ Updated IoT device ESP-A4C416: temp=22.5°C, humidity=45.0%`
- ✅ Room yoki Boiler yangilangan bo'lishi kerak

---

### 3. Bot API IP Manzili ✅

**Test Qilish**:
```bash
# Bot faylini tekshirish
grep -n "API_BASE_URL" frontend/bot.py
# Natija: API_BASE_URL = "https://ferganaapi.cdcgroup.uz/api"

# Bot'ni ishga tushirish va test qilish
cd frontend
python bot.py
# Telegram'da /start komandasini yuborish
# QR kod skanerlash
# Rasm yuborish
```

**Kutilayotgan Natija**:
- ✅ Bot to'g'ri API'ga yuboradi
- ✅ Rasm tahlil qilinadi
- ✅ Konteyner yangilanadi

---

## 🔍 Umumiy Tekshiruv

### Backend Tekshiruv

```bash
cd backend

# 1. Django check
python manage.py check

# 2. Migration tekshirish
python manage.py showmigrations

# 3. Test ma'lumotlar
python manage.py shell
>>> from smartcity_app.models import *
>>> print(f"Organizations: {Organization.objects.count()}")
>>> print(f"WasteBins: {WasteBin.objects.count()}")
>>> print(f"Trucks: {Truck.objects.count()}")
>>> print(f"Facilities: {Facility.objects.count()}")
>>> print(f"Rooms: {Room.objects.count()}")
>>> print(f"Boilers: {Boiler.objects.count()}")
>>> print(f"IoTDevices: {IoTDevice.objects.count()}")

# 4. Duplicate konteynerlarni topish
python manage.py clean_duplicate_bins --dry-run
```

### Frontend Tekshiruv

```bash
cd frontend

# 1. TypeScript check
npm run lint

# 2. Build test
npm run build

# 3. Browser console'da tekshirish
# - Network tab'da API so'rovlar
# - Console'da error'lar yo'qligi
# - localStorage'da faqat unique ma'lumotlar
```

---

## 🐛 Ma'lum Xatolar va Yechimlar

### 1. "Duplicate bins detected" Warning

**Sabab**: Backend'da takroriy konteynerlar mavjud.

**Yechim**:
```bash
cd backend
python manage.py clean_duplicate_bins --keep-latest 18
```

### 2. "Device with ID not found"

**Sabab**: IoT device ID to'g'ri yozilmagan yoki mavjud emas.

**Yechim**:
- Device ID'ni tekshirish (ESP-A4C416 formatida)
- Backend'da device yaratish
- Bot'da device ID parsing yaxshilandi

### 3. "401 Unauthorized"

**Sabab**: Token eskirgan yoki noto'g'ri.

**Yechim**:
- Token avtomatik o'chiriladi
- Qayta login qilish kerak
- Error handling yaxshilandi

---

## 📊 Performance Tekshiruv

### 1. API Response Time

```bash
# Backend response time
time curl -X GET https://ferganaapi.cdcgroup.uz/api/waste-bins/ \
  -H "Authorization: Token YOUR_TOKEN"

# Kutilayotgan: < 500ms
```

### 2. Frontend Polling

- Har 5 soniyada polling
- Deduplication tez ishlaydi (Map orqali)
- localStorage yozish optimallashtirildi

---

## ✅ Yakuniy Tekshiruv Checklist

- [x] Chiqindi qutilar takrorlanish muammosi hal qilindi
- [x] IoT sensor ma'lumotlari to'g'ri keladi
- [x] Bot API to'g'ri IP'ga yubarmoqda
- [x] Deduplication barcha entity'lar uchun qo'shildi
- [x] Error handling yaxshilandi
- [x] Logging qo'shildi
- [x] Validation yaxshilandi
- [x] SaveBin funksiyasi yaxshilandi (update/create)
- [x] Backend'da duplicate check qo'shildi
- [x] Frontend'da deduplication qo'shildi

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
**Status**: ✅ Barcha asosiy muammolar hal qilindi va test qilindi
