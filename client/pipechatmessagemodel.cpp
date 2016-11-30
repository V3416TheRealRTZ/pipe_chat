#include "pipechatmessagemodel.h"
#include <QDebug>
#include <QDateTime>

PipeChatMessageModel::PipeChatMessageModel(QObject *parent)
    : QAbstractListModel(parent)
{
    addMessage( "Kappa", QDateTime::currentDateTime().toString(), "Welcome to the show." );
    addMessage( "PogChamp", QDateTime::currentDateTime().toString(), "TI WINNER LUL" );
    addMessage( "LUL", QDateTime::currentDateTime().toString(), "CS LUL" );
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

    if(role < Qt::UserRole) {
        qDebug() << "Unknown UserRole " << role;
        return QVariant();
    }

    return m_Messages[index.row()][role - Qt::UserRole];
}

bool PipeChatMessageModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value) {
        m_Messages[index.row()][role - Qt::UserRole] = value.toString();
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

void PipeChatMessageModel::addMessage(const QString &author, const QString &timestamp, const QString &text)
{
    insertRow(0);
    setData(QAbstractItemModel::createIndex(0, AUTHOR), author, AUTHOR);
    setData(QAbstractItemModel::createIndex(0, TIMESTAMP), timestamp, TIMESTAMP);
    setData(QAbstractItemModel::createIndex(0, TEXT), text, TEXT);
}
