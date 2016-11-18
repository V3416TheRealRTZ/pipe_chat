#include "pipechatmessagemodel.h"

PipeChatMessageModel::PipeChatMessageModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int PipeChatMessageModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_Messages.size();
}

QVariant PipeChatMessageModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    //if(role < Qt::UserRole)
    //    return QAbstractListModel::data(index, role);

    return m_Messages[index.row()][Qt::UserRole - role];
}

bool PipeChatMessageModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value) {
        m_Messages[index.row()][Qt::UserRole - role] = value.toString();
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags PipeChatMessageModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

bool PipeChatMessageModel::insertRows(int row, int count, const QModelIndex &parent)
{
    beginInsertRows(parent, row, row + count - 1);
    m_Messages.insert(row, count, QStringList({"", "", ""}));
    endInsertRows();
    return true;
}

bool PipeChatMessageModel::removeRows(int row, int count, const QModelIndex &parent)
{
    beginRemoveRows(parent, row, row + count - 1);
    m_Messages.remove(row, count);
    endRemoveRows();
    return true;
}

QHash<int, QByteArray> PipeChatMessageModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[AUTHOR]    = "author";
    names[TIMESTAMP] = "timestamp";
    names[TEXT]      = "text";
    return names;
}
