#ifndef USER_H
#define USER_H

#include <QObject>
#include <QString>
#include <qqmlintegration.h>

class User : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(double budget READ budget WRITE setBudget NOTIFY budgetChanged)

public:
    explicit User(QObject *parent = nullptr);

    QString username() const;
    void setUsername(const QString &username);

    QString password() const;
    void setPassword(const QString &password);

    double budget() const;
    void setBudget(double budget);

signals:
    void usernameChanged();
    void passwordChanged();
    void budgetChanged();

private:
    QString m_username;
    QString m_password;
    double m_budget = 0.0;
};

#endif // USER_H
