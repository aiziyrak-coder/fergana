#!/bin/bash

echo "=== Testing Waste Bins API ==="
echo ""

# Test 1: Direct API call without authentication
echo "1. Testing API without auth token:"
RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" https://ferganaapi.cdcgroup.uz/api/waste-bins/)
HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | sed '/HTTP_CODE/d')

echo "HTTP Status: $HTTP_CODE"
if [ "$HTTP_CODE" = "200" ]; then
    BIN_COUNT=$(echo "$BODY" | python3 -c "import sys, json; data = json.load(sys.stdin); print(len(data))" 2>/dev/null || echo "Error parsing JSON")
    echo "Total bins: $BIN_COUNT"
    echo "First 200 chars of response:"
    echo "$BODY" | head -c 200
    echo ""
else
    echo "Response body:"
    echo "$BODY" | head -c 500
    echo ""
fi

echo ""
echo "=== Test Complete ==="
