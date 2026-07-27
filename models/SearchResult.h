#pragma once

#include <QString>

struct SearchResult
{
    QString id;
    QString title;
    QString category;
    QString location;
    QString date;
    QString price;
    QString description;
    QString imageUrl;
    QString source;
    QString url;
    double rating = 0.0;
};
