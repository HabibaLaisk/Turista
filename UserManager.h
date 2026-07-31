#ifndef USERMANAGER_H
#define USERMANAGER_H
#include <QObject>
#include <QString>
#include <QVariantList>
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

    Q_INVOKABLE bool addFavorite(const QString &username, const QString &id, const QString &title,
                                 const QString &category, const QString &location, const QString &date,
                                 const QString &price, const QString &description, const QString &imageUrl,
                                 const QString &source, const QString &url, double rating);
    Q_INVOKABLE bool removeFavorite(const QString &username, const QString &id);
    Q_INVOKABLE QVariantList getFavorites(const QString &username);
};
#endif // USERMANAGER_H