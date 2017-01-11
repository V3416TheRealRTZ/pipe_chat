#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>

#include "box2dplugin.h"

#include "pipechatmessagemodel.h"
#include "pipechatclient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QDir directory(":/emotes/");
    QStringList imagesList = directory.entryList(QStringList("*.png"));

    qmlRegisterType<PipeChatMessageModel>("pipechat.messagemodel", 1, 0, "PipeChatMessageModel");

    PipeChatClient client;

    QQmlApplicationEngine engine;
    engine.clearComponentCache();
    engine.rootContext()->setContextProperty("client", &client);
    engine.rootContext()->setContextProperty("emotesModel", QVariant::fromValue(imagesList));
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
