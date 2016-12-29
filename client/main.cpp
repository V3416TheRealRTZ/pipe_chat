#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "box2dplugin.h"

#include "pipechatmessagemodel.h"
#include "pipechatclient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    //Box2DPlugin plugin;
    //plugin.registerTypes("Box2D");

    qmlRegisterType<PipeChatMessageModel>("pipechat.messagemodel", 1, 0, "PipeChatMessageModel");

    PipeChatClient client;

    QQmlApplicationEngine engine;
    engine.clearComponentCache();
    engine.rootContext()->setContextProperty("client", &client);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
