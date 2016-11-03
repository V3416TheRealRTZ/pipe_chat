#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

class QTcpSocket;

class MainWindow : public QMainWindow
{
    Q_OBJECT

    enum SystemMsg {
        smNONE,
        smJOIN,
        smUSERS
    };

    static const QString SYSTEM_MSGS[]; // Keywords indicating various system messages

    QTcpSocket *socket;
    QString username;
    QStringList userlist;

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    void parseSystemMessage(const QString &msg);

private slots:
    void onReadyRead();
    void onConnected();

signals:
    void receivedMessage(const QString &msg);
};

#endif // MAINWINDOW_H
