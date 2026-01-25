# 🏙️ Smart City Dashboard - To'liq Dastur Tahlili

## 📋 Umumiy Ko'rinish

Bu loyiha **Farg'ona shahri** uchun aqlli shahar monitoring tizimi. Platforma **Django REST API** (backend) va **React + TypeScript + Vite** (frontend) texnologiyalari asosida qurilgan.

### 🌐 Production URLs
- **Frontend**: https://fergana.cdcgroup.uz
- **Backend API**: https://ferganaapi.cdcgroup.uz
- **Admin Panel**: https://ferganaapi.cdcgroup.uz/admin

---

## 📁 Backend Strukturasi (Django)

### Asosiy Fayllar

#### 1. **models.py** (810 qator)
**Maqsad**: Barcha ma'lumotlar bazasi modellarini belgilaydi.

**Asosiy Modellar**:
- `User` - Foydalanuvchilar (UUID asosida)
- `Organization` - Tashkilotlar (Hokimiyat, Agency, Enterprise)
- `WasteBin` - Chiqindi konteynerlari
- `Truck` - Maxsus texnika (haydovchilar bilan)
- `Facility` - Ob'ektlar (maktablar, bolalar bog'lari, kasalxonalar)
- `Room` - Xonalar (CharField ID - "0420101" formatida)
- `Boiler` - Qozonlar
- `IoTDevice` - IoT sensorlar (ESP-A4C416 kabi)
- `MoistureSensor` - Namlik sensorlari
- `AirSensor` - Havo sifati sensorlari
- `SOSColumn` - SOS ustunlar
- `EcoViolation` - Ekologik buzilishlar
- `ConstructionSite` - Qurilish maydonlari
- `LightPole` - Ko'cha chiroqlari
- `Bus` - Jamoat transporti
- `CallRequest` - Fuqarolar murojaatlari

