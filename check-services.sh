#!/bin/bash

# Service Health Check Script

echo "🔍 Smart City - Service Health Check"
echo "===================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root or with sudo${NC}"
    exit 1
fi

# Function to check service status
check_service() {
    local service=$1
    if systemctl is-active --quiet $service; then
        echo -e "${GREEN}✅ $service is running${NC}"
        return 0
    else
        echo -e "${RED}❌ $service is not running${NC}"
        return 1
    fi
}

# Function to check port
check_port() {
    local port=$1
    local name=$2
    if netstat -tuln | grep -q ":$port "; then
        echo -e "${GREEN}✅ Port $port ($name) is listening${NC}"
        return 0
    else
        echo -e "${RED}❌ Port $port ($name) is not listening${NC}"
        return 1
    fi
}

# Function to check URL
check_url() {
    local url=$1
    local name=$2
    local status=$(curl -s -o /dev/null -w "%{http_code}" $url)
    if [ $status -eq 200 ] || [ $status -eq 301 ] || [ $status -eq 302 ]; then
        echo -e "${GREEN}✅ $name is accessible (HTTP $status)${NC}"
        return 0
    else
        echo -e "${RED}❌ $name is not accessible (HTTP $status)${NC}"
        return 1
    fi
}

# Check Services
echo -e "${BLUE}📊 System Services:${NC}"
echo "-------------------"
check_service nginx
check_service gunicorn
echo ""

# Check Ports
echo -e "${BLUE}🔌 Port Status:${NC}"
echo "---------------"
check_port 80 "HTTP"
check_port 443 "HTTPS"
check_port 8000 "Gunicorn"
echo ""

# Check URLs
echo -e "${BLUE}🌐 URL Status:${NC}"
echo "-------------"
check_url "https://fergana.cdcgroup.uz" "Frontend"
check_url "https://ferganaapi.cdcgroup.uz/admin/" "Backend Admin"
check_url "https://ferganaapi.cdcgroup.uz/api/" "Backend API"
echo ""

# Disk Space
echo -e "${BLUE}💾 Disk Space:${NC}"
echo "-------------"
df -h / | tail -1 | awk '{print "Used: " $3 " / " $2 " (" $5 ")"}'
echo ""

# Memory Usage
echo -e "${BLUE}🧠 Memory Usage:${NC}"
echo "---------------"
free -h | grep Mem | awk '{print "Used: " $3 " / " $2}'
echo ""

# CPU Load
echo -e "${BLUE}⚡ CPU Load:${NC}"
echo "-----------"
uptime | awk -F'load average:' '{print "Load Average:" $2}'
echo ""

# Process Count
echo -e "${BLUE}🔢 Process Count:${NC}"
echo "----------------"
echo "Gunicorn workers: $(ps aux | grep gunicorn | grep -v grep | wc -l)"
echo "Nginx workers: $(ps aux | grep nginx | grep -v grep | wc -l)"
echo ""

# Recent Errors (last 10)
echo -e "${BLUE}🐛 Recent Errors:${NC}"
echo "----------------"
echo -e "${YELLOW}Nginx errors (last 5):${NC}"
tail -5 /var/log/nginx/error.log 2>/dev/null || echo "No errors found"
echo ""
echo -e "${YELLOW}Gunicorn errors (last 5):${NC}"
journalctl -u gunicorn --no-pager | grep -i error | tail -5 || echo "No errors found"
echo ""

# SSL Certificate Status
echo -e "${BLUE}🔒 SSL Certificate Status:${NC}"
echo "-------------------------"
certbot certificates 2>/dev/null | grep -A2 "Certificate Name" || echo "SSL not configured"
echo ""

echo "===================================="
echo -e "${GREEN}✅ Health check completed!${NC}"
