@echo off
cd /d D:\Projects\Mobile\rune_day_v3
C:\flutter\bin\flutter.bat create .
C:\flutter\bin\flutter.bat pub get
C:\flutter\bin\flutter.bat build apk --release
pause
