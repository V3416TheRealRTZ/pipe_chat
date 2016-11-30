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

    static const QString SYSTEM_MSGS[]; // Keywords indicating various system messages

    QString username;
    QStringList userlist;
public:
    PipeChatClient();
    virtual ~PipeChatClient();
    Q_INVOKABLE virtual void connectToHost(const QString &hostName,
                               quint16 port,
                               OpenMode openMode = ReadWrite,
                               NetworkLayerProtocol protocol = AnyIPProtocol);
   // void appendMessage(const QString &message);
private slots:
    void onReadyRead();
    void onConnected();
};

#endif // PIPECHATCLIENT_H
