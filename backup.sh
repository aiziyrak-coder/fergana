#!/bin/bash

# Backup Script for Smart City

echo "💾 Smart City - Backup Script"
echo "============================="

# Configuration
BACKUP_DIR="/var/backups/smartcity"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKEND_DIR="/var/www/smartcity-backend"
FRONTEND_DIR="/var/www/smartcity-frontend"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create backup directory
mkdir -p $BACKUP_DIR

echo -e "${BLUE}📦 Creating backup...${NC}"
echo "Timestamp: $TIMESTAMP"
echo ""

# Backup Database
echo "📊 Backing up database..."
cp $BACKEND_DIR/db.sqlite3 $BACKUP_DIR/db_$TIMESTAMP.sqlite3

# Backup Media Files
echo "📸 Backing up media files..."
tar -czf $BACKUP_DIR/media_$TIMESTAMP.tar.gz -C $BACKEND_DIR media/

# Backup Environment Files
echo "⚙️ Backing up configuration..."
if [ -f "$BACKEND_DIR/.env" ]; then
    cp $BACKEND_DIR/.env $BACKUP_DIR/env_$TIMESTAMP
fi

# Backup Nginx Configs
echo "🔧 Backing up nginx configs..."
cp /etc/nginx/sites-available/fergana.cdcgroup.uz $BACKUP_DIR/nginx_frontend_$TIMESTAMP.conf
cp /etc/nginx/sites-available/ferganaapi.cdcgroup.uz $BACKUP_DIR/nginx_backend_$TIMESTAMP.conf

# Create backup info file
cat > $BACKUP_DIR/backup_info_$TIMESTAMP.txt <<EOF
Smart City Backup
=================
Date: $(date)
Database: db_$TIMESTAMP.sqlite3
Media: media_$TIMESTAMP.tar.gz
Configs: nginx_*_$TIMESTAMP.conf

Restore Instructions:
1. Stop services: sudo systemctl stop gunicorn nginx
2. Restore database: cp db_$TIMESTAMP.sqlite3 $BACKEND_DIR/db.sqlite3
3. Restore media: tar -xzf media_$TIMESTAMP.tar.gz -C $BACKEND_DIR
4. Restart services: sudo systemctl start gunicorn nginx
EOF

# List backup files
echo ""
echo -e "${GREEN}✅ Backup completed!${NC}"
echo ""
echo "Backup location: $BACKUP_DIR"
echo "Files created:"
ls -lh $BACKUP_DIR/*$TIMESTAMP* | awk '{print "  - " $9 " (" $5 ")"}'

# Cleanup old backups (keep last 7 days)
echo ""
echo "🗑️ Cleaning up old backups (keeping last 7 days)..."
find $BACKUP_DIR -type f -mtime +7 -delete
echo "Done!"

# Calculate total backup size
TOTAL_SIZE=$(du -sh $BACKUP_DIR | awk '{print $1}')
echo ""
echo "Total backup size: $TOTAL_SIZE"
