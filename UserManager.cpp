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
    if (!query.exec(QStringLiteral(
            "CREATE TABLE IF NOT EXISTS favorites ("
            "username TEXT NOT NULL,"
            "id TEXT NOT NULL,"
            "title TEXT,"
            "category TEXT,"
            "location TEXT,"
            "date TEXT,"
            "price TEXT,"
            "description TEXT,"
            "imageUrl TEXT,"
            "source TEXT,"
            "url TEXT,"
            "rating REAL,"
            "PRIMARY KEY (username, id)"
            ")"))) {
        qWarning() << "Failed to create favorites table:" << query.lastError().text();
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

bool UserManager::addFavorite(const QString &username, const QString &id, const QString &title,
                              const QString &category, const QString &location, const QString &date,
                              const QString &price, const QString &description, const QString &imageUrl,
                              const QString &source, const QString &url, double rating)
{
    QSqlQuery insert;
    insert.prepare(QStringLiteral(
        "INSERT OR REPLACE INTO favorites "
        "(username, id, title, category, location, date, price, description, imageUrl, source, url, rating) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"));
    insert.addBindValue(username);
    insert.addBindValue(id);
    insert.addBindValue(title);
    insert.addBindValue(category);
    insert.addBindValue(location);
    insert.addBindValue(date);
    insert.addBindValue(price);
    insert.addBindValue(description);
    insert.addBindValue(imageUrl);
    insert.addBindValue(source);
    insert.addBindValue(url);
    insert.addBindValue(rating);
    return insert.exec();
}

bool UserManager::removeFavorite(const QString &username, const QString &id)
{
    QSqlQuery remove;
    remove.prepare(QStringLiteral("DELETE FROM favorites WHERE username = ? AND id = ?"));
    remove.addBindValue(username);
    remove.addBindValue(id);
    return remove.exec();
}

QVariantList UserManager::getFavorites(const QString &username)
{
    QVariantList results;
    QSqlQuery query;
    query.prepare(QStringLiteral("SELECT id, title, category, location, date, price, description, imageUrl, source, url, rating FROM favorites WHERE username = ?"));
    query.addBindValue(username);
    if (!query.exec())
        return results;

    while (query.next()) {
        QVariantMap item;
        item["id"] = query.value(0);
        item["title"] = query.value(1);
        item["category"] = query.value(2);
        item["location"] = query.value(3);
        item["date"] = query.value(4);
        item["price"] = query.value(5);
        item["description"] = query.value(6);
        item["imageUrl"] = query.value(7);
        item["source"] = query.value(8);
        item["url"] = query.value(9);
        item["rating"] = query.value(10);
        results.append(item);
    }
    return results;
}