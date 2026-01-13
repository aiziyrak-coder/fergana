# 🎯 COMPREHENSIVE QA TEST PLAN
## Smart City Dashboard - Farg'ona

**Test Date:** January 13, 2026  
**Tester:** Senior QA Team  
**Environment:** Production (https://fergana.cdcgroup.uz)

---

## 📋 TEST SCOPE

### **1. FRONTEND TESTING**
- [ ] Authentication & Authorization
- [ ] All Modules (12 modules)
- [ ] All Pages & Views
- [ ] All Buttons & Interactive Elements
- [ ] Forms & Validation
- [ ] Real-time Updates
- [ ] Responsive Design
- [ ] Error Handling
- [ ] Performance

### **2. BACKEND API TESTING**
- [ ] All Endpoints
- [ ] Authentication
- [ ] CRUD Operations
- [ ] Data Validation
- [ ] Error Responses
- [ ] Performance

### **3. INTEGRATION TESTING**
- [ ] Frontend ↔ Backend
- [ ] Backend ↔ Database
- [ ] Backend ↔ Telegram Bot
- [ ] QR Code System

### **4. TELEGRAM BOT TESTING**
- [ ] QR Code Scanning
- [ ] Image Upload
- [ ] AI Analysis
- [ ] Response Time
- [ ] Error Handling

### **5. SECURITY TESTING**
- [ ] Authentication
- [ ] Authorization
- [ ] CORS
- [ ] CSRF Protection
- [ ] SQL Injection
- [ ] XSS Prevention

### **6. PERFORMANCE TESTING**
- [ ] Page Load Time
- [ ] API Response Time
- [ ] Database Queries
- [ ] Real-time Updates
- [ ] Concurrent Users

---

## 🧪 DETAILED TEST CASES

### **MODULE 1: AUTHENTICATION**

#### Test Case 1.1: Login Page
- [ ] **Navigation:** URL loads correctly
- [ ] **UI:** All elements visible (logo, form, buttons)
- [ ] **Form Validation:**
  - Empty fields show error
  - Invalid credentials show error
  - Valid credentials proceed to dashboard
- [ ] **Security:**
  - Password masked
  - No password in URL/logs
  - Token stored securely

#### Test Case 1.2: Valid Login
```
Credentials: fergan / 123
Expected: Redirect to dashboard
Token: Stored in localStorage
Session: Active
```

#### Test Case 1.3: Invalid Login
```
Test 1: Wrong password → Error message
Test 2: Wrong username → Error message
Test 3: Empty fields → Validation error
Test 4: SQL injection attempt → Rejected
```

#### Test Case 1.4: Logout
- [ ] Logout button visible
- [ ] Click logout → Redirect to login
- [ ] Token cleared
- [ ] Cannot access protected routes

---

### **MODULE 2: DASHBOARD (Markaz)**

#### Test Case 2.1: Dashboard Load
- [ ] Page loads in < 3 seconds
- [ ] All cards visible:
  - Statistics cards (4x)
  - MFY selector dropdown
  - Active modules display
- [ ] Data loads correctly
- [ ] No console errors

#### Test Case 2.2: MFY Selector
- [ ] Dropdown opens
- [ ] All MFY options listed
- [ ] Selection updates data
- [ ] Statistics refresh correctly

#### Test Case 2.3: Module Cards
- [ ] **Chiqindi Module:**
  - Icon visible
  - Name correct
  - Status "Faol"
  - Click opens module
- [ ] **Issiqlik Module:**
  - Icon visible
  - Name correct
  - Status "Faol"
  - Click opens module
- [ ] **Locked Modules:**
  - Lock icon shown
  - "Tez orada" message
  - Click shows "locked" message

---

### **MODULE 3: CHIQINDI (Waste Management)**

#### Test Case 3.1: Module Load
- [ ] Tab switches correctly
- [ ] Map loads
- [ ] Sidebar shows bins list
- [ ] All bins visible on map

#### Test Case 3.2: Bins List
- [ ] All 21 bins displayed
- [ ] Each bin shows:
  - Address
  - Fill level (%)
  - Status (BO'SH/TO'LDI)
  - Organization
- [ ] Click bin → Opens details modal
- [ ] Status colors correct:
  - Green: < 80%
  - Red: ≥ 80%

#### Test Case 3.3: Bin Details Modal
- [ ] **Header:**
  - Bin address shown
  - Bin ID displayed
  - Close button (X) works
- [ ] **Camera Feed:**
  - CCTV placeholder or actual feed
  - Source badge (CCTV or BOT)
  - AI status overlay
- [ ] **Monitoring Info:**
  - Fill level percentage
  - Progress bar matches percentage
  - Last signal/analysis
  - Device status (ONLINE)
- [ ] **QR Code Section:** ⭐ NEW
  - Title: "QR KOD - TELEGRAM BOT"
  - Download button visible
  - QR code image loads
  - QR code size: 192x192px
  - Description text visible
  - Bot badge: @tozafargonabot
  - AI Tahlil badge with pulse animation
- [ ] **Action Buttons:**
  - "QAYTA TAHLIL (AI)" button
  - "MAPS" button → Opens Google Maps
  - "O'CHIRISH" button
  - "TAHRIRLASH" button

#### Test Case 3.4: QR Code Functionality ⭐ CRITICAL
- [ ] **QR Code Display:**
  - QR code visible
  - Image loads correctly
  - No broken image icon
  - Correct URL format
- [ ] **Download Button:**
  - Click downloads QR code
  - File name: `konteyner-{id}-qr.png`
  - File size: ~800 bytes
  - Valid PNG format
- [ ] **QR Code Scan:**
  - Scan with phone camera
  - Opens Telegram
  - Bot: @tozafargonadriversbot
  - Auto-sends /start {bin_id}

#### Test Case 3.5: Add New Bin
- [ ] "KONTEYNER QO'SHISH" button visible
- [ ] Click opens modal
- [ ] Form fields:
  - Mas'ul Korxona (dropdown)
  - Latitude (number input)
  - Longitude (number input)
  - GPS button works
  - Aniq Manzil (text input)
  - Kamera IP (optional)
- [ ] Validation:
  - Empty fields show error
  - Invalid coordinates rejected
  - GPS button gets current location
- [ ] Save button:
  - Creates new bin
  - QR code auto-generated ⭐
  - Appears in list immediately
  - Shows on map

#### Test Case 3.6: Edit Bin
- [ ] Click "TAHRIRLASH"
- [ ] Modal opens with current data
- [ ] All fields editable
- [ ] Save updates bin
- [ ] Changes reflect immediately

#### Test Case 3.7: Delete Bin
- [ ] Click "O'CHIRISH"
- [ ] Confirmation dialog (if any)
- [ ] Bin removed from list
- [ ] Bin removed from map
- [ ] Database updated

#### Test Case 3.8: AI Analysis
- [ ] Click "QAYTA TAHLIL"
- [ ] Loading indicator shows
- [ ] AI analyzes image (5-10s)
- [ ] Status updates:
  - Fill level changes
  - Status (TO'LA/BO'SH) updates
  - Last analysis updates
- [ ] Error handling if no image

#### Test Case 3.9: Map Functionality
- [ ] All bins shown as markers
- [ ] Marker colors:
  - Green: < 80%
  - Red: ≥ 80%
- [ ] BOT uploaded bins have indicator
- [ ] Click marker opens modal
- [ ] Map zoom/pan works
- [ ] Markers update real-time

#### Test Case 3.10: Trucks Tab
- [ ] Switch to TRUCKS tab
- [ ] All trucks listed
- [ ] Truck markers on map (blue)
- [ ] Click truck opens details
- [ ] Add truck button works
- [ ] Edit/delete trucks works

#### Test Case 3.11: Real-time Updates
- [ ] Data refreshes every 5 seconds
- [ ] Console shows refresh logs
- [ ] No flickering
- [ ] No memory leaks
- [ ] Updates seamless

---

### **MODULE 4: ISSIQLIK (Climate Control)**

#### Test Case 4.1: Module Load
- [ ] Facilities list loads
- [ ] All schools/kindergartens shown
- [ ] Each facility shows:
  - Name
  - Type (SCHOOL/KINDERGARTEN)
  - MFY
  - Status color
- [ ] Click facility opens details

#### Test Case 4.2: Facility Details
- [ ] **Overview:**
  - Name, type, MFY
  - Overall status
  - Energy usage
  - Efficiency score
  - Manager name
  - Last maintenance
- [ ] **Rooms List:**
  - All rooms displayed
  - Temperature for each
  - Humidity for each
  - Status indicator
- [ ] **Boilers List:**
  - All boilers displayed
  - Current settings
  - Status
- [ ] **IoT Devices:**
  - Device IDs
  - Current readings
  - Last update time

#### Test Case 4.3: IoT Sensor Data
- [ ] Temperature readings:
  - Update every 10 seconds
  - Range: 18-25°C
  - Displayed correctly
- [ ] Humidity readings:
  - Update every 10 seconds
  - Range: 40-60%
  - Displayed correctly
- [ ] Device status:
  - Online/Offline indicator
  - Last seen timestamp
  - Battery level (if any)

---

### **MODULE 5: LOCKED MODULES**

#### Test Case 5.1-5.9: Test Each Locked Module
- [ ] Namlik (Moisture)
- [ ] Havo (Air Quality)
- [ ] Xavfsizlik (Security)
- [ ] Eco-Nazorat
- [ ] Qurilish (Construction)
- [ ] Light-AI
- [ ] Transport
- [ ] Murojaatlar (Call Center)
- [ ] Tahlil (Analytics)

**For Each:**
- [ ] Icon shows lock
- [ ] Status: "Tez orada"
- [ ] Click shows message
- [ ] No errors in console

---

### **MODULE 6: BACKEND API TESTING**

#### Test Case 6.1: Authentication API
```bash
# Login
curl -X POST https://ferganaapi.cdcgroup.uz/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"login":"fergan","password":"123"}'

Expected: 200 OK
Response: {"token": "...", "user": {...}}
```

#### Test Case 6.2: Waste Bins API
```bash
# Get all bins
curl https://ferganaapi.cdcgroup.uz/api/waste-bins/ \
  -H "Authorization: Token {token}"

Expected: 200 OK
Response: Array of bins with qr_code_url ⭐

# Get single bin
curl https://ferganaapi.cdcgroup.uz/api/waste-bins/{id}/ \
  -H "Authorization: Token {token}"

Expected: 200 OK
Response: Bin object with qr_code_url ⭐

# Create bin
curl -X POST https://ferganaapi.cdcgroup.uz/api/waste-bins/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Token {token}" \
  -d '{...}'

Expected: 201 Created
Response: New bin with auto-generated qr_code_url ⭐

# Update bin
curl -X PATCH https://ferganaapi.cdcgroup.uz/api/waste-bins/{id}/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Token {token}" \
  -d '{...}'

Expected: 200 OK

# Delete bin
curl -X DELETE https://ferganaapi.cdcgroup.uz/api/waste-bins/{id}/ \
  -H "Authorization: Token {token}"

Expected: 204 No Content
```

#### Test Case 6.3: IoT Devices API
```bash
# Get all devices
curl https://ferganaapi.cdcgroup.uz/api/iot-devices/ \
  -H "Authorization: Token {token}"

# Update sensor data
curl -X POST https://ferganaapi.cdcgroup.uz/api/iot-devices/data/update/ \
  -H "Content-Type: application/json" \
  -d '{"device_id":"ESP-1E6CDD","temperature":23.5,"humidity":55}'

Expected: 200 OK
```

#### Test Case 6.4: Error Responses
- [ ] 401 Unauthorized (no token)
- [ ] 403 Forbidden (wrong permissions)
- [ ] 404 Not Found (invalid ID)
- [ ] 400 Bad Request (invalid data)
- [ ] 500 Internal Error (handled gracefully)

---

### **MODULE 7: TELEGRAM BOT TESTING** ⭐ CRITICAL

#### Test Case 7.1: Bot Availability
```bash
# Check bot is online
curl https://api.telegram.org/bot{TOKEN}/getMe

Expected: Bot info, username: @tozafargonadriversbot
```

#### Test Case 7.2: QR Code → Bot Flow
**Steps:**
1. Open platform → Chiqindi module
2. Click any bin
3. Scroll to QR code section
4. Scan QR with phone camera
5. Telegram opens
6. Bot sends /start {bin_id}

**Expected:**
- [ ] Bot responds in < 2 seconds ⭐
- [ ] Shows bin information:
  - Address
  - Fill level
  - Status
  - Organization
- [ ] Prompts for image upload
- [ ] Instructions clear

#### Test Case 7.3: Image Upload → AI Analysis
**Steps:**
1. Send image to bot
2. Wait for AI analysis

**Expected:**
- [ ] Bot acknowledges image (< 1s)
- [ ] "Tahlil qilinmoqda..." message
- [ ] AI analysis completes (5-15s)
- [ ] Bot responds with:
  - Status (TO'LA/BO'SH)
  - Fill level %
  - AI confidence %
  - Analysis notes
  - Suggestions
- [ ] Platform updates in real-time
- [ ] Image appears with "BOT" badge

#### Test Case 7.4: Bot Error Handling
- [ ] **Invalid QR code:**
  - Error message shown
  - Instruction to scan valid QR
- [ ] **Non-image sent:**
  - Error: "Iltimos rasm yuboring"
- [ ] **No bin context:**
  - Prompts to scan QR first
- [ ] **Network error:**
  - Retry mechanism
  - User-friendly error

#### Test Case 7.5: Bot Performance
- [ ] Polling interval: 1 second
- [ ] Response time: < 2 seconds
- [ ] No 409 Conflicts ⭐
- [ ] No crashes
- [ ] Handles concurrent users

---

### **MODULE 8: QR CODE SYSTEM** ⭐ NEW FEATURE

#### Test Case 8.1: Auto-Generation
**Steps:**
1. Create new bin via platform
2. Check database for qr_code_url
3. Check file system for QR image

**Expected:**
- [ ] Signal triggers on bin creation
- [ ] QR code generated immediately
- [ ] URL format: `https://ferganaapi.cdcgroup.uz/media/qr_codes/bin_{id}_qr.png`
- [ ] File exists on disk
- [ ] File size: ~800 bytes
- [ ] Valid PNG format
- [ ] QR data: `https://t.me/tozafargonadriversbot?start={id}`

#### Test Case 8.2: Frontend Display
- [ ] QR code loads in modal
- [ ] Image not broken
- [ ] Size: 192x192px
- [ ] Gradient background visible
- [ ] Download button present
- [ ] Badges visible
- [ ] Hover effects work

#### Test Case 8.3: Download Functionality
**Steps:**
1. Click "Yuklab olish" button
2. Check downloaded file

**Expected:**
- [ ] File downloads immediately
- [ ] Filename: `konteyner-{id}-qr.png`
- [ ] File valid PNG
- [ ] Can scan downloaded QR
- [ ] Opens same bot

#### Test Case 8.4: QR Code Accuracy
**Steps:**
1. Download QR code
2. Scan with multiple devices:
   - iPhone camera
   - Android camera
   - QR scanner app
   - Telegram in-app scanner

**Expected:**
- [ ] All scanners recognize QR
- [ ] Opens Telegram
- [ ] Correct bot opens
- [ ] Correct bin ID passed

#### Test Case 8.5: Bulk QR Generation
```bash
# Generate QR for all bins
python manage.py generate_bin_qrcodes

Expected:
- All bins get QR codes
- No duplicates
- All files created
- All URLs valid
```

---

### **MODULE 9: SECURITY TESTING**

#### Test Case 9.1: Authentication
- [ ] **No token:** Cannot access API
- [ ] **Invalid token:** Rejected
- [ ] **Expired token:** Refresh or re-login
- [ ] **Token in localStorage:** Secure
- [ ] **Logout:** Token cleared

#### Test Case 9.2: Authorization
- [ ] Admin can access all
- [ ] Driver can only see their data
- [ ] No privilege escalation
- [ ] Role-based access works

#### Test Case 9.3: Injection Attacks
```bash
# SQL Injection
login: admin' OR '1'='1
Expected: Rejected

# XSS
address: <script>alert('xss')</script>
Expected: Sanitized

# Command Injection
address: ; rm -rf /
Expected: Rejected
```

#### Test Case 9.4: CORS & CSRF
- [ ] CORS allows only:
  - https://fergana.cdcgroup.uz
  - https://ferganaapi.cdcgroup.uz
- [ ] CSRF token validated
- [ ] Cross-origin rejected

---

### **MODULE 10: PERFORMANCE TESTING**

#### Test Case 10.1: Page Load Time
- [ ] Login page: < 1s
- [ ] Dashboard: < 3s
- [ ] Chiqindi module: < 3s
- [ ] Issiqlik module: < 3s
- [ ] All assets cached

#### Test Case 10.2: API Response Time
- [ ] Auth login: < 500ms
- [ ] Get bins: < 1s
- [ ] Get single bin: < 200ms
- [ ] Create bin: < 1s
- [ ] Update bin: < 500ms

#### Test Case 10.3: Real-time Updates
- [ ] Polling interval: 5s
- [ ] Data updates smoothly
- [ ] No UI freezing
- [ ] Memory stable

#### Test Case 10.4: Concurrent Users
```bash
# Simulate 10 concurrent users
ab -n 100 -c 10 https://ferganaapi.cdcgroup.uz/api/waste-bins/

Expected:
- All requests succeed
- Average response < 1s
- No crashes
```

#### Test Case 10.5: Database Performance
- [ ] Query optimization
- [ ] Indexes on foreign keys
- [ ] No N+1 queries
- [ ] Connection pooling

---

### **MODULE 11: USER EXPERIENCE**

#### Test Case 11.1: Navigation
- [ ] All menu items work
- [ ] Back button works
- [ ] Breadcrumbs (if any)
- [ ] No broken links
- [ ] Loading indicators

#### Test Case 11.2: Forms & Validation
- [ ] Clear error messages
- [ ] Inline validation
- [ ] Success messages
- [ ] Form reset after submit
- [ ] Disabled state during submit

#### Test Case 11.3: Responsive Design
- [ ] Desktop (1920x1080)
- [ ] Laptop (1366x768)
- [ ] Tablet (768x1024)
- [ ] Mobile (375x667)
- [ ] All elements visible
- [ ] No horizontal scroll

#### Test Case 11.4: Accessibility
- [ ] Keyboard navigation
- [ ] Tab order logical
- [ ] Focus indicators
- [ ] Alt text for images
- [ ] ARIA labels

#### Test Case 11.5: Internationalization
- [ ] O'zbek tilida (Lotin)
- [ ] Consistent terminology
- [ ] No mixed languages
- [ ] Date/time format correct

---

### **MODULE 12: ERROR HANDLING**

#### Test Case 12.1: Network Errors
- [ ] Offline mode message
- [ ] Retry mechanism
- [ ] Graceful degradation
- [ ] Error boundaries

#### Test Case 12.2: API Errors
- [ ] 400: Clear message
- [ ] 401: Redirect to login
- [ ] 403: Permission denied message
- [ ] 404: Not found message
- [ ] 500: Generic error message

#### Test Case 12.3: User Errors
- [ ] Invalid input: Validation message
- [ ] Required fields: Highlighted
- [ ] Format errors: Examples shown
- [ ] Duplicate entries: Warning

---

## 📊 TEST EXECUTION TRACKING

### Priority Levels:
- 🔴 **P0 - Critical:** Must work for production
- 🟡 **P1 - High:** Important features
- 🟢 **P2 - Medium:** Nice to have
- 🔵 **P3 - Low:** Edge cases

### Test Results Format:
```
✅ PASS - Test case passed
❌ FAIL - Test case failed (blocker)
⚠️ WARNING - Test case passed with issues
🔄 RETEST - Need to retest after fix
⏭️ SKIP - Skipped (out of scope)
```

---

## 🐛 BUG REPORT TEMPLATE

```
### Bug #{number}
**Title:** [Short description]
**Priority:** P0/P1/P2/P3
**Module:** [Module name]
**Environment:** Production/Staging

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Result:**
[What should happen]

**Actual Result:**
[What actually happens]

**Screenshots/Logs:**
[Attach if applicable]

**Impact:**
[User impact description]

**Proposed Fix:**
[If known]
```

---

## 🎯 TEST SUMMARY REPORT

### Overall Statistics:
- **Total Test Cases:** 150+
- **Executed:** TBD
- **Passed:** TBD
- **Failed:** TBD
- **Blocked:** TBD
- **Coverage:** TBD%

### Critical Paths Tested:
1. ✅ Login → Dashboard → Module
2. ⏳ Create Bin → QR Code → Bot → Image → Platform
3. ⏳ IoT Sensor → Backend → Frontend Update
4. ⏳ Real-time Polling → Data Refresh

### Known Issues:
- TBD

### Recommendations:
- TBD

---

**QA Team Lead:** [Name]  
**Sign-off Date:** [Date]  
**Status:** ⏳ IN PROGRESS

