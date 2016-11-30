#include <QCoreApplication>

#include "pipechatserver.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    PipeChatServer();

    return a.exec();
}
