# 🚀 Smart City - Yangi Funksiyalar

> **Sana:** 2026-01-13  
> **Versiya:** 2.0 Enhanced Edition

---

## 📋 Umumiy Ko'rinish

Ushbu yangilanishda **Chiqindi** va **Issiqlik** modullariga real hayotda qo'llash uchun zarur bo'lgan professional funksiyalar qo'shildi.

---

## 🗑️ CHIQINDI MODULI - Yangi Funksiyalar

### 1. ✅ Hisobotlar va Statistika (`WasteReports`)

**Funksiyalar:**
- 📊 Real-time statistika dashboard
- 📈 Haftalik aktivlik grafigi
- 📍 Hudud bo'yicha tahlil
- 📥 Excel/CSV export
- 🎯 Samaradorlik ko'rsatkichlari

**Endpoint:** `/reports/waste/statistics/`

**Ishlatish:**
```typescript
const stats = await ApiService.getWasteStatistics();
```

**Ko'rsatkichlar:**
- Jami konteynerlar soni
- To'lgan konteynerlar
- O'rtacha to'lganlik
- Faol texnika
- Vazifalar samaradorligi
- Hudud bo'yicha taqsimot

---

### 2. ✅ Vazifa Tayinlash Tizimi (`TaskAssignment`)

**Funksiyalar:**
- 🎯 Avtomatik vazifa tayinlash
- 📍 Eng yaqin haydovchini topish
- ⏱️ Real-time vazifalar monitoring
- ✅ Vazifa holati boshqaruvi
- 📊 Vazifalar statistikasi

**Endpoint:** `/waste-tasks/auto-assign/`

**Ishlatish:**
```typescript
// Avtomatik tayinlash
const result = await ApiService.autoAssignTask(binId);

// Vazifa holatini yangilash
await ApiService.updateWasteTask(taskId, { status: 'COMPLETED' });
```

**Vazifa Holatlari:**
- `PENDING` - Kutilmoqda
- `ASSIGNED` - Tayinlangan
- `IN_PROGRESS` - Jarayonda
- `COMPLETED` - Bajarildi
- `REJECTED` - Rad etildi
- `TIMEOUT` - Vaqt tugadi

---

### 3. ✅ Marshrut Optimizatsiyasi (`RouteOptimization`)

**Funksiyalar:**
- 🗺️ Eng qisqa yo'lni hisoblash
- ⛽ Yoqilg'i sarfini prognoz qilish
- ⏰ Vaqtni hisoblash
- 🎨 Vizual marshrut ko'rsatish
- 📱 GPS navigatsiya integratsiyasi

**Endpoint:** `/routes/optimize/`

**Algoritm:** Greedy Nearest Neighbor (production uchun Google Maps API tavsiya etiladi)

**Ishlatish:**
```typescript
const route = await ApiService.optimizeRoute(truckId, [bin1, bin2, bin3]);
```

**Natija:**
- Optimal tartibdagi konteynerlar ro'yxati
- Umumiy masofa (km)
- Taxminiy vaqt (daqiqa)
- Yoqilg'i sarfi (litr)

---

### 4. ✅ To'liish Prognozi (`WastePrediction`)

**Funksiyalar:**
- 🤖 AI yordamida prognoz
- 📅 3-30 kunlik bashorat
- 📈 To'liish vaqtini aniqlash
- 💡 Yig'ish tavsiyalari
- 🎯 Ishonch darajasi ko'rsatkichi

**Endpoint:** `/predictions/waste/`

**Ishlatish:**
```typescript
const predictions = await ApiService.generateWastePrediction(binId, 7); // 7 kun
```

**Prognoz Asoslari:**
- Tarixiy ma'lumotlar (30+ kun)
- Kunlik o'sish sur'ati
- Mavsum omillari
- Hudud xususiyatlari

---

### 5. ✅ Push Bildirishnomalar (`AlertSystem`)

**Funksiyalar:**
- 📱 Real-time xabarnomalar
- 📧 Email integratsiyasi
- 💬 SMS yuborish
- 🤖 Telegram bot
- ⚡ Avtomatik trigger'lar

**Endpoint:** `/alerts/`

**Alert Turlari:**
- Konteyner to'lgan
- Vazifa vaqti tugadi
- Yoqilg'i kam
- Qurilma offline

