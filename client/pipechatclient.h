#ifndef PIPECHATCLIENT_H
#define PIPECHATCLIENT_H

#include <QTcpSocket>

#include "pipechatmessagemodel.h"

class PipeChatClient : public QTcpSocket
{
    Q_OBJECT
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QStringList userlist READ userlist WRITE setUserlist NOTIFY userlistChanged)

    enum SystemMsg {
        smNONE,
        smJOIN,
        smUSERS
    };

    static const QStringList SYSTEM_MSGS; // Keywords indicating various system messages

    QString m_Username;
    QStringList m_Userlist;

public:
    PipeChatClient();
    virtual ~PipeChatClient();
    Q_INVOKABLE virtual void connectToHost(const QString &hostName,
                               quint16 port,
                               OpenMode openMode = ReadWrite,
                               NetworkLayerProtocol protocol = AnyIPProtocol);
    Q_INVOKABLE virtual void disconnectFromHost();
    Q_INVOKABLE qint64 write(const char *data);
    Q_INVOKABLE void sendMessage(const QString &msg);
    void setUsername(const QString &username) {
        if (username != m_Username) {
            m_Username = username;
            emit usernameChanged();
        }
    }
    QString username() const {
        return m_Username;
    }

    void setUserlist(const QStringList &userlist) {
        if (userlist != m_Userlist) {
            m_Userlist = userlist;
            emit userlistChanged();
        }
    }
    QStringList userlist() const {
        return m_Userlist;
    }

private:
    void processSendMessage(const QString &msg);
    void sendSystemMessage(const QString &msg);
    void sendSystemMessage(SystemMsg sysMsg);
    SystemMsg parseSystemMessage(const QString &msg);
    void processSystemMessage(SystemMsg sysMsg, QString &msg);

private slots:
    void onConnected();
    void onReadyRead();

signals:
    void usernameChanged();
    void userlistChanged();
    void messageArrived(const QString &msg);
};

#endif // PIPECHATCLIENT_H
