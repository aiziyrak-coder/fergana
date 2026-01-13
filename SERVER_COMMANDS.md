# 🖥️ Server Commands Cheat Sheet

Server'da tez-tez ishlatiladigan buyruqlar ro'yxati.

---

## 🔐 SSH Ulanish

```bash
ssh root@167.71.53.238
```

---

## 🚀 Deploy Commands

### Tez Deploy (avtomatik)
```bash
cd /var/www/smartcity-backend
./deploy.sh
```

### Manual Deploy

#### Backend
```bash
cd /var/www/smartcity-backend
git pull origin master
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
sudo systemctl restart gunicorn
```

#### Frontend
```bash
cd /var/www/smartcity-frontend
git pull origin master
npm install
npm run build
sudo rm -rf /var/www/html/smartcity/*
sudo cp -r dist/* /var/www/html/smartcity/
sudo systemctl restart nginx
```

---

## 🔧 Service Management

### Status tekshirish
```bash
sudo systemctl status nginx
sudo systemctl status gunicorn
```

### Restart
```bash
sudo systemctl restart nginx
sudo systemctl restart gunicorn
```

### Stop/Start
```bash
sudo systemctl stop gunicorn
sudo systemctl start gunicorn
sudo systemctl stop nginx
sudo systemctl start nginx
```

### Enable/Disable (autostart)
```bash
sudo systemctl enable gunicorn
sudo systemctl disable gunicorn
```

---

## 📋 Log Ko'rish

### Real-time logs
```bash
# Nginx error log
sudo tail -f /var/log/nginx/error.log

# Nginx access log
sudo tail -f /var/log/nginx/access.log

# Gunicorn log
sudo journalctl -u gunicorn -f

# Django log
tail -f /var/www/smartcity-backend/django.log
```

### Oxirgi 100 qator
```bash
sudo tail -100 /var/log/nginx/error.log
sudo journalctl -u gunicorn -n 100
```

### Error qidirish
```bash
sudo grep -i error /var/log/nginx/error.log | tail -20
sudo journalctl -u gunicorn | grep -i error | tail -20
```

---

## 🔍 Diagnostics

### Port tekshirish
```bash
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443
sudo netstat -tulpn | grep :8000
```

### Process tekshirish
```bash
ps aux | grep gunicorn
ps aux | grep nginx
```

### Disk space
```bash
df -h
du -sh /var/www/*
```

### Memory usage
```bash
free -h
```

### CPU load
```bash
top
htop  # agar o'rnatilgan bo'lsa
uptime
```

---

## 🗄️ Database

### Backup
```bash
cd /var/www/smartcity-backend
cp db.sqlite3 db.sqlite3.backup.$(date +%Y%m%d_%H%M%S)
```

### Migrations
```bash
cd /var/www/smartcity-backend
source venv/bin/activate
python manage.py makemigrations
python manage.py migrate
```

### Django shell
```bash
cd /var/www/smartcity-backend
source venv/bin/activate
python manage.py shell
```

### Superuser yaratish
```bash
cd /var/www/smartcity-backend
source venv/bin/activate
python manage.py createsuperuser
```

---

## 🔐 SSL/HTTPS

### Sertifikat olish
```bash
sudo certbot --nginx -d fergana.cdcgroup.uz
sudo certbot --nginx -d ferganaapi.cdcgroup.uz
```

### Sertifikat yangilash
```bash
sudo certbot renew
```

### Sertifikat holati
```bash
sudo certbot certificates
```

---

## 📦 Nginx

### Test configuration
```bash
sudo nginx -t
```

### Reload configuration
```bash
sudo nginx -s reload
```

### View configuration
```bash
cat /etc/nginx/sites-available/fergana.cdcgroup.uz
cat /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
```

### Edit configuration
```bash
sudo nano /etc/nginx/sites-available/fergana.cdcgroup.uz
sudo nano /etc/nginx/sites-available/ferganaapi.cdcgroup.uz
```

---

## 🐍 Python/Django

### Requirements o'rnatish
```bash
cd /var/www/smartcity-backend
source venv/bin/activate
pip install -r requirements.txt
```

### Django commands
```bash
cd /var/www/smartcity-backend
source venv/bin/activate

# Check version
python manage.py --version

# Run tests
python manage.py test

# Create migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic

# Clear cache
python manage.py clear_cache  # if installed
```

---

## 📱 Node.js/NPM

### Dependencies o'rnatish
```bash
cd /var/www/smartcity-frontend
npm install
```

### Build
```bash
cd /var/www/smartcity-frontend
npm run build
```

### Clear cache
```bash
cd /var/www/smartcity-frontend
rm -rf node_modules package-lock.json
npm install
```

---

## 🔄 Git

### Pull latest changes
```bash
cd /var/www/smartcity-backend
git pull origin master

cd /var/www/smartcity-frontend
git pull origin master
```

### Check status
```bash
git status
git log --oneline -5
```

### Reset to remote
```bash
git fetch origin
git reset --hard origin/master
```

---

## 💾 Backup

### Manual backup
```bash
cd /var/www/smartcity-backend
./backup.sh
```

### Create tar archive
```bash
tar -czf backup_$(date +%Y%m%d).tar.gz /var/www/smartcity-backend
```

---

## 🔧 Permissions

### Fix permissions
```bash
sudo chown -R root:www-data /var/www/smartcity-backend
sudo chmod -R 755 /var/www/smartcity-backend
```

### Media/Static permissions
```bash
sudo chown -R www-data:www-data /var/www/smartcity-backend/media
sudo chown -R www-data:www-data /var/www/smartcity-backend/static
```

---

## 🛠️ Helper Scripts

### Health check
```bash
cd /var/www/smartcity-backend
./check-services.sh
```

### View logs
```bash
cd /var/www/smartcity-backend
./logs.sh
```

### Backup
```bash
cd /var/www/smartcity-backend
./backup.sh
```

---

## 🐛 Troubleshooting

### Service qaytatishda xato
```bash
# Check logs
sudo journalctl -xe

# Check syntax
sudo nginx -t
python manage.py check
```

### Permission denied
```bash
sudo chown -R root:www-data /var/www/smartcity-backend
sudo chmod +x deploy.sh
```

### Can't connect to database
```bash
# Check if file exists
ls -la /var/www/smartcity-backend/db.sqlite3

# Check permissions
sudo chmod 664 /var/www/smartcity-backend/db.sqlite3
```

### Static files not loading
```bash
cd /var/www/smartcity-backend
python manage.py collectstatic --noinput
sudo systemctl restart gunicorn nginx
```

---

## 📞 Emergency

### Rollback to previous version
```bash
cd /var/www/smartcity-backend
git log --oneline -5
git reset --hard <commit-hash>
sudo systemctl restart gunicorn
```

### Restore database backup
```bash
cd /var/www/smartcity-backend
cp db.sqlite3.backup.YYYYMMDD_HHMMSS db.sqlite3
sudo systemctl restart gunicorn
```

---

**Maslahat:** Bu buyruqlarni `~/commands.txt` faylga saqlab qo'ying yoki alias yarating!

```bash
alias cdback='cd /var/www/smartcity-backend'
alias cdfront='cd /var/www/smartcity-frontend'
alias logs='tail -f /var/log/nginx/error.log'
alias restart='sudo systemctl restart gunicorn nginx'
```
