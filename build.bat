git pull && make_version.bat && cd %~dp0\server && build_server.bat && cd %~dp0\client && build_client.bat && cd %~dp0

set /p Build=<version

COPY %~dp0\client\release\PipeChatClient.exe "%~dp0\%Build%_client.exe"
COPY %~dp0\server\release\PipeChatServer.exe "%~dp0\%Build%_server.exe"