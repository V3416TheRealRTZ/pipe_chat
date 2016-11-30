#include <QRegExp>
#include <QTcpSocket>

#include "pipechatserver.h"

const QString PipeChatServer::SYSTEM_MSGS[] = {
        "",
        "/join",
        "/users"
    };

PipeChatServer::PipeChatServer(QObject *parent) : QTcpServer(parent)
{
    if (!listen())
        qDebug() << "Failed to begin listening!";
    else
        printf_s("Listening on port %u...", serverPort());
}

PipeChatServer::~PipeChatServer()
{

}

void PipeChatServer::onDisconnected()
{
    QTcpSocket *user = static_cast<QTcpSocket *>(sender());
    Client *client = findClient(user);
    if ( client == nullptr) {
        qDebug() << "Disconnected socket isn't in the client list.";
        return;
    }

    broadcast( client->name + " disconnected." );
    clients.remove(client);
    sendUserList();
}

void PipeChatServer::receiveData()
{
    QTcpSocket *client = (QTcpSocket *) sender();
    while (client->canReadLine()) {
        QString data = QString::fromUtf8(client->readLine()).trimmed();
        qDebug() << "Read data:" << data;

        if (data[0] == '/')
            parseSystemMessage(client, data);
        else {
            broadcast(data, client);
        }
    }
}

void PipeChatServer::broadcast(const QString &msg, QTcpSocket *exception /* = nullptr */)
{
    for (Client *client : clients)
        if (exception != nullptr && client->socket != exception)
            sendMessage(client->socket, msg);
}

void PipeChatServer::parseSystemMessage(QTcpSocket *sender, const QString &msg)
{
    QStringList parts = msg.split(' ', QString::SkipEmptyParts);
    SystemMsg sysMsg = smNONE;
    for(size_t i = 0; i < sizeof(SYSTEM_MSGS); ++i)
        if (parts[0] == SYSTEM_MSGS[i])
            sysMsg = static_cast<SystemMsg>(i);

    switch(sysMsg) {
    case smNONE:
        sendMessage(sender, "Unknown command.");
        break;
    case smJOIN:
        clients.insert(new Client(sender, parts[1]));
        sendUserList();
        broadcast(parts[1] + " joined.");
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
    socket->write(msg.toUtf8());
}

void PipeChatServer::sendUserList()
{
    QString msg(SYSTEM_MSGS[smUSERS]);
    for (Client *client : clients)
        msg += " " + client->name;
    broadcast(msg);
}

PipeChatServer::Client *PipeChatServer::findClient(QTcpSocket *socket)
{
    for (Client *client : clients)
        if (client->socket == socket)
            return client;
    return nullptr;
}

