# 🤖 Bot Deployment va Tekshirish Qo'llanmasi

## 📋 Serverda Bot'ni Tekshirish va Ishga Tushirish

### 1. Bot Process'ni Tekshirish

```bash
# Bot ishlayaptimi?
ps aux | grep iot_monitor

# Yoki
pgrep -f iot_monitor.py
```

### 2. Bot Faylini Tekshirish

```bash
# Bot fayli mavjudligini tekshirish
ls -la /var/www/smartcity-frontend/iot_monitor.py

# API URL'ni tekshirish
grep "API_BASE_URL" /var/www/smartcity-frontend/iot_monitor.py
# Kutilayotgan: API_BASE_URL = "https://ferganaapi.cdcgroup.uz/api"
```

### 3. Bot Token'ni Tekshirish

```bash
# Bot token'ni tekshirish
grep "MONITOR_BOT_TOKEN" /var/www/smartcity-frontend/iot_monitor.py
```

### 4. Bot'ni Ishga Tushirish

```bash
cd /var/www/smartcity-frontend

# Eski process'larni o'chirish
pkill -f iot_monitor.py

# Python packages tekshirish
python3 -c "import telegram" || pip3 install python-telegram-bot requests

# Bot'ni ishga tushirish
nohup python3 iot_monitor.py > bot.log 2>&1 &

# Tekshirish
sleep 3
pgrep -f iot_monitor.py
```

### 5. Bot Log'larni Tekshirish

```bash
# Bot log'larini ko'rish
tail -f /var/www/smartcity-frontend/bot.log

# Yoki
tail -20 /var/www/smartcity-frontend/bot.log
```

---

## 🔍 API Endpoint Tekshirish

### 1. IoT Endpoint Test

```bash
# API endpoint'ni test qilish
curl -X POST https://ferganaapi.cdcgroup.uz/api/iot-devices/data/update/ \
  -H "Content-Type: application/json" \
  -d '{
    "device_id": "ESP-A4C416",
    "temperature": 22.5,
    "humidity": 45.0
  }'
```

**Kutilayotgan natija:**
```json
{
  "message": "Sensor data updated successfully",
  "device_id": "ESP-A4C416",
  "temperature": 22.5,
  "humidity": 45.0
}
```

### 2. Device Mavjudligini Tekshirish

```bash
# Backend'da device'lar ro'yxatini ko'rish
cd /var/www/smartcity-backend
source venv/bin/activate
python3 manage.py shell
```

```python
from smartcity_app.models import IoTDevice
devices = IoTDevice.objects.all()
for device in devices:
    print(f"Device ID: {device.device_id}, Type: {device.device_type}")
```

---

## 🐛 Muammo Bo'lsa

### Bot Ishlamasa

```bash
# Bot log'larni tekshirish
tail -50 /var/www/smartcity-frontend/bot.log

# Bot process'ni qayta ishga tushirish
pkill -f iot_monitor.py
cd /var/www/smartcity-frontend
nohup python3 iot_monitor.py > bot.log 2>&1 &
```

### Bot Conflict Xatosi

```bash
# Barcha bot process'larni o'chirish
pkill -9 -f iot_monitor.py
pkill -9 -f bot.py

# Keyin qayta ishga tushirish
cd /var/www/smartcity-frontend
nohup python3 iot_monitor.py > bot.log 2>&1 &
```

### API Xatosi

```bash
# API endpoint'ni test qilish
curl -v https://ferganaapi.cdcgroup.uz/api/iot-devices/data/update/ \
  -H "Content-Type: application/json" \
  -d '{"device_id": "TEST", "temperature": 25.0}'

# Backend log'larni tekshirish
tail -f /var/www/smartcity-backend/gunicorn-error.log
```

---

## 📝 Systemd Service Yaratish (Ixtiyoriy)

Agar bot'ni service sifatida ishga tushirmoqchi bo'lsangiz:

```bash
sudo nano /etc/systemd/system/iot-monitor-bot.service
```

Quyidagi kontentni yozing:
```ini
[Unit]
Description=IoT Monitor Bot for Smart City
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/www/smartcity-frontend
ExecStart=/usr/bin/python3 /var/www/smartcity-frontend/iot_monitor.py
Restart=on-failure
RestartSec=10s
StandardOutput=append:/var/www/smartcity-frontend/bot.log
StandardError=append:/var/www/smartcity-frontend/bot-error.log

[Install]
WantedBy=multi-user.target
```

Keyin:
```bash
sudo systemctl daemon-reload
sudo systemctl enable iot-monitor-bot
sudo systemctl start iot-monitor-bot
sudo systemctl status iot-monitor-bot
```

---

**Oxirgi Yangilanish**: 2026-yil 25-yanvar
