@echo off
echo ========================================
echo GitHub Push Script
echo ========================================
echo.

REM Clear Git credentials
echo [1] Clearing old GitHub credentials...
cmdkey /list:target=git:https://github.com 2>nul
if %errorlevel% equ 0 (
    cmdkey /delete:target=git:https://github.com
    echo    - Credentials cleared!
) else (
    echo    - No old credentials found
)
echo.

REM Backend Push
echo [2] Pushing Backend to GitHub...
cd /d E:\Smartcity\backend
git push origin master
if %errorlevel% neq 0 (
    echo.
    echo ========================================
    echo BACKEND PUSH FAILED!
    echo ========================================
    echo.
    echo GitHub will ask for your username and password.
    echo Use your Personal Access Token as password!
    echo.
    echo How to create a token:
    echo 1. Go to: https://github.com/settings/tokens
    echo 2. Generate new token (classic)
    echo 3. Select 'repo' scope
    echo 4. Copy the token
    echo 5. Use it as password when prompted
    echo.
    pause
    git push origin master
)
echo.

REM Frontend Push
echo [3] Pushing Frontend to GitHub...
cd /d E:\Smartcity\frontend
git push origin master
if %errorlevel% neq 0 (
    echo.
    echo ========================================
    echo FRONTEND PUSH FAILED!
    echo ========================================
    echo.
    pause
    git push origin master
)
echo.

echo ========================================
echo DONE!
echo ========================================
echo.
echo Check your repositories:
echo - Backend:  https://github.com/backend-developer-hojiakbar/smartApiFull
echo - Frontend: https://github.com/backend-developer-hojiakbar/smartFrontFull
echo.
pause
