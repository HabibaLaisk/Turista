#include "ApiService.h"

#include <QDateTime>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QTime>
#include <QUrl>
#include <QUrlQuery>
#include <QTimeZone>

ApiService::ApiService(QObject *parent)
    : QObject(parent),
    networkManager(new QNetworkAccessManager(this))
{
}

void ApiService::search(
    const QString &city,
    const QString &startDateText,
    const QString &endDateText,
    double budget,
    const QString &category)
{
    if (city.trimmed().isEmpty()) {
        emit searchFailed("Please enter a city.");
        return;
    }

    const QDate startDate =
        QDate::fromString(startDateText.trimmed(), "yyyy-MM-dd");

    const QDate endDate =
        QDate::fromString(endDateText.trimmed(), "yyyy-MM-dd");

    if (!startDate.isValid() || !endDate.isValid()) {
        emit searchFailed(
            "Enter dates using YYYY-MM-DD, such as 2026-08-10.");
        return;
    }

    if (endDate < startDate) {
        emit searchFailed(
            "The departure date cannot be before the arrival date.");
        return;
    }

    combinedResults.clear();
    requestErrors.clear();
    pendingRequests = 2;

    emit searchStarted();

    searchTicketmaster(
        city,
        startDate,
        endDate,
        budget,
        category
        );

    searchYelp(
        city,
        budget,
        category
        );
}

void ApiService::searchTicketmaster(
    const QString &city,
    const QDate &startDate,
    const QDate &endDate,
    double budget,
    const QString &category)
{
    const QString apiKey =
        qEnvironmentVariable("TICKETMASTER_API_KEY").trimmed();

    if (apiKey.isEmpty()) {
        requestErrors.append(
            "Ticketmaster API key is missing.");
        finishRequest();
        return;
    }

    QUrl url("https://app.ticketmaster.com/discovery/v2/events.json");
    QUrlQuery query;

    query.addQueryItem("apikey", apiKey);
    query.addQueryItem("city", city.trimmed());
    query.addQueryItem("size", "20");
    query.addQueryItem("sort", "date,asc");

    const QDateTime startDateTime(
        startDate,
        QTime(0, 0, 0),
        QTimeZone::UTC);

    const QDateTime endDateTime(
        endDate,
        QTime(23, 59, 59),
        QTimeZone::UTC);

    query.addQueryItem(
        "startDateTime",
        startDateTime.toString(Qt::ISODate));

    query.addQueryItem(
        "endDateTime",
        endDateTime.toString(Qt::ISODate));

    if (!category.trimmed().isEmpty()
        && category.compare("All", Qt::CaseInsensitive) != 0) {
        query.addQueryItem("classificationName", category.trimmed());
    }

    url.setQuery(query);

    QNetworkRequest request(url);
    request.setHeader(
        QNetworkRequest::UserAgentHeader,
        "Turista-CS370/1.0");

    QNetworkReply *reply = networkManager->get(request);

    connect(
        reply,
        &QNetworkReply::finished,
        this,
        [this, reply, budget]()
        {
            if (reply->error() != QNetworkReply::NoError) {
                requestErrors.append(
                    "Ticketmaster request failed: "
                    + reply->errorString());

                reply->deleteLater();
                finishRequest();
                return;
            }

            QJsonParseError parseError;
            const QJsonDocument document =
                QJsonDocument::fromJson(
                    reply->readAll(),
                    &parseError);

            if (parseError.error != QJsonParseError::NoError
                || !document.isObject()) {
                requestErrors.append(
                    "Ticketmaster returned invalid data.");

                reply->deleteLater();
                finishRequest();
                return;
            }

            const QJsonObject root = document.object();
            const QJsonArray events =
                root.value("_embedded")
                    .toObject()
                    .value("events")
                    .toArray();

            for (const QJsonValue &eventValue : events) {
                const QJsonObject event = eventValue.toObject();

                SearchResult result;
                result.id = event.value("id").toString();
                result.title = event.value("name").toString();
                result.source = "Ticketmaster";
                result.url = event.value("url").toString();

                const QJsonArray classifications =
                    event.value("classifications").toArray();

                if (!classifications.isEmpty()) {
                    result.category =
                        classifications.first()
                            .toObject()
                            .value("segment")
                            .toObject()
                            .value("name")
                            .toString();
                }

                const QJsonObject dates =
                    event.value("dates").toObject();

                const QJsonObject start =
                    dates.value("start").toObject();

                const QString localDate =
                    start.value("localDate").toString();

                const QString localTime =
                    start.value("localTime").toString();

                result.date = localDate;

                if (!localTime.isEmpty()) {
                    result.date += " " + localTime;
                }

                const QJsonArray venues =
                    event.value("_embedded")
                        .toObject()
                        .value("venues")
                        .toArray();

                if (!venues.isEmpty()) {
                    const QJsonObject venue =
                        venues.first().toObject();

                    const QString venueName =
                        venue.value("name").toString();

                    const QString venueCity =
                        venue.value("city")
                            .toObject()
                            .value("name")
                            .toString();

                    const QString state =
                        venue.value("state")
                            .toObject()
                            .value("stateCode")
                            .toString();

                    result.location = venueName;

                    if (!venueCity.isEmpty()) {
                        result.location += ", " + venueCity;
                    }

                    if (!state.isEmpty()) {
                        result.location += ", " + state;
                    }
                }

                const QJsonArray priceRanges =
                    event.value("priceRanges").toArray();

                if (!priceRanges.isEmpty()) {
                    const QJsonObject priceRange =
                        priceRanges.first().toObject();

                    const double minimum =
                        priceRange.value("min").toDouble();

                    const double maximum =
                        priceRange.value("max").toDouble();

                    if (budget > 0.0 && minimum > budget) {
                        continue;
                    }

                    result.price =
                        QString("$%1 - $%2")
                            .arg(minimum, 0, 'f', 2)
                            .arg(maximum, 0, 'f', 2);
                } else {
                    result.price = "Price unavailable";
                }

                result.description =
                    event.value("info").toString();

                if (result.description.isEmpty()) {
                    result.description =
                        event.value("pleaseNote").toString();
                }

                const QJsonArray images =
                    event.value("images").toArray();

                if (!images.isEmpty()) {
                    result.imageUrl =
                        images.first()
                            .toObject()
                            .value("url")
                            .toString();
                }

                addResult(result);
            }

            reply->deleteLater();
            finishRequest();
        });
}

