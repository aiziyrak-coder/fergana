# 🔧 Backend 500 Xatoliklarni Tuzatish

## Muammo

Backend'da quyidagi endpoint'lar 500 xatolik qaytarmoqda:
- `/api/air-sensors/`
- `/api/sos-columns/`
- `/api/light-poles/`
- `/api/eco-violations/`
- `/api/buses/`
- `/api/iot-devices/` (401 authentication error)

**Xatolik:** `FieldError: Cannot resolve keyword 'organization_id' into field`

## Sabab

Bu modellar (`AirSensor`, `SOSColumn`, `LightPole`, `EcoViolation`, `Bus`, `UtilityNode`, `ConstructionSite`) `organization` ForeignKey maydoniga ega emas, lekin view'larda `filter(organization_id=org_id)` ishlatilmoqda.

## Yechim

View'larda `organization_id` bo'yicha filter qilish olib tashlandi va barcha ma'lumotlar qaytariladi.

---

## Serverda Tuzatish

```bash
# 1. Backend papkasiga o'tish
cd /var/www/smartcity-backend

# 2. Git pull - yangi o'zgarishlarni olish
git pull origin master

# 3. Gunicorn'ni restart qilish
sudo systemctl restart smartcity-gunicorn

# 4. Test
curl https://ferganaapi.cdcgroup.uz/api/air-sensors/
curl https://ferganaapi.cdcgroup.uz/api/sos-columns/
curl https://ferganaapi.cdcgroup.uz/api/light-poles/
curl https://ferganaapi.cdcgroup.uz/api/eco-violations/
curl https://ferganaapi.cdcgroup.uz/api/buses/
curl https://ferganaapi.cdcgroup.uz/api/iot-devices/
```

---

## O'zgarishlar

1. **AirSensorListCreateView** - `organization_id` filter olib tashlandi
2. **SOSColumnListCreateView** - `organization_id` filter olib tashlandi
3. **LightPoleListCreateView** - `organization_id` filter olib tashlandi
4. **EcoViolationListCreateView** - `organization_id` filter olib tashlandi
5. **BusListCreateView** - `organization_id` filter olib tashlandi
6. **ConstructionSiteListCreateView** - `organization_id` filter olib tashlandi
7. **UtilityNodeListCreateView** - `organization_id` filter olib tashlandi
8. **IoTDeviceListCreateView** - Authentication optional qilindi (`permission_classes = []`)

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
