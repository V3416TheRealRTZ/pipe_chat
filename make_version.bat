type version
set /p Build=<version
set /a Build+=1
>version echo %Build%
For /f "tokens=1-3 delims=/ " %%a in ('date /t') do (set mydate=%%a)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
>>version echo %mydate%_%mytime%
for /f %%v in ('git rev-parse --short HEAD') do set hash=%%v
>>version echo %hash%
COPY %~dp0\client\debug\PipeChatClient.exe "%~dp0\%Build%_%mydate%_%mytime%_%hash%_client.exe"
COPY %~dp0\server\debug\PipeChatServer.exe "%~dp0\%Build%_%mydate%_%mytime%_%hash%_server.exe"