#include "mainwindow.h"

#include <QTcpSocket>

const QString MainWindow::SYSTEM_MSGS[] = {
        "",
        "/join",
        "/users"
    };

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    socket = new QTcpSocket(this);

    connect(socket, &QTcpSocket::connected, this, &MainWindow::onConnected);
    connect(socket, &QTcpSocket::readyRead, this, &MainWindow::onReadyRead);
}

MainWindow::~MainWindow()
{

}

void MainWindow::parseSystemMessage(const QString &msg)
{
    QStringList parts = msg.split(' ', QString::SkipEmptyParts);
    SystemMsg sysMsg = smNONE;
    for(size_t i = 0; i < sizeof(SYSTEM_MSGS); ++i)
        if (parts[0] == SYSTEM_MSGS[i])
            sysMsg = static_cast<SystemMsg>(i);

    switch(sysMsg) {
    case smNONE:
        qDebug() << "Received unknown system message.";
        break;
    case smUSERS:
        parts.removeFirst();
        userlist = parts;
        break;
    default:
        qWarning() << "Failed to parse system message " << msg;
    }
}

void MainWindow::onReadyRead()
{
    while(socket->canReadLine()) {
        QString data = QString::fromUtf8(socket->readLine()).trimmed();
        qDebug() << "Read data:" << data;;

        if (data[0] == '/')
            parseSystemMessage(data);
        else
            emit receivedMessage(data);
    }
}

void MainWindow::onConnected()
{
    socket->write(QString("/join" + username).toUtf8());
}
