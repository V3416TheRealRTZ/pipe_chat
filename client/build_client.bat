qmake.exe %~dp0\PipeChatClient.pro -r -spec win32-g++ "CONFIG+=debug" "CONFIG+=qml_debug static" && mingw32-make.exe