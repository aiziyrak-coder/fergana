#!/bin/bash

# Log Viewer Script

echo "📋 Smart City - Log Viewer"
echo "=========================="
echo ""
echo "Choose log to view:"
echo "1) Nginx Error Log"
echo "2) Nginx Access Log"
echo "3) Gunicorn Log"
echo "4) Django Log"
echo "5) All Logs (tail -f)"
echo "6) Exit"
echo ""
read -p "Enter choice [1-6]: " choice

case $choice in
    1)
        echo "📄 Viewing Nginx Error Log (Ctrl+C to exit):"
        echo "============================================"
        sudo tail -f /var/log/nginx/error.log
        ;;
    2)
        echo "📄 Viewing Nginx Access Log (Ctrl+C to exit):"
        echo "============================================"
        sudo tail -f /var/log/nginx/access.log
        ;;
    3)
        echo "📄 Viewing Gunicorn Log (Ctrl+C to exit):"
        echo "=========================================="
        sudo journalctl -u gunicorn -f
        ;;
    4)
        echo "📄 Viewing Django Log (Ctrl+C to exit):"
        echo "========================================"
        tail -f /var/www/smartcity-backend/django.log
        ;;
    5)
        echo "📄 Viewing All Logs (Ctrl+C to exit):"
        echo "======================================"
        sudo tail -f /var/log/nginx/error.log /var/log/nginx/access.log /var/www/smartcity-backend/django.log
        ;;
    6)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac
