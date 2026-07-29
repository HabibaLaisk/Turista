#ifndef USERMANAGER_H
#define USERMANAGER_H

#include <QObject>
#include <QString>
#include <qqmlintegration.h>

class UserManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit UserManager(QObject *parent = nullptr);

    Q_INVOKABLE bool registerUser(const QString &username, const QString &password);
    Q_INVOKABLE bool authenticate(const QString &username, const QString &password);
};

#endif // USERMANAGER_H
