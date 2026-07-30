#pragma once

#include <QObject>
#include <QDate>
#include <QNetworkAccessManager>
#include <QStringList>
#include <QVariantList>
#include <QVariantMap>

#include "../models/SearchResult.h"

class ApiService : public QObject
{
    Q_OBJECT

public:
    explicit ApiService(QObject *parent = nullptr);

    Q_INVOKABLE void search(
        const QString &city,
        const QString &startDateText,
        const QString &endDateText,
        double budget,
        const QString &category
        );

signals:
    void searchStarted();
    void resultsReady(const QVariantList &results);
    void searchFailed(const QString &message);

private:
    void searchTicketmaster(
        const QString &city,
        const QDate &startDate,
        const QDate &endDate,
        double budget,
        const QString &category
        );

    void searchYelp(
        const QString &city,
        double budget,
        const QString &category
        );

    QVariantMap resultToVariantMap(const SearchResult &result) const;
    void addResult(const SearchResult &result);
    void finishRequest();

    QNetworkAccessManager *networkManager;

    QVariantList combinedResults;
    QStringList requestErrors;
    int pendingRequests = 0;
};