**Yangi Modellar (Enhanced Features)**:
- `WasteTask` - Chiqindi yig'ish vazifalari
- `RouteOptimization` - Optimal marshrutlar
- `AlertNotification` - Ogohlantirishlar (SMS/Telegram/Email)
- `ClimateSchedule` - Avtomatik jadval (yoqish/o'chirish)
- `EnergyReport` - Energiya hisobotlari
- `WastePrediction` - AI prognoz (7-30 kun)
- `MaintenanceSchedule` - Texnik xizmat ko'rsatish
- `DriverPerformance` - Haydovchi statistikasi

#### 2. **views.py** (2538 qator)
**Maqsad**: Barcha API endpoint'lar va biznes logikani boshqaradi.

**Asosiy View'lar**:
- `login_view` - Autentifikatsiya (Organization, Truck, Superadmin)
- `WasteBinListCreateView` - Chiqindi konteynerlari CRUD
- `TruckListCreateView` - Maxsus texnika CRUD
- `FacilityListCreateView` - Ob'ektlar CRUD
- `IoTDeviceListCreateView` - IoT qurilmalar CRUD
- `update_iot_sensor_data` - IoT sensor ma'lumotlarini yangilash
- `link_iot_device_to_boiler` - IoT qurilmani qozonga ulash
- `link_iot_device_to_room` - IoT qurilmani xonaga ulash

**Yangi View'lar**:
- `WasteTaskListCreateView` - Vazifa boshqaruvi
- `auto_assign_task` - Avtomatik vazifa tayinlash
- `RouteOptimizationView` - Marshrut optimizatsiyasi
- `AlertNotificationListCreateView` - Ogohlantirishlar
- `ClimateScheduleListCreateView` - Jadval boshqaruvi
- `generate_energy_report` - Energiya hisoboti yaratish
- `generate_waste_prediction` - AI prognoz
- `get_waste_statistics` - Chiqindi statistikasi
- `get_climate_statistics` - Issiqlik statistikasi

**Maxsus Funksiyalar**:
- `update_bin_with_camera_image` - Kamera rasmini AI bilan tahlil qilish
- `analyze_bin_image_backend` - Google Gemini AI orqali rasm tahlili
- `dashboard_stats` - Dashboard statistikasi

#### 3. **serializers.py** (818 qator)
**Maqsad**: Frontend (camelCase) va Backend (snake_case) o'rtasida ma'lumotlarni konvertatsiya qiladi.

**Asosiy Serializer'lar**:
- `WasteBinSerializer` - QR kod URL mapping
- `TruckSerializer` - Haydovchi ma'lumotlari
- `FacilitySerializer` - Ob'ektlar (boiler va room bilan)
- `BoilerSerializer` - Qozonlar (device_health va connected_rooms)
- `RoomSerializer` - Xonalar
- `IoTDeviceSerializer` - IoT qurilmalar

**Yangi Serializer'lar**:
- `WasteTaskSerializer`
- `RouteOptimizationSerializer`
- `AlertNotificationSerializer`
- `ClimateScheduleSerializer`
- `EnergyReportSerializer`
- `WastePredictionSerializer`

#### 4. **urls.py** (163 qator)
**Maqsad**: Barcha API endpoint'larini belgilaydi.

**Asosiy URL'lar**:
```
/api/auth/login/ - Autentifikatsiya
/api/waste-bins/ - Chiqindi konteynerlari
/api/trucks/ - Maxsus texnika
/api/facilities/ - Ob'ektlar
/api/rooms/ - Xonalar
/api/boilers/ - Qozonlar
/api/iot-devices/ - IoT qurilmalar
/api/iot-devices/data/update/ - Sensor ma'lumotlarini yangilash
/api/iot-devices/link-to-boiler/ - Qozonga ulash
/api/iot-devices/link-to-room/ - Xonaga ulash
```

**Yangi URL'lar**:
```
/api/waste-tasks/ - Vazifalar
/api/waste-tasks/auto-assign/ - Avtomatik tayinlash
/api/routes/optimize/ - Marshrut optimizatsiyasi
/api/alerts/ - Ogohlantirishlar
/api/climate-schedules/ - Jadval
/api/reports/energy/generate/ - Energiya hisoboti
/api/reports/waste/statistics/ - Chiqindi statistikasi
/api/predictions/waste/ - AI prognoz
```

#### 5. **settings.py** (209 qator)
**Maqsad**: Django sozlamalari.

**Muhim Sozlamalar**:
- `ALLOWED_HOSTS` - ferganaapi.cdcgroup.uz, 167.71.53.238
- `CORS_ALLOWED_ORIGINS` - Frontend domainlar
- `DATABASES` - SQLite (dev) / PostgreSQL (prod)
- `REST_FRAMEWORK` - Token authentication
- `MEDIA_ROOT` - QR kodlar va rasmlar saqlanadi

#### 6. **admin.py** (310 qator)
**Maqsad**: Django Admin panelida barcha modellarni ko'rsatish.

**Admin Interface'lar**:
- Barcha modellar uchun list_display, list_filter, search_fields
- `RoomAdmin` - ID maydonini tahrirlash mumkin (CharField)

### Management Commands

**Fayllar**:
- `create_superusers.py` - Superadmin yaratish
- `populate_fargona_data.py` - Farg'ona uchun test ma'lumotlari
- `generate_bin_qrcodes.py` - QR kodlar yaratish
- `simulate_iot_sensors.py` - IoT sensorlarni simulyatsiya qilish
- `analyze_waste_bins.py` - Chiqindi konteynerlarini tahlil qilish
- `clean_duplicate_bins.py` - Takroriy konteynerlarni tozalash

### Migrations

**9 ta migration fayli**:
- `0001_initial.py` - Asosiy modellar
- `0002_alter_wastebin_google_maps_url_and_more.py`
- `0003_rename_target_temp_boiler_humidity_and_more.py`
- `0004_wastebin_qr_code_url.py` - QR kod qo'shildi
- `0005_boiler_created_at_boiler_last_updated_and_more.py`
- `0006_iotdevice_current_humidity_and_more.py` - IoT sensorlar
- `0007_change_room_id_to_charfield.py` - Room ID CharField
- `0008_wastebin_image.py` - Rasm maydoni
- `0009_enhanced_features.py` - Yangi modellar

---

## 📁 Frontend Strukturasi (React + TypeScript)

### Asosiy Fayllar

#### 1. **App.tsx** (853 qator)
**Maqsad**: Asosiy React komponenti, routing va state management.

**Asosiy Funksiyalar**:
- `session` - Foydalanuvchi sessiyasi
- `activeTab` - Faol tab (DASHBOARD, WASTE, CLIMATE, ...)
- `bins`, `trucks`, `facilities`, `rooms`, `boilers`, `iotDevices` - Ma'lumotlar state
- `updateBin` - Konteynerni yangilash (API bilan)
- Real-time polling (har 5 soniyada)

**Komponentlar**:
- `AuthNavigation` - Login sahifasi
- `DriverDashboard` - Haydovchi paneli
- `WasteManagement` - Chiqindi boshqaruvi
- `ClimateMonitor` - Issiqlik monitoringi
- `MoistureMap` - Xarita
- `SuperAdminDashboard` - Superadmin paneli

**Yangi Komponentlar**:
- `WasteReports` - Hisobotlar
- `TaskAssignment` - Vazifalar
- `RouteOptimization` - Marshrutlar
- `WastePrediction` - Prognoz
- `ClimateRealTimeGraph` - Real-time grafik
- `ClimateScheduler` - Jadval
- `ClimateAutoControl` - Avto-nazorat
- `EnergyAnalysis` - Energiya tahlili
- `ClimateReports` - Hisobotlar
- `AlertSystem` - Ogohlantirishlar

#### 2. **types.ts** (563 qator)
**Maqsad**: TypeScript interfeyslari va tiplar.

**Asosiy Tiplar**:
- `WasteBin` - Chiqindi konteyneri
- `Truck` - Maxsus texnika
- `Facility` - Ob'ekt
- `Room` - Xona
- `Boiler` - Qozon
- `IoTDevice` - IoT qurilma
- `UserSession` - Foydalanuvchi sessiyasi
- `Tab` - Tab tiplari

**Yangi Tiplar**:
- `WasteTask` - Vazifa
- `RouteOptimization` - Marshrut
- `AlertNotification` - Ogohlantirish
- `ClimateSchedule` - Jadval
- `EnergyReport` - Energiya hisoboti
- `WastePrediction` - Prognoz
- `DriverPerformance` - Haydovchi statistikasi

#### 3. **constants.ts** (358 qator)
**Maqsad**: Konstanta va mock data generatorlar.

**Asosiy Konstanta'lar**:
- `ALL_MODULES` - Barcha modullar ro'yxati
- `UZB_REGIONS` - O'zbekiston viloyatlari
- `GET_MFYS` - MFY ro'yxati generatori
- `generateWasteBins` - Test konteynerlari
- `generateTrucks` - Test texnikasi
- `generateFacilities` - Test ob'ektlari

#### 4. **services/api.ts** (700 qator)
**Maqsad**: Backend API bilan aloqa.

**Asosiy Funksiyalar**:
- `makeRequest` - Umumiy API so'rov
- `mapWasteBin` - snake_case -> camelCase
- `mapIoTDevice` - IoT qurilma mapping
- `mapBoilerFromBackend` - Qozon mapping
- `mapRoomFromBackend` - Xona mapping

**API Method'lar**:
- `getWasteBins`, `createWasteBin`, `updateWasteBin`
- `getTrucks`, `createTruck`, `updateTruck`
- `getFacilities`, `createFacility`, `updateFacility`
- `getRooms`, `createRoom`, `updateRoom`
- `getBoilers`, `createBoiler`, `updateBoiler`
- `getIoTDevices`, `createIoTDevice`, `updateIoTDevice`
- `updateIoTDeviceData` - Sensor ma'lumotlarini yangilash
- `linkIoTDeviceToBoiler` - Qozonga ulash
- `linkIoTDeviceToRoom` - Xonaga ulash

**Yangi Method'lar**:
- `getWasteTasks`, `createWasteTask`, `autoAssignTask`
- `optimizeRoute` - Marshrut optimizatsiyasi
- `getAlerts`, `createAlert`
- `getClimateSchedules`, `createClimateSchedule`
- `generateEnergyReport` - Energiya hisoboti
- `getWasteStatistics` - Chiqindi statistikasi
- `generateWastePrediction` - AI prognoz

#### 5. **services/auth.ts** (206 qator)
**Maqsad**: Autentifikatsiya xizmati.

**Funksiyalar**:
- `login` - Login qilish
- `validateToken` - Token tekshirish
- `setToken`, `getToken`, `removeToken` - Token boshqaruvi
- `getCsrfToken` - CSRF token olish

#### 6. **services/storage.ts** (841 qator)
**Maqsad**: LocalStorage va API o'rtasida sinxronizatsiya.

**Funksiyalar**:
- `getBins`, `saveBin` - Konteynerlar
- `getTrucks`, `saveTruck` - Texnika
- `getFacilities`, `saveFacility` - Ob'ektlar
- `getRooms`, `saveRoom` - Xonalar
- `getBoilers`, `saveBoiler` - Qozonlar
- `getIoTDevices`, `saveIoTDevice` - IoT qurilmalar

**Logika**:
- Avval API'dan olishga harakat qiladi
- Agar token yo'q bo'lsa, localStorage'dan o'qiydi
- 401 xatolik bo'lsa, token o'chiriladi

### Komponentlar (components/)

**Asosiy Komponentlar** (31 ta):
1. `WasteManagement.tsx` - Chiqindi boshqaruvi
2. `ClimateMonitor.tsx` - Issiqlik monitoringi
3. `MoistureMap.tsx` - Xarita (Google Maps)
4. `DriverDashboard.tsx` - Haydovchi paneli
5. `AuthNavigation.tsx` - Login sahifasi
6. `SuperAdminDashboard.tsx` - Superadmin paneli
7. `AirQualityMonitor.tsx` - Havo sifati
8. `SecurityMonitor.tsx` - Xavfsizlik
9. `EcoControlMonitor.tsx` - Ekologik nazorat
10. `LightInspector.tsx` - Ko'cha chiroqlari
11. `PublicTransport.tsx` - Jamoat transporti
12. `AICallCenter.tsx` - AI Call Center
13. `CitizenPortal.tsx` - Fuqarolar portali
14. `AnalyticsView.tsx` - Tahlil
15. `LockedModule.tsx` - Qulangan modul

**Yangi Komponentlar** (11 ta):
16. `WasteReports.tsx` - Chiqindi hisobotlari
17. `TaskAssignment.tsx` - Vazifa tayinlash
18. `RouteOptimization.tsx` - Marshrut optimizatsiyasi
19. `WastePrediction.tsx` - AI prognoz
20. `ClimateRealTimeGraph.tsx` - Real-time grafik
21. `ClimateScheduler.tsx` - Jadval
22. `ClimateAutoControl.tsx` - Avto-nazorat
23. `EnergyAnalysis.tsx` - Energiya tahlili
24. `ClimateReports.tsx` - Issiqlik hisobotlari
25. `AlertSystem.tsx` - Ogohlantirishlar tizimi
26. `ClimateAlerts.tsx` - Issiqlik ogohlantirishlari

### Konfiguratsiya Fayllari

#### **package.json**
**Dependencies**:
- `react` (18.2.0)
- `react-dom` (18.2.0)
- `framer-motion` (11.0.8) - Animatsiyalar
- `lucide-react` (0.454.0) - Ikonlar
- `@google/genai` (0.3.0) - Google AI
- `uuid` (9.0.1)

**DevDependencies**:
- `vite` (5.4.21) - Build tool
- `typescript` (5.2.2)
- `tailwindcss` (3.4.1) - CSS framework
- `@vitejs/plugin-react` (5.1.2)

#### **vite.config.ts**
- Port: 3000
- Host: 0.0.0.0
- Gemini API key sozlamalari

#### **tsconfig.json**
- TypeScript konfiguratsiyasi

#### **tailwind.config.js**
- Tailwind CSS sozlamalari

---

## 🔐 Autentifikatsiya

### Login Turlari

1. **Organization Login**:
   - `login`: tashkilot login'i (masalan: "fergan")
   - `password`: parol
   - Role: `ORGANIZATION`
   - Enabled modules: `['DASHBOARD', 'WASTE', 'CLIMATE']`

2. **Truck/Driver Login**:
   - `login`: haydovchi login'i
   - `password`: parol
   - Role: `DRIVER`
   - Enabled modules: `['WASTE']`

3. **Superadmin Login**:
   - `login`: "superadmin"
   - `password`: "123"
   - Role: `SUPERADMIN`
   - Enabled modules: `['DASHBOARD', 'WASTE', 'CLIMATE']`

### Token Authentication

- Token `localStorage`'da saqlanadi
- Har bir API so'rovida `Authorization: Token <token>` header qo'shiladi
- Token validation har safar API so'rovida tekshiriladi

---

## 📡 API Endpoints

### Authentication
- `POST /api/auth/login/` - Login
- `GET /api/auth/validate/` - Token tekshirish

### Waste Management
- `GET /api/waste-bins/` - Barcha konteynerlar
- `POST /api/waste-bins/` - Yangi konteyner
- `GET /api/waste-bins/<id>/` - Konteyner ma'lumotlari
- `PATCH /api/waste-bins/<id>/` - Konteynerni yangilash
- `PATCH /api/waste-bins/<id>/update-image/` - Rasm yangilash
- `POST /api/waste-tasks/` - Vazifa yaratish
- `POST /api/waste-tasks/auto-assign/` - Avtomatik tayinlash
- `POST /api/routes/optimize/` - Marshrut optimizatsiyasi
- `POST /api/predictions/waste/` - AI prognoz

### Climate Control
- `GET /api/facilities/` - Barcha ob'ektlar
- `POST /api/facilities/` - Yangi ob'ekt
- `GET /api/rooms/` - Barcha xonalar
- `GET /api/boilers/` - Barcha qozonlar
- `POST /api/climate-schedules/` - Jadval yaratish
- `POST /api/reports/energy/generate/` - Energiya hisoboti

### IoT Devices
- `GET /api/iot-devices/` - Barcha IoT qurilmalar
- `POST /api/iot-devices/data/update/` - Sensor ma'lumotlarini yangilash
- `POST /api/iot-devices/link-to-boiler/` - Qozonga ulash
- `POST /api/iot-devices/link-to-room/` - Xonaga ulash

### Trucks
- `GET /api/trucks/` - Barcha texnika
- `POST /api/trucks/` - Yangi texnika
- `GET /api/drivers/<truck_id>/performance/` - Haydovchi statistikasi

---

## 🗄️ Ma'lumotlar Bazasi

### SQLite (Development)
- Fayl: `backend/db.sqlite3`
- Django ORM orqali boshqariladi

### PostgreSQL (Production)
- Production server'da ishlatiladi

### Asosiy Jadval'lar

1. **smartcity_app_user** - Foydalanuvchilar
2. **smartcity_app_organization** - Tashkilotlar
3. **smartcity_app_wastebin** - Chiqindi konteynerlari
4. **smartcity_app_truck** - Maxsus texnika
5. **smartcity_app_facility** - Ob'ektlar
6. **smartcity_app_room** - Xonalar
7. **smartcity_app_boiler** - Qozonlar
8. **smartcity_app_iotdevice** - IoT qurilmalar
9. **smartcity_app_wastetask** - Vazifalar
10. **smartcity_app_routeoptimization** - Marshrutlar
11. **smartcity_app_alertnotification** - Ogohlantirishlar
12. **smartcity_app_climateschedule** - Jadval
13. **smartcity_app_energyreport** - Energiya hisobotlari
14. **smartcity_app_wasteprediction** - AI prognoz

---

## 🤖 Telegram Bot

### Bot Token
`8380253670:AAGdoT2SRVpmHHu47s_ZHF_3l9fuURA-Uo4`

### Bot Fayllari
- `frontend/bot.py` - Telegram bot kodi
- `frontend/hokimiyat-master/` - Bot integratsiyasi

### Funksiyalar
- QR kod skanerlash
- Konteyner rasmini yuklash
- AI tahlil qilish
- Ma'lumotlarni backend'ga yuborish

---

## 🚀 Deployment

### Server
- IP: `167.71.53.238`
- Domain: `ferganaapi.cdcgroup.uz` (backend)
- Domain: `fergana.cdcgroup.uz` (frontend)

### Deployment Scripts
- `deploy.sh` - Asosiy deployment script
- `DEPLOY_GUIDE.md` - Batafsil qo'llanma
- `setup-server.sh` - Server sozlash

### Services
- `gunicorn` - Django WSGI server
- `nginx` - Reverse proxy
- `systemd` - Service management

---

## 📊 Modullar

### ✅ Faol Modullar

1. **Markaz (DASHBOARD)**
   - Asosiy ko'rsatkichlar
   - Real-time monitoring

2. **Chiqindi (WASTE)**
   - Konteynerlar boshqaruvi
   - Texnika monitoringi
   - Hisobotlar (WASTE_REPORTS)
   - Vazifalar (WASTE_TASKS)
   - Marshrutlar (WASTE_ROUTES)
   - Prognoz (WASTE_PREDICTION)

3. **Issiqlik (CLIMATE)**
   - Ob'ektlar monitoringi
   - Xonalar va qozonlar
   - Real-Time grafik (CLIMATE_REALTIME)
   - Jadval (CLIMATE_SCHEDULER)
   - Avto-Nazorat (CLIMATE_AUTO)
   - Energiya tahlili (CLIMATE_ENERGY)
   - Hisobotlar (CLIMATE_REPORTS)
   - Ogohlantirishlar (ALERTS)

### 🔒 Qulangan Modullar

- Namlik (MOISTURE)
- Havo (AIR)
- Xavfsizlik (SECURITY)
- Eco-Nazorat (ECO_CONTROL)
- Qurilish (CONSTRUCTION)
- Light-AI (LIGHT_INSPECTOR)
- Transport (TRANSPORT)
- Murojaatlar (CALL_CENTER)
- Tahlil (ANALYTICS)

---

## 🔧 Texnologiyalar

### Backend
- **Django** 4.2.7
- **Django REST Framework** 3.14.0
- **django-cors-headers** 4.3.1
- **Pillow** 10.0.1 (rasm boshqaruvi)
- **qrcode** 7.4.2 (QR kod yaratish)
- **python-telegram-bot** 20.7 (Telegram bot)
- **requests** 2.31.0 (HTTP so'rovlar)

### Frontend
- **React** 18.2.0
- **TypeScript** 5.2.2
- **Vite** 5.4.21
- **Tailwind CSS** 3.4.1
- **Framer Motion** 11.0.8 (animatsiyalar)
- **Lucide React** 0.454.0 (ikonlar)
- **@google/genai** 0.3.0 (Google AI)

---

## 📝 Muhim Xususiyatlar

### 1. QR Kod Integratsiyasi
- Har bir konteyner uchun QR kod avtomatik yaratiladi
- Telegram bot orqali skanerlash
- Rasm yuklash va AI tahlil

### 2. IoT Sensor Integratsiyasi
- ESP qurilmalar (ESP-A4C416)
- Real-time harorat va namlik o'lchash
- Qozon va xonalarga avtomatik ulash

### 3. AI Funksiyalar
- Google Gemini AI orqali rasm tahlili
- Chiqindi to'lish prognozi (7-30 kun)
- Avtomatik vazifa tayinlash

### 4. Real-time Updates
- Frontend har 5 soniyada ma'lumotlarni yangilaydi
- WebSocket emas, polling ishlatiladi

### 5. Multi-tenant Architecture
- Har bir tashkilot o'z ma'lumotlarini ko'radi
- Organization-based filtering

---

## 🐛 Ma'lum Xatolar va Yechimlar

### 1. Takroriy Konteynerlar
- **Muammo**: Bir xil konteyner bir necha marta yaratilgan
- **Yechim**: `clean_duplicate_bins.py` script

### 2. Room ID Format
- **Muammo**: Room ID integer bo'lib, leading zero'lar yo'qolgan
- **Yechim**: CharField ga o'zgartirildi (migration 0007)

### 3. CORS Xatolari
- **Muammo**: Frontend backend'ga ulana olmaydi
- **Yechim**: `CORS_ALLOWED_ORIGINS` sozlandi

### 4. Token Validation
- **Muammo**: Token tekshirishda xatolik
- **Yechim**: `validateToken` funksiyasi yaxshilandi

---

## 📈 Statistika

### Kod Miqdori
- **Backend**: ~15,000+ qator Python kodi
- **Frontend**: ~20,000+ qator TypeScript/React kodi
- **Jami**: ~35,000+ qator kod

### Fayllar
- **Backend Python fayllari**: 38 ta
- **Frontend TypeScript/TSX fayllari**: 31 ta
- **Komponentlar**: 31 ta
- **Migration fayllari**: 9 ta

### Modellar
- **Asosiy modellar**: 20+ ta
- **Yangi modellar**: 8 ta
- **Jami**: 28+ ta model

---

## 🎯 Keyingi Rivojlanish

### Rejalashtirilgan
1. WebSocket integratsiyasi (real-time updates)
2. Mobile app (React Native)
3. Advanced analytics dashboard
4. Machine learning model'lar
5. Multi-language support

---

## 📞 Yordam

### Login Ma'lumotlari
- **Django Admin**: admin / 123
- **Application**: fergan / 123
- **Superadmin**: superadmin / 123

### Support
- Developer: CDCGroup
- Powered by: CraDev

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
**Versiya**: 2.0 Enhanced Edition
