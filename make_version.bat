@echo off
set /p Build=<version
set /a Build+=1
For /f "tokens=1-3 delims=/ " %%a in ('date /t') do (set mydate=%%a)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
for /f %%v in ('git rev-parse --short HEAD') do set hash=%%v
>version echo %Build%_%mydate%_%mytime%_%hash%

echo %Build%_%mydate%_%mytime%_%hash% >version
break >version.h
echo #define VERSION_BUILD "%Build%_%mydate%_%mytime%_%hash%" >version.h
COPY %~dp0\version.h "%~dp0\client
echo %Build%_%mydate%_%mytime%_%hash%