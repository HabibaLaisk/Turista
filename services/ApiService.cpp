#include "ApiService.h"

ApiService::ApiService(QObject* parent)
    : QObject(parent)
{
    networkManager = new QNetworkAccessManager(this);
}

void ApiService::search(
    const QString& city,
    const QDate& startDate,
    const QDate& endDate,
    double budget,
    const QString& category)
{
    searchTicketmaster(city, startDate, endDate, budget, category);
    searchYelp(city, budget, category);
}

void ApiService::searchTicketmaster(
    const QString& city,
    const QDate& startDate,
    const QDate& endDate,
    double budget,
    const QString& category)
{
    Q_UNUSED(city)
        Q_UNUSED(startDate)
        Q_UNUSED(endDate)
        Q_UNUSED(budget)
        Q_UNUSED(category)

        //Ticketmaster API implementation will be added here.
}

void ApiService::searchYelp(
    const QString& city,
    double budget,
    const QString& category)
{
    Q_UNUSED(city)
        Q_UNUSED(budget)
        Q_UNUSED(category)

        // Yelp API implementation will be added here.
}

