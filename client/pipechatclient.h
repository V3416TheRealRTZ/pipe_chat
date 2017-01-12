#ifndef PIPECHATCLIENT_H
#define PIPECHATCLIENT_H

#include <QTcpSocket>
#include <QColor>

#include "pipechatmessagemodel.h"

class User : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QColor usercolor READ usercolor WRITE setUsercolor NOTIFY usercolorChanged)

    QString m_Username;
    QColor m_Usercolor;

public:
    User(const QString &name, const QColor &color) : m_Username(name), m_Usercolor(color) {}
    void setUsername(const QString &username) {
        if (username != m_Username) {
            m_Username = username;
            emit usernameChanged();
        }
    }
    QString username() const {
        return m_Username;
    }
    QColor usercolor() const {
        return m_Usercolor;
    }

    void setUsercolor(const QColor &usercolor) {
        if (usercolor != m_Usercolor) {
            m_Usercolor = usercolor;
            emit usercolorChanged();
        }
    }
signals:
    void usernameChanged();
    void usercolorChanged();
};

class PipeChatClient : public QTcpSocket
{
    Q_OBJECT
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QList<QObject *> userlist READ userlist WRITE setUserlist NOTIFY userlistChanged)

    enum SystemMsg {
        smNONE,
        smJOIN,
        smUSERS,
        smFATAL
    };

    static const QStringList SYSTEM_MSGS; // Keywords indicating various system messages

    QString m_Username;
    QList<QObject *> m_Userlist;

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

    void setUserlist(const QList<QObject *> &userlist) {
        if (userlist != m_Userlist) {
            for(auto i : m_Userlist)
                delete i;
            m_Userlist = userlist;
            emit userlistChanged();
        }
    }
    QList<QObject *> userlist() const {
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
    void fatalError(const QString &err);
};

#endif // PIPECHATCLIENT_H
