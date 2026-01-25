@echo off
chcp 65001 >nul
echo ╔════════════════════════════════════════════════════════════╗
echo ║              GITHUB'GA PUSH QILISH                        ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Git remote tekshirish
git remote -v >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Git remote topilmadi!
    echo.
    echo Quyidagi buyruqni bajarib remote qo'shing:
    echo.
    echo   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
    echo.
    pause
    exit /b 1
)

REM Current branch
for /f "tokens=2" %%b in ('git branch --show-current 2^>nul') do set BRANCH=%%b
if "%BRANCH%"=="" set BRANCH=master

echo 📋 Branch: %BRANCH%
echo.

REM Status
echo 📊 Git Status:
git status --short
echo.

REM Commit (agar o'zgarishlar bo'lsa)
git diff --quiet
if errorlevel 1 (
    echo 💾 O'zgarishlar bor. Commit qilinmoqda...
    git add .
    git commit -m "feat: Enhanced features v2.0 - 11 new components, 7 backend models, bug fixes"
    echo ✅ Commit qilindi
    echo.
)

REM Push
echo 🚀 GitHub'ga push qilinmoqda...
echo.

git push -u origin %BRANCH%
if errorlevel 1 (
    echo.
    echo ❌ Push qilishda xatolik!
    echo.
    echo Tekshirish:
    echo   1. GitHub repository mavjudligi
    echo   2. Authentication (token yoki SSH key)
    echo   3. Internet ulanishi
    pause
    exit /b 1
)

echo.
echo ✅ Muvaffaqiyatli push qilindi!
echo.
echo 🌐 Repository: 
git remote get-url origin
echo 📦 Branch: %BRANCH%
echo.
pause
