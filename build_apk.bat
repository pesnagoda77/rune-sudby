@echo off
chcp 65001 >nul
cd /d D:\Projects\Mobile\rune_day_v3
echo [1/3] Creating Android project...
C:\flutter\bin\flutter.bat create .
echo [2/3] Getting dependencies...
C:\flutter\bin\flutter.bat pub get
echo [3/3] Building release APK...
C:\flutter\bin\flutter.bat build apk --release
echo.
echo Done! APK is at:
echo build\app\outputs\flutter-apk\app-release.apk
pause
