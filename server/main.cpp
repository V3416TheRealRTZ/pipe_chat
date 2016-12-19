#include <QCoreApplication>

#include "pipechatserver.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    PipeChatServer server;

    if (!server.listen())
        qDebug() << "Failed to begin listening!";
    else
        qInfo() << "Listening on port " << server.serverPort();

    return a.exec();
}
