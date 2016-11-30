#ifndef PIPECHATMESSAGEMODEL_H
#define PIPECHATMESSAGEMODEL_H

#include <QAbstractListModel>

enum PipeChatMessageRoleNames {
    AUTHOR = Qt::UserRole,
    TIMESTAMP,
    TEXT
};

class PipeChatMessageModel : public QAbstractListModel
{
    Q_OBJECT

    QVector<QStringList> m_Messages;

public:
    explicit PipeChatMessageModel(QObject *parent = 0);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    // Add data:
    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;

    // Remove data:
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;

    virtual QHash<int, QByteArray> roleNames() const;

    void addMessage(const QString &author, const QString &timestamp, const QString &text);

};

#endif // PIPECHATMESSAGEMODEL_H
