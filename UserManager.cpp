#include "UserManager.h"

#include <QDir>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QStandardPaths>
#include <QDebug>

namespace {

QString databasePath()
{
    const QString dir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dir);
    return dir + QStringLiteral("/turista.db");
}

}

UserManager::UserManager(QObject *parent)
    : QObject(parent)
{
    QSqlDatabase db = QSqlDatabase::addDatabase(QStringLiteral("QSQLITE"));
    db.setDatabaseName(databasePath());

    if (!db.open()) {
        qWarning() << "Failed to open user database:" << db.lastError().text();
        return;
    }

    QSqlQuery query;
    if (!query.exec(QStringLiteral(
            "CREATE TABLE IF NOT EXISTS users ("
            "username TEXT PRIMARY KEY,"
            "password TEXT NOT NULL"
            ")"))) {
        qWarning() << "Failed to create users table:" << query.lastError().text();
    }
}

bool UserManager::registerUser(const QString &username, const QString &password)
{
    QSqlQuery check;
    check.prepare(QStringLiteral("SELECT 1 FROM users WHERE username = ?"));
    check.addBindValue(username);
    if (!check.exec() || check.next())
        return false;

    QSqlQuery insert;
    insert.prepare(QStringLiteral("INSERT INTO users (username, password) VALUES (?, ?)"));
    insert.addBindValue(username);
    insert.addBindValue(password);
    return insert.exec();
}

bool UserManager::authenticate(const QString &username, const QString &password)
{
    QSqlQuery query;
    query.prepare(QStringLiteral("SELECT 1 FROM users WHERE username = ? AND password = ?"));
    query.addBindValue(username);
    query.addBindValue(password);
    if (!query.exec())
        return false;
    return query.next();
}
