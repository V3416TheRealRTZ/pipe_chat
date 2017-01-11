QT += qml quick

CONFIG += c++11

SOURCES += main.cpp \
    pipechatclient.cpp \
    pipechatmessagemodel.cpp

RESOURCES += qml.qrc \
    images.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    pipechatclient.h \
    pipechatmessagemodel.h \
    version.h

include(qml-box2d/box2d-static.pri)
