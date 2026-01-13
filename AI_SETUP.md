# 🤖 AI Service Setup (Gemini)

## ⚠️ Muammo
Chiqindi qutisi rasmini tahlil qilish ishlamayapti - API key yo'q.

---

## 🔑 Gemini API Key Olish

### 1. Google AI Studio'ga Kiring
https://aistudio.google.com/apikey

### 2. API Key Yarating
- "Create API Key" tugmasini bosing
- Existing project tanlang yoki yangi yarating
- Key'ni ko'chiring (masalan: `AIzaSyAbc123...`)

---

## 📝 Server'da Environment Variable O'rnatish

### Backend (agar kerak bo'lsa)
```bash
ssh root@167.71.53.238

# .env faylini yaratish yoki yangilash
nano /var/www/smartcity-backend/.env
```

**.env fayl:**
```env
GEMINI_API_KEY=AIzaSyAbc123YourActualKeyHere
```

### Frontend Build Vaqtida

**Local'da (E:\Smartcity\frontend):**

1. `.env` faylini yarating:
```bash
# E:\Smartcity\frontend\.env
GEMINI_API_KEY=AIzaSyAbc123YourActualKeyHere
VITE_GEMINI_API_KEY=AIzaSyAbc123YourActualKeyHere
```

2. Build qiling:
```bash
npm run build
```

3. Server'ga deploy:
```bash
ssh root@167.71.53.238
cd /var/www/smartcity-frontend
git pull origin master
npm run build
sudo cp -r dist/* /var/www/html/smartcity/
```

---

## 🚀 Tezkor Deploy (API Key bilan)

### 1. Local'da .env yaratish
```bash
# E:\Smartcity\frontend dizayniga
cd E:\Smartcity\frontend

# .env faylini yaratish (Notepad yoki nano bilan)
echo "GEMINI_API_KEY=YOUR_API_KEY_HERE" > .env
echo "VITE_GEMINI_API_KEY=YOUR_API_KEY_HERE" >> .env
```

### 2. Build va GitHub
```bash
npm run build
git add .
git commit -m "Update: Gemini API with better error handling"
git push origin master
```

### 3. Server'da Deploy
```bash
ssh root@167.71.53.238

# .env yaratish (server'da)
cd /var/www/smartcity-frontend
nano .env
```

**.env (server'da):**
```
GEMINI_API_KEY=AIzaSyAbc123YourActualKeyHere
VITE_GEMINI_API_KEY=AIzaSyAbc123YourActualKeyHere
```

```bash
# Build va deploy
npm run build
sudo cp -r dist/* /var/www/html/smartcity/
```

---

## ✅ Test Qilish

### Browser'da:
1. Chiqindi moduliga o'ting
2. Chiqindi qutisini tanlang
3. "📸 Rasmga Olish" yoki kamera buttonini bosing
4. Rasm yuklang
5. AI tahlil qilishi kerak (30 sekund)

### Console'da (F12):
```
🤖 AI tahlil boshlandi...
✅ AI natija: { isFull: true, fillLevel: 85, confidence: 90, notes: "..." }
```

Agar API key xato bo'lsa:
```
⚠️ AI service ishlamayapti: API key topilmadi
```

---

## 🔧 AI Model O'zgarishlari

**Eski:**
- Model: `gemini-3-flash-preview` ❌

**Yangi:**
- Model: `gemini-2.0-flash-exp` ✅

**Features:**
- ✅ Vision (rasm tahlil)
- ✅ JSON response
- ✅ Structured output
- ✅ O'zbek tilida natija

---

## 📊 AI Tahlil Natijalari

### Natija formati:
```json
{
  "isFull": true,
  "fillLevel": 85,
  "confidence": 90,
  "notes": "Chiqindi konteyneri 85% to'lgan. Axlat konteyner ichida to'planib qolgan..."
}
```

### isFull Logic:
- `fillLevel >= 75%` → `isFull = true` (To'lgan)
- `fillLevel < 75%` → `isFull = false` (Joy bor)

---

## 🐛 Troubleshooting

### AI javob bermasa:
1. API key to'g'ri kiritilganmi?
2. Internet connection bormi?
3. Gemini quota tugamadimi?
4. Console'da xato bormi?

### API Key Test:
```bash
# Test qilish
curl -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"test"}]}]}' \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=YOUR_API_KEY"
```

---

## 💡 Maslahat

1. **API Key xavfsiz saqlang** - Git'ga commit qilmang
2. **Rate limit** - Gemini free plan: 15 request/minute
3. **Quota** - Agar tugasa, yangi key oling
4. **Backup** - Agar AI ishlamasa, manual input qilish mumkin

---

**Hozir: Gemini API key oling va .env'ga qo'ying!**
https://aistudio.google.com/apikey
