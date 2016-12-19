#ifndef PIPECHATSERVER_H
#define PIPECHATSERVER_H

#include <QTcpServer>

class QTcpSocket;

class PipeChatServer : public QTcpServer
{
    Q_OBJECT

    struct Client {
        QTcpSocket *Socket;
        QString Name;
        Client(QTcpSocket *newSocket, const QString &newName) :
            Socket(newSocket), Name(newName)
        {}
        ~Client() {}
    };

    QSet<Client *> m_Clients;

    enum SystemMsg {
        smNONE,
        smJOIN,
        smUSERS
    };

    static const QString SYSTEM_MSGS[]; // Keywords indicating various system messages

public:
    PipeChatServer(QObject *parent = 0);
    ~PipeChatServer();

private slots:
    /* Called whenever a socket disconnects. */
    void onDisconnected();
    /* Called whenever a socket sends data. */
    void receiveData();

private:
    void broadcast(const QString &msg, QTcpSocket *exception = nullptr);
    void parseSystemMessage(QTcpSocket *sender, const QString &msg);
    void sendMessage(QTcpSocket *socket, const QString &msg);
    void sendUserList();
    Client *findClient(QTcpSocket *socket);

};

#endif // PIPECHATSERVER_H
