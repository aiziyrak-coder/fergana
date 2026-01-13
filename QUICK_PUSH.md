# 🚀 Tez Push Qilish Yo'riqnomasi

## ⚡ 3 Daqiqada GitHub'ga Push!

### Usul 1: Batch Script (Eng Oson) ⭐

1. **`push-to-github.bat` faylini ikki marta bosing**
2. GitHub username va token so'raladi
3. Token yaratish: https://github.com/settings/tokens
   - "Generate new token (classic)" bosing
   - `repo` ni belgilang
   - Token'ni ko'chiring
4. Username: `backend-developer-hojiakbar`
5. Password: `token_ni_shu_yerga_qo'ying`

---

### Usul 2: Manual (Terminal)

```bash
# 1. Backend push
cd E:\Smartcity\backend
git push origin master
# Username va token so'raladi

# 2. Frontend push
cd E:\Smartcity\frontend
git push origin master
# Username va token so'raladi
```

---

### Usul 3: Token bilan URL (Bir marotaba)

**GitHub Token Yarating:**
https://github.com/settings/tokens → Generate new token (classic) → `repo` ✓

**Backend:**
```bash
cd E:\Smartcity\backend
git remote set-url origin https://YOUR_TOKEN@github.com/backend-developer-hojiakbar/smartApiFull.git
git push origin master
```

**Frontend:**
```bash
cd E:\Smartcity\frontend
git remote set-url origin https://YOUR_TOKEN@github.com/backend-developer-hojiakbar/smartFrontFull.git
git push origin master
```

**`YOUR_TOKEN` o'rniga tokeningizni qo'ying!**

---

## ✅ Muvaffaqiyatli Push

Quyidagi ko'rinishda bo'ladi:

```
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), done.
To https://github.com/backend-developer-hojiakbar/smartApiFull.git
   5fbb61e..abc1234  master -> master
```

---

## 🔍 Tekshirish

- Backend: https://github.com/backend-developer-hojiakbar/smartApiFull
- Frontend: https://github.com/backend-developer-hojiakbar/smartFrontFull

---

## 🚀 Push Qilgandan Keyin

Server'ga deploy:
```bash
ssh root@167.71.53.238
cd /var/www/smartcity-backend
python3 backup_database.py
./deploy.sh
```

Batafsil: `DEPLOY_TO_SERVER.md`

---

**Eng oson:** `push-to-github.bat` ni ishga tushiring! 🎯
