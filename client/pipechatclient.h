#ifndef PIPECHATCLIENT_H
#define PIPECHATCLIENT_H

#include <QTcpSocket>

#include "pipechatmessagemodel.h"

class PipeChatClient : public QTcpSocket
{
    Q_OBJECT

    enum SystemMsg {
        smNONE,
        smJOIN,
        smUSERS
    };

    PipeChatMessageModel m_Model;

    static const QString SYSTEM_MSGS[]; // Keywords indicating various system messages

    QString username;
    QStringList userlist;
public:
    PipeChatClient();
    void appendMessage(const QString &message);
};

#endif // PIPECHATCLIENT_H
