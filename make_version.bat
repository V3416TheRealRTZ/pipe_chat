@echo off
type version
set /p Build=<version
set /a Build+=1
>version echo %Build%
For /f "tokens=1-3 delims=/ " %%a in ('date /t') do (set mydate=%%a)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
>>version echo %mydate%_%mytime%
COPY %~dp0\client\debug\PipeChatClient.exe %~dp0\%Build%_%mydate%_%mytime%_client.exe
COPY %~dp0\server\debug\PipeChatServer.exe %~dp0\%Build%_%mydate%_%mytime%_server.exe