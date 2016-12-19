#ifndef PIPECHATSERVER_H
#define PIPECHATSERVER_H

#include <QTcpServer>

class QTcpSocket;

class PipeChatServer : public QTcpServer
{
    Q_OBJECT

    enum SystemMsg {
        smNONE,
        smJOIN,
        smUSERS
    };

    static const QStringList SYSTEM_MSGS; // Keywords indicating various system messages

    QMap<QTcpSocket *, QString> m_Clients;

protected:
    virtual void incomingConnection(int socketfd);

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

};

#endif // PIPECHATSERVER_H
