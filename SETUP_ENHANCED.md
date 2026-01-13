# 🚀 Yangi Funksiyalarni O'rnatish - Tezkor Yo'riqnoma

## 1️⃣ Backend O'rnatish (5 daqiqa)

### Migration qilish:

```bash
cd E:\Smartcity\backend
python manage.py migrate
```

✅ **Natija:** 7 ta yangi jadval yaratiladi:
- waste_task
- route_optimization
- alert_notification
- climate_schedule
- energy_report
- waste_prediction
- maintenance_schedule
- driver_performance

---

## 2️⃣ Yangi Modullarni Yoqish (2 daqiqa)

### Django Admin orqali:

1. Brauzerda oching: `http://localhost:8000/admin/`
2. Login: `admin` / `123`
3. **Organizations** → **Farg'ona Shahar** ni tanlang
4. **Enabled modules** maydoniga qo'shing:

```json
[
  "DASHBOARD",
  "WASTE",
  "WASTE_REPORTS",
  "WASTE_TASKS", 
  "WASTE_ROUTES",
  "WASTE_PREDICTION",
  "CLIMATE",
  "CLIMATE_REALTIME",
  "CLIMATE_SCHEDULER",
  "CLIMATE_AUTO",
  "CLIMATE_ENERGY",
  "CLIMATE_REPORTS",
  "ALERTS"
]
```

5. **Save** tugmasini bosing

---

## 3️⃣ Frontend Ishga Tushirish (1 daqiqa)

```bash
cd E:\Smartcity\frontend
npm run dev
```

Frontend avtomatik yangi komponentlarni yuklaydi. ✅

---

## 4️⃣ Sinab Ko'rish

### Chiqindi Modulini Sinash:

1. Brauzerda oching: `http://localhost:3000`
2. Login: `fergan` / `123`
3. Yuqori menyudan **"Chiqindi Hisobotlar"** ni bosing
4. **Statistika** ko'rsatiladi
5. **Excel** tugmasini bosing - hisobot yuklanadi ✅

### Vazifa Tayinlashni Sinash:

1. **"Vazifalar"** tabini oching
2. To'lgan konteyner ko'rsatiladi
3. **"Avtomatik Tayinlash"** tugmasini bosing
4. Tizim eng yaqin haydovchini topadi va vazifa tayinlaydi ✅

### Marshrut Yaratishni Sinash:

1. **"Marshrutlar"** tabini oching
2. Haydovchini tanlang
3. Konteynerlarni belgilang
4. **"Marshrutni Optimallashtirish"** tugmasini bosing
5. Xaritada optimal yo'l ko'rsatiladi ✅

### Issiqlik Modulini Sinash:

1. **"Real-Time"** tabini oching
2. 24 soatlik jonli grafik ko'rsatiladi ✅

3. **"Jadval"** tabini oching
4. **"Yangi Jadval"** tugmasini bosing
5. Ob'ekt, vaqt, kunlarni tanlang
6. Saqlang - avtomatik ishlaydi ✅

7. **"Avto-Nazorat"** tabini oching
8. Sozlamalarni kiriting
9. **"YOQISH"** tugmasini bosing
10. Tizim avtomatik harorat/namlikni nazorat qiladi ✅

---

## 5️⃣ Sozlamalar (Ixtiyoriy)

### SMS Integratsiyasi (Eskiz.uz):

`backend/smartcity_backend/settings.py` ga qo'shing:

```python
# SMS Settings
ESKIZ_EMAIL = "your_email@example.com"
ESKIZ_PASSWORD = "your_password"
ESKIZ_API_URL = "https://notify.eskiz.uz/api"
```

### Telegram Bot:

```python
# Telegram Settings
TELEGRAM_BOT_TOKEN = "8380253670:AAGdoT2SRVpmHHu47s_ZHF_3l9fuURA-Uo4"
TELEGRAM_CHAT_ID = "your_chat_id"
```

### Email (Gmail):

```python
# Email Settings
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'your_email@gmail.com'
EMAIL_HOST_PASSWORD = 'your_app_password'
```

---

## 🎯 Tez Sinov

### Chiqindi:
```bash
# Terminal 1: Backend
cd backend
python manage.py runserver

# Terminal 2: Frontend
cd frontend
npm run dev

# Terminal 3: Test
curl -X POST http://localhost:8000/api/waste-tasks/auto-assign/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Token YOUR_TOKEN" \
  -d '{"bin_id": "BIN_ID_HERE"}'
```

### Issiqlik:
```bash
# Energiya hisoboti yaratish
curl -X POST http://localhost:8000/api/reports/energy/generate/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Token YOUR_TOKEN" \
  -d '{"facility_id": "FACILITY_ID", "report_type": "MONTHLY"}'
```

---

## ✅ Tayyor!

Barcha funksiyalar ishga tushdi! 🎉

**Keyingi qadam:** Production serverga deploy qilish

Ko'proq ma'lumot: `ENHANCED_FEATURES.md`

---

© 2026 Smart City - CDCGroup
