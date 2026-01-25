# 🧹 Takrorlanuvchi Waste Bin'larni Tozalash

## 📋 Muammo

Database'da 44 ta waste bin bor, lekin aslida 18 ta bo'lishi kerak.

---

## 🔧 Yechim

Django management command yaratildi: `clean_duplicate_bins.py`

---

## 📝 Serverda Ishlatish

### 1️⃣ Avval Ko'rish (Dry Run)

```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Faqat ko'rsatadi, o'chirmaydi
python manage.py clean_duplicate_bins --dry-run --keep-latest 18
```

Bu buyruq:
- Barcha waste bin'larni ko'rsatadi
- Qaysilar o'chirilishi kerakligini ko'rsatadi
- Hech narsa o'chirmaydi

---

### 2️⃣ Tozalash (Haqiqiy O'chirish)

```bash
# Haqiqiy o'chirish
python manage.py clean_duplicate_bins --keep-latest 18
```

Bu buyruq:
- Eng so'nggi 18 ta bin'ni saqlaydi
- Qolganlarini o'chiradi
- Tasdiqlash so'raydi

---

### 3️⃣ Address Bo'yicha Takrorlanuvchilarni Topish

```bash
# Address bo'yicha takrorlanuvchilar
python manage.py clean_duplicate_bins --dry-run --by-address
```

---

## ⚙️ Parametrlar

- `--dry-run`: Faqat ko'rsatadi, o'chirmaydi
- `--keep-latest N`: Eng so'nggi N ta bin'ni saqlash (default: 18)
- `--by-address`: Address bo'yicha takrorlanuvchilarni topish

---

## 📊 Misol

```bash
# 1. Avval ko'rish
python manage.py clean_duplicate_bins --dry-run --keep-latest 18

# 2. Agar hammasi to'g'ri bo'lsa, o'chirish
python manage.py clean_duplicate_bins --keep-latest 18

# 3. Address bo'yicha takrorlanuvchilar
python manage.py clean_duplicate_bins --dry-run --by-address --keep-latest 18
```

---

## ⚠️ Eslatmalar

1. **Backup oling!** O'chirishdan oldin database backup qiling:
   ```bash
   cd /var/www/smartcity-backend
   TIMESTAMP=$(date +%Y%m%d_%H%M%S)
   cp db.sqlite3 "backups/db_backup_before_clean_${TIMESTAMP}.sqlite3"
   ```

2. **Dry run bilan boshlang!** Avval `--dry-run` bilan ko'ring

3. **Tasdiqlash:** O'chirishdan oldin tasdiqlash so'raladi

---

## ✅ Keyin Tekshirish

```bash
# Bin'lar sonini tekshirish
python manage.py shell
>>> from smartcity_app.models import WasteBin, Organization
>>> fergana = Organization.objects.get(name='Fergana')
>>> WasteBin.objects.filter(organization=fergana).count()
18
```

---

## 🔙 Qaytarish (Agar Xatolik Bo'lsa)

```bash
cd /var/www/smartcity-backend
LATEST_BACKUP=$(ls -t backups/db_backup_before_clean_*.sqlite3 | head -1)
cp "$LATEST_BACKUP" db.sqlite3
```

---

© 2026 Smart City - CDCGroup
