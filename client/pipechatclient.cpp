#include "pipechatclient.h"

#include <QDateTime>

const QStringList PipeChatClient::SYSTEM_MSGS = {
    "",
    "/join",
    "/users"
};

PipeChatClient::PipeChatClient()
{
    connect(this, &QTcpSocket::connected, this, &PipeChatClient::onConnected);
    connect(this, &QTcpSocket::readyRead, this, &PipeChatClient::onReadyRead);
}

PipeChatClient::~PipeChatClient()
{

}

void PipeChatClient::connectToHost(const QString &hostName, quint16 port, QIODevice::OpenMode openMode, QAbstractSocket::NetworkLayerProtocol protocol)
{
    QAbstractSocket::connectToHost(hostName, port, openMode, protocol);
}

void PipeChatClient::disconnectFromHost()
{
    QTcpSocket::disconnectFromHost();
}

qint64 PipeChatClient::write(const char *data)
{
    qDebug() << "Socket writing: " << data;
    quint64 ret = QTcpSocket::write(data);
    if(ret < 0)
        qDebug() << "Socket writing error!";
    return ret;
}

void PipeChatClient::sendMessage(const QString &msg)
{
    if(msg.count() == 0)
        return;
    if(msg[0] == '/')
        return sendSystemMessage(msg);

    processSendMessage(msg);
}

void PipeChatClient::processSendMessage(const QString &msg)
{
    write((msg + '\n').toUtf8());
}

void PipeChatClient::sendSystemMessage(const QString &msg)
{
    sendSystemMessage(parseSystemMessage(msg));
}

void PipeChatClient::sendSystemMessage(PipeChatClient::SystemMsg sysMsg)
{
    switch(sysMsg) {
    case smJOIN:
        processSendMessage(SYSTEM_MSGS[sysMsg] + ' ' + username());
        break;
    case smUSERS:
        processSendMessage(SYSTEM_MSGS[sysMsg]);
        break;
    default:
        qWarning() << "Failed to send system message " << SYSTEM_MSGS[sysMsg];
    }
}

PipeChatClient::SystemMsg PipeChatClient::parseSystemMessage(const QString &msg)
{
    QStringList parts = msg.split(' ', QString::SkipEmptyParts);
    SystemMsg sysMsg = smNONE;
    int index = -1;
    if((index = SYSTEM_MSGS.indexOf(parts[0])) != -1)
        sysMsg = static_cast<SystemMsg>(index);

    return sysMsg;
}

void PipeChatClient::processSystemMessage(PipeChatClient::SystemMsg sysMsg, QString &msg)
{
    QStringList parts = msg.split(' ', QString::SkipEmptyParts);
    parts.removeFirst();
    switch(sysMsg) {
    case smUSERS:
        setUserlist(parts);
        emit userlistChanged();
        break;
    default:
        break;
    }
}

void PipeChatClient::onConnected()
{
    sendSystemMessage(smJOIN);
}

void PipeChatClient::onReadyRead()
{
    while (canReadLine()) {
        QString data = QString::fromUtf8(readLine()).trimmed();
        if( data.count() == 0 )
            break;
        qDebug() << "Read data:" << data;

        if (data[0] == '/')
            processSystemMessage(parseSystemMessage(data), data);
        else
            emit messageArrived(data);
    }
}
