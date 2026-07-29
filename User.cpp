#include "User.h"

User::User(QObject *parent)
    : QObject(parent)
{
}

QString User::username() const
{
    return m_username;
}

void User::setUsername(const QString &username)
{
    if (m_username == username)
        return;

    m_username = username;
    emit usernameChanged();
}

QString User::password() const
{
    return m_password;
}

void User::setPassword(const QString &password)
{
    if (m_password == password)
        return;

    m_password = password;
    emit passwordChanged();
}

double User::budget() const
{
    return m_budget;
}

void User::setBudget(double budget)
{
    if (m_budget == budget)
        return;

    m_budget = budget;
    emit budgetChanged();
}
