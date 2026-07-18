#pragma once

#include <QObject>
#include <QDate>
#include <QList>
#include <QNetworkAccessManager>

#include "../models/SearchResult.h"

class ApiService : public QObject
{
    Q_OBJECT

public:
    explicit ApiService(QObject* parent = nullptr);

    void search(
        const QString& city,
        const QDate& startDate,
        const QDate& endDate,
        double budget,
        const QString& category
    );

signals:
    void searchStarted();
    void resultsReady(const QList<SearchResult>& results);
    void searchFailed(const QString& message);

private:
    void searchTicketmaster(
        const QString& city,
        const QDate& startDate,
        const QDate& endDate,
        double budget,
        const QString& category
    );

    void searchYelp(
        const QString& city,
        double budget,
        const QString& category
    );

    QNetworkAccessManager* networkManager;
};

