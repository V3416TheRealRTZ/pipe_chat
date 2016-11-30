#include "pipechatclient.h"

PipeChatClient::PipeChatClient()
{

}

PipeChatClient::~PipeChatClient()
{

}

void PipeChatClient::connectToHost(const QString &hostName, quint16 port, QIODevice::OpenMode openMode, QAbstractSocket::NetworkLayerProtocol protocol)
{
    QAbstractSocket::connectToHost(hostName, port, openMode, protocol);
}

/*void PipeChatClient::appendMessage(const QString& message)
{
    QRegExp regexp("^(.*) (.*) (.*)$");

    if(regexp.indexIn(message) == -1) {
        qDebug() << "Received unknown message: " << message;
        return;
    }
    m_Model.addMessage(regexp.cap(1), regexp.cap(2), regexp.cap(3));
}*/

void PipeChatClient::onReadyRead()
{

}

void PipeChatClient::onConnected()
{

}
