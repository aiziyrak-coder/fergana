#!/bin/bash
# Check and Start IoT Bot - Serverda bot ishlayaptimi tekshirish va ishga tushirish

echo "=========================================="
echo "🤖 CHECKING AND STARTING IOT BOT"
echo "=========================================="

# ============================================
# 1️⃣ BOT PROCESS'NI TEKSHIRISH
# ============================================
echo ""
echo "1️⃣ Checking if bot is running..."

# Check for iot_monitor.py process
BOT_PID=$(pgrep -f "iot_monitor.py" || echo "")

if [ ! -z "$BOT_PID" ]; then
    echo "✅ Bot is running (PID: $BOT_PID)"
    echo "   Process details:"
    ps aux | grep "iot_monitor.py" | grep -v grep
else
    echo "⚠️ Bot is NOT running"
fi

# ============================================
# 2️⃣ BOT FAYLINI TEKSHIRISH
# ============================================
echo ""
echo "2️⃣ Checking bot files..."

BOT_FILE="/var/www/smartcity-frontend/iot_monitor.py"

if [ -f "$BOT_FILE" ]; then
    echo "✅ Bot file found: $BOT_FILE"
    
    # Check API URL in bot file
    API_URL=$(grep "API_BASE_URL" "$BOT_FILE" | head -1 | grep -oP 'https?://[^"]+' || echo "")
    if [ ! -z "$API_URL" ]; then
        echo "   API URL: $API_URL"
        if [[ "$API_URL" == *"ferganaapi.cdcgroup.uz"* ]]; then
            echo "   ✅ API URL is correct"
        else
            echo "   ⚠️ API URL might be wrong: $API_URL"
        fi
    fi
else
    echo "❌ Bot file not found: $BOT_FILE"
    echo "   Looking for bot files..."
    find /var/www -name "iot_monitor.py" 2>/dev/null | head -5
fi

# ============================================
# 3️⃣ BOT TOKEN'NI TEKSHIRISH
# ============================================
echo ""
echo "3️⃣ Checking bot token..."

if [ -f "$BOT_FILE" ]; then
    BOT_TOKEN=$(grep "MONITOR_BOT_TOKEN" "$BOT_FILE" | head -1 | grep -oP '"[^"]+"' | tr -d '"' || echo "")
    if [ ! -z "$BOT_TOKEN" ]; then
        echo "   Bot token found: ${BOT_TOKEN:0:10}..."
        echo "   ✅ Bot token is configured"
    else
        echo "   ⚠️ Bot token not found in file"
    fi
fi

# ============================================
# 4️⃣ BOT'NI ISHGA TUSHIRISH (Agar ishlamasa)
# ============================================
echo ""
if [ -z "$BOT_PID" ]; then
    echo "4️⃣ Starting bot..."
    
    if [ ! -f "$BOT_FILE" ]; then
        echo "❌ Bot file not found, cannot start"
        exit 1
    fi
    
    # Check if Python is available
    if ! command -v python3 &> /dev/null; then
        echo "❌ Python3 not found"
        exit 1
    fi
    
    # Check if required packages are installed
    echo "   Checking Python packages..."
    python3 -c "import telegram" 2>/dev/null || {
        echo "   ⚠️ python-telegram-bot not installed"
        echo "   Installing..."
        pip3 install python-telegram-bot requests
    }
    
    # Start bot in background
    cd /var/www/smartcity-frontend
    echo "   Starting bot in background..."
    
    # Kill any existing bot processes first
    pkill -f "iot_monitor.py" 2>/dev/null || true
    sleep 1
    
    # Start bot with nohup
    nohup python3 iot_monitor.py > /var/www/smartcity-frontend/bot.log 2>&1 &
    
    sleep 3
    
    # Check if bot started
    NEW_BOT_PID=$(pgrep -f "iot_monitor.py" || echo "")
    if [ ! -z "$NEW_BOT_PID" ]; then
        echo "   ✅ Bot started successfully (PID: $NEW_BOT_PID)"
    else
        echo "   ❌ Bot failed to start"
        echo "   Check log: tail -20 /var/www/smartcity-frontend/bot.log"
        exit 1
    fi
else
    echo "4️⃣ Bot is already running, skipping start"
fi

# ============================================
# 5️⃣ BOT LOG'LARNI TEKSHIRISH
# ============================================
echo ""
echo "5️⃣ Checking bot logs..."

BOT_LOG="/var/www/smartcity-frontend/bot.log"
if [ -f "$BOT_LOG" ]; then
    echo "   Last 10 lines of bot log:"
    tail -10 "$BOT_LOG" | sed 's/^/   /'
else
    echo "   ⚠️ Bot log file not found: $BOT_LOG"
fi

# ============================================
# 6️⃣ API ENDPOINT'NI TEKSHIRISH
# ============================================
echo ""
echo "6️⃣ Testing API endpoint..."

API_URL="https://ferganaapi.cdcgroup.uz/api/iot-devices/data/update/"
echo "   Testing: $API_URL"

# Test with sample data
TEST_RESPONSE=$(curl -s -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -d '{
        "device_id": "TEST-DEVICE",
        "temperature": 25.0,
        "humidity": 50.0
    }' || echo "ERROR")

if [[ "$TEST_RESPONSE" == *"error"* ]] || [[ "$TEST_RESPONSE" == *"Device"* ]]; then
    echo "   ✅ API endpoint is accessible"
    echo "   Response: $TEST_RESPONSE"
else
    echo "   ⚠️ API endpoint test failed or unexpected response"
    echo "   Response: $TEST_RESPONSE"
fi

# ============================================
# 7️⃣ XULOSA
# ============================================
echo ""
echo "=========================================="
echo "✅ BOT CHECK COMPLETE"
echo "=========================================="
echo ""
echo "Bot status:"
if [ ! -z "$BOT_PID" ] || [ ! -z "$NEW_BOT_PID" ]; then
    echo "  ✅ Bot is running"
    echo "  PID: $BOT_PID$NEW_BOT_PID"
else
    echo "  ❌ Bot is NOT running"
fi
echo ""
echo "Useful commands:"
echo "  Check bot process: ps aux | grep iot_monitor"
echo "  View bot log: tail -f /var/www/smartcity-frontend/bot.log"
echo "  Stop bot: pkill -f iot_monitor.py"
echo "  Restart bot: ./CHECK_AND_START_BOT.sh"
echo ""
