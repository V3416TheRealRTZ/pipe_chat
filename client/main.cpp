#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>

#include "box2dplugin.h"

#include "pipechatmessagemodel.h"
#include "pipechatclient.h"

#include "version.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QDir directory(":/emotes/");
    QStringList imagesList = directory.entryList(QStringList("*.png"));
    QString build = VERSION_BUILD;

    qmlRegisterType<PipeChatMessageModel>("pipechat.messagemodel", 1, 0, "PipeChatMessageModel");

    PipeChatClient client;

    QQmlApplicationEngine engine;
    engine.clearComponentCache();
    engine.rootContext()->setContextProperty("client", &client);
    engine.rootContext()->setContextProperty("emotesModel", QVariant::fromValue(imagesList));
    engine.rootContext()->setContextProperty("BUILD", QVariant::fromValue(build));
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