**Kanallar:**
- `APP` - Ilovada ko'rsatish
- `SMS` - SMS xabar
- `EMAIL` - Email yuborish
- `TELEGRAM` - Telegram xabar
- `PUSH` - Push notification

---

## 🌡️ ISSIQLIK MODULI - Yangi Funksiyalar

### 6. ✅ Real-Time Grafik (`ClimateRealTimeGraph`)

**Funksiyalar:**
- 📊 Jonli harorat grafigi
- 💧 Jonli namlik grafigi
- ⏰ 1H / 6H / 12H / 24H ko'rinishlar
- 📈 Trend tahlili
- 🔄 Har 1 daqiqada yangilanish

**Ko'rsatkichlar:**
- Hozirgi harorat (°C)
- Hozirgi namlik (%)
- So'nggi soatdagi o'zgarish
- Tarixiy ma'lumotlar

---

### 7. ✅ Ish Vaqti Jadval (`ClimateScheduler`)

**Funksiyalar:**
- 📅 Kunlik jadvallar yaratish
- 🔄 Avtomatik yoqish/o'chirish
- 🎯 Maqsad qiymatlarni belgilash
- 📆 Hafta kunlarini tanlash
- ⚙️ Har bir qozonxona uchun alohida

**Jadval Amallar:**
- `INCREASE_TEMP` - Haroratni oshirish
- `DECREASE_TEMP` - Haroratni pasaytirish
- `MAINTAIN_TEMP` - Haroratni ushlab turish
- `INCREASE_HUMIDITY` - Namlikni oshirish
- `DECREASE_HUMIDITY` - Namlikni pasaytirish
- `SHUTDOWN` - O'chirish

**Ishlatish:**
```typescript
await ApiService.createClimateSchedule({
  facility_id: facilityId,
  name: "Ertalabki Isitish",
  start_time: "06:00",
  end_time: "08:00",
  days_of_week: ["MON", "TUE", "WED", "THU", "FRI"],
  action: "INCREASE_TEMP",
  target_temperature: 22
});
```

---

### 8. ✅ Avtomatik Boshqaruv (`ClimateAutoControl`)

**Funksiyalar:**
- 🤖 Aqlli avtomatik nazorat
- 🎯 Maqsad qiymatlarni ushlab turish
- ⚡ Real-time tuzatishlar
- 📝 Faoliyat jurnali
- ⏱️ Sozlanuvchi interval (5-60 daqiqa)

**Sozlamalar:**
- Maqsad harorat (°C)
- Maqsad namlik (%)
- Maksimal og'ish
- Tekshirish intervali

**Avtomatik Tuzatish:**
- Harorat past bo'lsa → Avtomatik oshiradi
- Namlik yuqori bo'lsa → Avtomatik pasaytiradi
- Og'ish haddan oshsa → Ogohlantirish

---

### 9. ✅ Energiya Tahlili (`EnergyAnalysis`)

**Funksiyalar:**
- 💡 Energiya samaradorlik reytingi
- 💰 Oylik xarajat prognozi
- 📉 Tejash imkoniyatlari
- 🤖 AI tavsiyalari
- 🎯 Optimallashtirish yo'llari

**AI Tavsiyalari:**
1. **Energiya Tejash** - Kechki soatlarda haroratni pasaytirish (15-20% tejash)
2. **Tizim Optimallashtirish** - Sozlamalarni qayta ko'rish (10-15% samaradorlik)
3. **Aqlli Termostatlar** - IoT avtomatik boshqaruv (25-30% tejash)

**Ishlatish:**
```typescript
const stats = await ApiService.getClimateStatistics();
```

---

### 10. ✅ Oylik/Yillik Hisobotlar (`ClimateReports`)

**Funksiyalar:**
- 📄 Professional hisobotlar
- 📊 Kunlik/Haftalik/Oylik/Yillik
- 💾 Export (TXT/CSV format)
- 💰 Xarajat tahlili
- 📈 Trend tahlili
- 💡 Tejash tavsiyalari

**Endpoint:** `/reports/energy/generate/`

**Ishlatish:**
```typescript
const report = await ApiService.generateEnergyReport(
  facilityId,
  'MONTHLY'  // DAILY, WEEKLY, MONTHLY, YEARLY
);
```