void ApiService::searchYelp(
    const QString &city,
    double budget,
    const QString &category)
{
    const QString apiKey =
        qEnvironmentVariable("YELP_API_KEY").trimmed();

    if (apiKey.isEmpty()) {
        requestErrors.append("Yelp API key is missing.");
        finishRequest();
        return;
    }

    QUrl url("https://api.yelp.com/v3/businesses/search");
    QUrlQuery query;

    query.addQueryItem("location", city.trimmed());
    query.addQueryItem("limit", "20");
    query.addQueryItem("sort_by", "best_match");

    QString searchTerm = category.trimmed();

    if (searchTerm.isEmpty()
        || searchTerm.compare("All", Qt::CaseInsensitive) == 0) {
        searchTerm = "restaurants attractions";
    }

    query.addQueryItem("term", searchTerm);

    // Yelp uses price levels rather than exact dollar budgets.
    // 1=$, 2=$$, 3=$$$, 4=$$$$
    if (budget > 0 && budget <= 25) {
        query.addQueryItem("price", "1");
    } else if (budget <= 60) {
        query.addQueryItem("price", "1,2");
    } else if (budget <= 120) {
        query.addQueryItem("price", "1,2,3");
    } else if (budget > 120) {
        query.addQueryItem("price", "1,2,3,4");
    }

    url.setQuery(query);

    QNetworkRequest request(url);
    request.setRawHeader(
        "Authorization",
        QByteArray("Bearer ") + apiKey.toUtf8());
    request.setRawHeader("accept", "application/json");

    QNetworkReply *reply = networkManager->get(request);

    connect(
        reply,
        &QNetworkReply::finished,
        this,
        [this, reply]()
        {
            if (reply->error() != QNetworkReply::NoError) {
                requestErrors.append(
                    "Yelp request failed: "
                    + reply->errorString());

                reply->deleteLater();
                finishRequest();
                return;
            }

            QJsonParseError parseError;
            const QJsonDocument document =
                QJsonDocument::fromJson(
                    reply->readAll(),
                    &parseError);

            if (parseError.error != QJsonParseError::NoError
                || !document.isObject()) {
                requestErrors.append(
                    "Yelp returned invalid data.");

                reply->deleteLater();
                finishRequest();
                return;
            }

            const QJsonArray businesses =
                document.object()
                    .value("businesses")
                    .toArray();

            for (const QJsonValue &businessValue : businesses) {
                const QJsonObject business =
                    businessValue.toObject();

                SearchResult result;

                result.id = business.value("id").toString();
                result.title = business.value("name").toString();
                result.source = "Yelp";
                result.url = business.value("url").toString();
                result.imageUrl =
                    business.value("image_url").toString();
                result.rating =
                    business.value("rating").toDouble();
                result.price =
                    business.value("price").toString();

                if (result.price.isEmpty()) {
                    result.price = "Price unavailable";
                }

                const QJsonArray categories =
                    business.value("categories").toArray();

                if (!categories.isEmpty()) {
                    result.category =
                        categories.first()
                            .toObject()
                            .value("title")
                            .toString();
                }

                const QJsonObject location =
                    business.value("location").toObject();

                const QJsonArray displayAddress =
                    location.value("display_address").toArray();

                QStringList addressParts;

                for (const QJsonValue &addressValue
                     : displayAddress) {
                    addressParts.append(
                        addressValue.toString());
                }

                result.location =
                    addressParts.join(", ");

                const int reviewCount =
                    business.value("review_count").toInt();

                result.description =
                    QString("Rating: %1/5 from %2 reviews")
                        .arg(result.rating, 0, 'f', 1)
                        .arg(reviewCount);

                addResult(result);
            }

            reply->deleteLater();
            finishRequest();
        });
}

QVariantMap ApiService::resultToVariantMap(
    const SearchResult &result) const
{
    QVariantMap map;

    map["id"] = result.id;
    map["title"] = result.title;
    map["category"] = result.category;
    map["location"] = result.location;
    map["date"] = result.date;
    map["price"] = result.price;
    map["description"] = result.description;
    map["imageUrl"] = result.imageUrl;
    map["source"] = result.source;
    map["url"] = result.url;
    map["rating"] = result.rating;

    return map;
}

void ApiService::addResult(const SearchResult &result)
{
    combinedResults.append(resultToVariantMap(result));
}

void ApiService::finishRequest()
{
    pendingRequests--;

    if (pendingRequests > 0) {
        return;
    }

    if (!combinedResults.isEmpty()) {
        emit resultsReady(combinedResults);
        return;
    }

    if (!requestErrors.isEmpty()) {
        emit searchFailed(requestErrors.join("\n"));
        return;
    }

    emit searchFailed("No results were found.");
}