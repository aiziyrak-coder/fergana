# 🏙️ Smart City Dashboard - Farg'ona

![Status](https://img.shields.io/badge/status-production-success)
![License](https://img.shields.io/badge/license-MIT-blue)

Aqlli shahar monitoring tizimi - Farg'ona shahri uchun to'liq funksional platforma.

## 🌐 Live Demo
- **Frontend**: https://fergana.cdcgroup.uz
- **Backend API**: https://ferganaapi.cdcgroup.uz
- **Admin Panel**: https://ferganaapi.cdcgroup.uz/admin

## 📁 Repository Structure

```
E:\Smartcity\
├── backend/              # Django REST API
├── frontend/             # React + TypeScript + Vite
├── deploy.sh            # Deployment script
├── DEPLOY_GUIDE.md      # Detailed deployment guide
└── README.md            # This file
```

## 🚀 Quick Start (Local Development)

### Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python create_superusers.py
python manage.py runserver 8000
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

## 🔐 Login Ma'lumotlari

### Django Admin
- URL: http://localhost:8000/admin/
- Username: `admin`
- Password: `123`

### Application (Farg'ona Shahar)
- URL: http://localhost:3000
- Username: `fergan`
- Password: `123`

## 🛠️ Tech Stack

### Backend
- Django 4.2.7
- Django REST Framework
- SQLite (dev) / PostgreSQL (prod)
- Python 3.8+

### Frontend
- React 18
- TypeScript
- Vite
- Tailwind CSS
- Framer Motion
- Lucide React Icons

## 📡 API Endpoints

Base URL: `https://ferganaapi.cdcgroup.uz/api`

### Authentication
- `POST /api/auth/login/` - Login
- `GET /api/auth/validate/` - Validate token

### Resources
- `/api/organizations/` - Organizations
- `/api/waste-bins/` - Waste bins
- `/api/trucks/` - Vehicles
- `/api/facilities/` - Buildings (schools/kindergartens)
- `/api/rooms/` - Rooms
- `/api/boilers/` - Boilers
- `/api/iot-devices/` - IoT devices
- `/api/call-requests/` - Citizen requests

## 📦 Modules

### ✅ Active Modules - Core
1. **Markaz** - Main dashboard
2. **Chiqindi** - Waste management
3. **Issiqlik** - Climate control (schools/kindergartens)

### 🆕 NEW Enhanced Modules (v2.0)

#### Chiqindi (Waste Management) 🗑️
1. **Hisobotlar** - Statistics and reports with Excel export
2. **Vazifalar** - Auto task assignment system
3. **Marshrutlar** - Route optimization (fuel saving)
4. **Prognoz** - AI-based fill prediction
5. **Ogohlantirishlar** - SMS/Email/Telegram alerts

#### Issiqlik (Climate Control) 🌡️
1. **Real-Time** - Live 24h temperature/humidity graphs
2. **Jadval** - Automated on/off scheduling
3. **Avto-Nazorat** - Smart auto-control system
4. **Energiya** - Energy analysis and savings recommendations
5. **Hisobotlar** - Monthly/Yearly energy reports

### 🔒 Locked Modules (Coming Soon)
- Namlik (Moisture)
- Havo (Air quality)
- Xavfsizlik (Security)
- Eco-Nazorat (Eco monitoring)
- Qurilish (Construction)
- Light-AI (Smart lighting)
- Transport
- Murojaatlar (Call center)
- Tahlil (Analytics)

## 🚀 Production Deployment

See [DEPLOY_GUIDE.md](./DEPLOY_GUIDE.md) for detailed instructions.

### Quick Deploy

1. SSH into server:
```bash
ssh root@167.71.53.238
```

2. Run deploy script:
```bash
cd /var/www/smartcity-backend
./deploy.sh
```

## 🔧 Environment Variables

### Backend (.env)
```env
DEBUG=False
SECRET_KEY=your-secret-key
ALLOWED_HOSTS=ferganaapi.cdcgroup.uz,167.71.53.238
```

### Frontend (.env)
```env
VITE_API_BASE_URL=https://ferganaapi.cdcgroup.uz/api
GEMINI_API_KEY=your-gemini-api-key
```

## 📝 Recent Changes

### Version 2.0 - Enhanced Edition (2026-01-13) 🆕

**NEW FEATURES:**
1. ✅ **Chiqindi Moduli:**
   - Hisobotlar va statistika (Excel export)
   - Avtomatik vazifa tayinlash
   - Marshrut optimizatsiyasi
   - AI prognoz (7-30 kun)
   - Push bildirishnomalar

2. ✅ **Issiqlik Moduli:**
   - Real-time 24 soatlik grafik
   - Ish vaqti jadval (avtomatik yoqish/o'chirish)
   - Avtomatik boshqaruv tizimi
   - Energiya tahlili va tejash tavsiyalari
   - Oylik/Yillik hisobotlar
   - SMS/Telegram ogohlantirishlar

**BUG FIXES:**
1. ✅ Takroriy konteynerlar muammosi hal qilindi
2. ✅ Issiqlik sozlamalari endi saqlanadi (localStorage)
3. ✅ Ogohlantirish mantigi tuzatildi (harorat/namlik)

**NEW BACKEND MODELS:**
- WasteTask, RouteOptimization, AlertNotification
- ClimateSchedule, EnergyReport, WastePrediction
- MaintenanceSchedule, DriverPerformance

**NEW COMPONENTS:**
11 ta yangi React komponent qo'shildi

**Files Modified:**
- `backend/smartcity_app/models.py` (+250 lines)
- `backend/smartcity_app/serializers.py` (+100 lines)
- `backend/smartcity_app/views.py` (+200 lines)
- `backend/smartcity_app/urls.py` (+15 endpoints)
- `frontend/types.ts` (+200 lines)
- `frontend/services/api.ts` (+50 lines)
- `frontend/constants.ts` (+10 modules)
- `frontend/App.tsx` (enhanced routing)
- 11 new component files

**Documentation:**
- `ENHANCED_FEATURES.md` - Full feature documentation
- `SETUP_ENHANCED.md` - Quick setup guide

### Previous Updates ✅
1. ✅ Updated API URLs from `smartcityapi.aiproduct.uz` to `ferganaapi.cdcgroup.uz`
2. ✅ Added production domains to CORS settings
3. ✅ Added production domains to CSRF trusted origins
4. ✅ Added production domains to ALLOWED_HOSTS
5. ✅ Enabled HTTPS cookies for production
6. ✅ Updated security settings

## 🐛 Troubleshooting

### Check service status
```bash
sudo systemctl status gunicorn
sudo systemctl status nginx
```

### View logs
```bash
# Nginx
sudo tail -f /var/log/nginx/error.log

# Gunicorn
sudo journalctl -u gunicorn -f

# Django
tail -f /var/www/smartcity-backend/django.log
```

### Restart services
```bash
sudo systemctl restart gunicorn
sudo systemctl restart nginx
```

## 👥 User Roles

- **ADMIN** - Full access (fergan/123)
- **DRIVER** - Driver dashboard

## 🤖 Telegram Bot

Bot token: `8380253670:AAGdoT2SRVpmHHu47s_ZHF_3l9fuURA-Uo4`

Commands:
- `/start` - Start bot
- `/scan` - QR code scanner
- `/help` - Help

## 📞 Support

For issues or questions, please contact the development team.

## 📄 License

© 2025 Smart City - CDCGroup  
Powered by CraDev

---

**Developer:** CDCGroup  
**Last Updated:** January 13, 2026
