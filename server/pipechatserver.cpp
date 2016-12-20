#include <QRegExp>
#include <QTcpSocket>
#include <QDateTime>

#include "pipechatserver.h"

template <typename T, std::size_t N>
constexpr std::size_t countof(T const (&)[N]) noexcept
{
    return N;
}

const QStringList PipeChatServer::SYSTEM_MSGS = {
    "",
    "/join",
    "/users"
};



PipeChatServer::PipeChatServer(QObject *parent) : QTcpServer(parent)
{
}

PipeChatServer::~PipeChatServer()
{

}

void PipeChatServer::incomingConnection(int socketfd)
{
    QTcpSocket *client = new QTcpSocket(this);
    client->setSocketDescriptor(socketfd);

    qDebug() << "New client from:" << client->peerAddress().toString();

    connect(client, &QTcpSocket::readyRead, this, &PipeChatServer::receiveData);
    connect(client, &QTcpSocket::disconnected, this, &PipeChatServer::onDisconnected);

    m_Clients.insert(client, "");
}

void PipeChatServer::onDisconnected()
{
    QTcpSocket *user = static_cast<QTcpSocket *>(sender());
    if (!m_Clients.contains(user)) {
        qDebug() << "Disconnected socket isn't in the client list.";
        return;
    }

    broadcastMessage("System", m_Clients[user] + " disconnected.");
    qDebug() << m_Clients[user] << ":" << user->peerAddress().toString() << " disconnected.";
    m_Clients.remove(user);
    sendUserList();
}

void PipeChatServer::receiveData()
{
    QTcpSocket *client = (QTcpSocket *) sender();
    while (client->canReadLine()) {
        QString data = QString::fromUtf8(client->readLine()).trimmed();
        if( data.count() == 0 )
            break;
        qDebug() << "Read data:" << data;

        if (data[0] == '/')
            parseSystemMessage(client, data);
        else
            broadcastMessage(m_Clients[client], data);
    }
}

void PipeChatServer::broadcast(const QString &msg, QTcpSocket *exception /* = nullptr */)
{
    for (auto client : m_Clients.keys())
        if (exception == nullptr || client != exception)
            sendMessage(client, msg);
}

void PipeChatServer::broadcastMessage(const QString &author, const QString &msg, QTcpSocket *exception /* = nullptr */)
{
    broadcast(author + ';' + QDateTime::currentDateTime().toString("hh:mm") + ';' + msg, exception);
}

void PipeChatServer::parseSystemMessage(QTcpSocket *sender, const QString &msg)
{
    QStringList parts = msg.split(' ', QString::SkipEmptyParts);
    SystemMsg sysMsg = smNONE;
    int index = -1;
    if((index = SYSTEM_MSGS.indexOf(parts[0])) != -1)
        sysMsg = static_cast<SystemMsg>(index);

    switch(sysMsg) {
    case smNONE:
        sendMessage(sender, "Unknown command.");
        break;
    case smJOIN:
        m_Clients[sender] = parts[1];
        sendUserList();
        broadcastMessage("System", parts[1] + " joined.");
        break;
    case smUSERS:
        sendUserList();
        break;
    default:
        qWarning() << "Failed to parse system message " << msg;
    }
}

void PipeChatServer::sendMessage(QTcpSocket *socket, const QString &msg)
{
    socket->write((msg + '\n').toUtf8());
}

void PipeChatServer::sendUserList()
{
    QString msg(SYSTEM_MSGS[smUSERS]);
    for (auto clientName : m_Clients)
        msg += " " + clientName;
    broadcast(msg);
}

