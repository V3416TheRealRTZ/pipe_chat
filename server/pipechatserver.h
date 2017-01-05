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
        smUSERS,
        smFATAL
    };

    static const QStringList SYSTEM_MSGS; //!< Keywords indicating various system messages

    QMap<QTcpSocket *, QString> m_Clients;
    QSet<QString> m_Usernames;

protected:
    virtual void incomingConnection(int socketfd);

public:
    PipeChatServer(QObject *parent = 0);
    ~PipeChatServer();

private slots:
    //< Called whenever a socket disconnects.
    void onDisconnected();
    //< Called whenever a socket sends data.
    void receiveData();

private:
    //< Send message to all connected clients, with possible exception
    void broadcast(const QString &msg, QTcpSocket *exception = nullptr);
    //< Broadcast message with added author and timestamp
    void broadcastMessage(const QString &author, const QString &msg, QTcpSocket *exception = nullptr);
    //< Parse and process received system message
    void parseSystemMessage(QTcpSocket *sender, const QString &msg);
    //< Write message to a socket
    void sendMessage(QTcpSocket *socket, const QString &msg);
    //< Broadcast userlist
    void sendUserList();

};

#endif // PIPECHATSERVER_H