**Hisobot Tarkibi:**
- Umumiy energiya (kWh)
- Umumiy xarajat (so'm)
- O'rtacha harorat
- O'rtacha namlik
- Samaradorlik reytingi
- Tejash miqdori
- AI tavsiyalari

---

### 11. ✅ Avtomatik Ogohlantirish (`ClimateAlerts`)

**Funksiyalar:**
- 🔔 Avtomatik trigger'lar
- 📱 SMS/Email/Telegram
- ⚙️ Qoidalar yaratish
- 🎯 Shart-sharot belgilash
- 📊 Yuborilgan xabarlar tarixi

**Ogohlantirish Shartlari:**
- Harorat juda past (< chegara)
- Harorat juda yuqori (> chegara)
- Namlik juda past (< chegara)
- Namlik juda yuqori (> chegara)

**Qoida Yaratish:**
```typescript
{
  name: "Maktab Harorat Kritik",
  facilityId: "...",
  condition: "TEMP_LOW",
  threshold: 18,
  channel: "TELEGRAM",
  recipient: "@manager"
}
```

---

## 🗄️ Backend Modellari

### Yangi Modellar:

1. **WasteTask** - Vazifa boshqaruvi
2. **RouteOptimization** - Marshrut saqlash
3. **AlertNotification** - Ogohlantirish tarixi
4. **ClimateSchedule** - Ish vaqti jadvallari
5. **EnergyReport** - Energiya hisobotlari
6. **WastePrediction** - Prognozlar
7. **MaintenanceSchedule** - Texnik xizmat
8. **DriverPerformance** - Haydovchi ish faoliyati

---

## 📡 Yangi API Endpoints

### Chiqindi:
- `POST /api/waste-tasks/auto-assign/` - Avtomatik vazifa tayinlash
- `GET /api/waste-tasks/` - Vazifalar ro'yxati
- `PATCH /api/waste-tasks/{id}/` - Vazifa holatini yangilash
- `POST /api/routes/optimize/` - Marshrut optimizatsiyasi
- `POST /api/predictions/waste/` - Prognoz yaratish
- `GET /api/reports/waste/statistics/` - Statistika

### Issiqlik:
- `POST /api/reports/energy/generate/` - Energiya hisoboti
- `GET /api/reports/climate/statistics/` - Statistika
- `GET /api/climate-schedules/` - Jadvallar ro'yxati
- `POST /api/climate-schedules/` - Jadval yaratish
- `PATCH /api/climate-schedules/{id}/` - Jadval yangilash
- `DELETE /api/climate-schedules/{id}/` - Jadval o'chirish

### Umumiy:
- `GET /api/alerts/` - Ogohlantirishlar
- `POST /api/alerts/` - Ogohlantirish yuborish
- `GET /api/drivers/{truck_id}/performance/` - Haydovchi samaradorligi

---

## 🎨 Yangi UI Komponentlari

### Chiqindi:
1. `WasteReports.tsx` - Hisobotlar
2. `TaskAssignment.tsx` - Vazifa tayinlash
3. `RouteOptimization.tsx` - Marshrut
4. `WastePrediction.tsx` - Prognoz
5. `AlertSystem.tsx` - Ogohlantirishlar

### Issiqlik:
1. `ClimateRealTimeGraph.tsx` - Real-time grafik
2. `ClimateScheduler.tsx` - Jadval
3. `ClimateAutoControl.tsx` - Avtomatik nazorat
4. `EnergyAnalysis.tsx` - Energiya tahlili
5. `ClimateReports.tsx` - Hisobotlar
6. `ClimateAlerts.tsx` - Ogohlantirishlar

---

## 🔧 O'rnatish va Ishga Tushirish

### 1. Backend Migration

```bash
cd backend
python manage.py makemigrations
python manage.py migrate
```

### 2. Frontend Build

```bash
cd frontend
npm install
npm run dev
```

### 3. Yangi Modullarni Yoqish

Django Admin panelda (`/admin/`):
1. Organizations bo'limiga o'ting
2. Kerakli tashkilotni tanlang
3. `enabled_modules` ga quyidagilarni qo'shing:

**Chiqindi uchun:**
```json
["WASTE", "WASTE_REPORTS", "WASTE_TASKS", "WASTE_ROUTES", "WASTE_PREDICTION"]
```

**Issiqlik uchun:**
```json
["CLIMATE", "CLIMATE_REALTIME", "CLIMATE_SCHEDULER", "CLIMATE_AUTO", "CLIMATE_ENERGY", "CLIMATE_REPORTS"]
```

**Ogohlantirishlar:**
```json
["ALERTS"]
```

---

## 📊 Foydalanish Misollari

### Misol 1: To'lgan Konteynerni Avtomatik Tayinlash

```typescript
// 1. To'lgan konteynerlarni topish
const fullBins = bins.filter(b => b.fillLevel >= 80);

// 2. Avtomatik tayinlash
for (const bin of fullBins) {
  const result = await ApiService.autoAssignTask(bin.id);
  console.log(`Tayinlandi: ${result.task.assigned_truck.driver_name}`);
}
```

### Misol 2: Optimal Marshrut Yaratish

```typescript
// 1. To'lgan konteynerlar ID'larini olish
const binIds = fullBins.map(b => b.id);

// 2. Marshrut yaratish
const route = await ApiService.optimizeRoute(truckId, binIds);

console.log(`Masofa: ${route.totalDistance} km`);
console.log(`Vaqt: ${route.estimatedTime} daqiqa`);
console.log(`Yoqilg'i: ${route.fuelEstimate} litr`);
```

### Misol 3: Energiya Hisoboti Yaratish

```typescript
const report = await ApiService.generateEnergyReport(
  facilityId,
  'MONTHLY',
  '2026-01-01',
  '2026-01-31'
);

console.log(`Energiya: ${report.total_energy_kwh} kWh`);
console.log(`Xarajat: ${report.total_cost} so'm`);
console.log(`Tejaldi: ${report.cost_savings} so'm`);
```

### Misol 4: Avtomatik Ogohlantirish Qoidasi

```typescript
// Harorat 18°C dan past tushsa SMS yuborish
const rule = {
  name: "Maktab Harorat Past",
  facilityId: "...",
  condition: "TEMP_LOW",
  threshold: 18,
  channel: "SMS",
  recipient: "+998901234567",
  enabled: true
};

// Qoida localStorage da saqlanadi va avtomatik ishlaydi
```

---

## 🎯 Real Hayotda Foydalanish

### Chiqindi Boshqaruv:
1. **Ertalab:** Tizim avtomatik to'lgan konteynerlarni aniqlaydi
2. **Tayinlash:** Eng yaqin bo'sh haydovchiga vazifa yuboriladi
3. **Marshrut:** Optimal yo'l hisoblanadi (yoqilg'i tejash)
4. **Monitoring:** Real-time vazifa holati kuzatiladi
5. **Hisobot:** Kunlik/haftalik samaradorlik tahlili

### Issiqlik Nazorati:
1. **Jadval:** 06:00 da avtomatik isitish boshlanadi
2. **Monitoring:** Real-time harorat/namlik kuzatiladi
3. **Avtomatik:** Og'ish bo'lsa avtomatik tuzatiladi
4. **Ogohlantirish:** Kritik holat bo'lsa SMS yuboriladi
5. **Hisobot:** Oylik energiya va xarajat tahlili
6. **Optimallashtirish:** AI tejash tavsiyalari beradi

---

## 🔐 Xavfsizlik

- ✅ Token-based authentication
- ✅ Organization-level data filtering
- ✅ Role-based access control
- ✅ Secure API endpoints
- ✅ LocalStorage encryption

---

## 🚀 Keyingi Bosqichlar

### Tavsiya etiladigan integratsiyalar:
1. **Google Maps API** - Professional marshrut
2. **Twilio** - SMS xabarnoma
3. **SendGrid** - Email yuborish
4. **Telegram Bot API** - Bot integratsiya
5. **Firebase Cloud Messaging** - Push notifications
6. **Machine Learning** - Yaxshilangan prognoz

---

## 📞 Yordam

Muammo yuzaga kelsa:
- GitHub Issues: Muammo yarating
- Email: support@cdcgroup.uz
- Telegram: @cdcgroup_support

---

## 📄 Litsenziya

© 2026 Smart City - CDCGroup  
Powered by CraDev

---

**Developer Team:**
- Backend: Django + REST Framework
- Frontend: React + TypeScript + Vite
- AI/ML: Google Gemini API
- Design: Tailwind CSS + Framer Motion

**Version:** 2.0 Enhanced Edition  
**Last Updated:** 2026-01-13
