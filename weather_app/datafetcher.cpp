#include "datafetcher.h"
#include <QUrlQuery>
#include <QXmlStreamReader>
#include <QRegularExpression>
#include <QDateTime>
#include <QTimeZone>

DataFetcher::DataFetcher(QObject *parent)
    : QObject(parent)
{
    connect(&manager_, &QNetworkAccessManager::finished,
            this, &DataFetcher::onFinished);
}

void DataFetcher::fetchWeather(const QString &place)
{
    buildAndSendRequest(place);
}

void DataFetcher::buildAndSendRequest(const QString &place)
{
    // Build URL
    QUrl url("https://opendata.fmi.fi/wfs");
    QUrlQuery q;
    q.addQueryItem("service",         "WFS");
    q.addQueryItem("version",         "2.0.0");
    q.addQueryItem("request",         "getFeature");
    q.addQueryItem("storedquery_id",  "fmi::forecast::harmonie::surface::"
                                      "point::multipointcoverage");
    q.addQueryItem("parameters",      "WeatherSymbol3,Temperature,"
                                      "PrecipitationAmount,"
                                      "WindDirection,WindSpeedMS,"
                                      "WindGust,Humidity,TotalCloudCover");
    q.addQueryItem("place",           place);
    url.setQuery(q);

    // qDebug() << url;

    // Send request
    manager_.get(QNetworkRequest(url));
}

void DataFetcher::onFinished(QNetworkReply *reply)
{
    // Network error
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Network error:" << reply->errorString();
        emit errorOccurred(reply->errorString());
        reply->deleteLater();
        return;
    }

    // else{} Parse XML element text and split into individual values
    QByteArray xmlData = reply->readAll();
    QXmlStreamReader xml(xmlData);

    QDateTime time;
    QString place;
    QString rawData;

    // Find data
    while (!xml.atEnd()) {
        xml.readNext();
        // Time data
        if (xml.isStartElement() && xml.name() == "beginPosition") {
            QString utcTimeStr = xml.readElementText();
            QDateTime utcTime = QDateTime::fromString(utcTimeStr, Qt::ISODate);
            time = utcTime.toTimeZone(QTimeZone(QTimeZone::LocalTime));
        }
        // Place data
        if (xml.isStartElement() && xml.name() ==
                "name" && place.isEmpty()) {
            place = xml.readElementText();
        }
        // Weather data
        if (xml.isStartElement() && xml.name() ==
                "doubleOrNilReasonTupleList") {
            rawData = xml.readElementText();
            break;
        }
    }

    // Extract values from data
    static const QRegularExpression whitespacePattern("\\s+");
    QStringList values = rawData.split(whitespacePattern, Qt::SkipEmptyParts);

    int fieldCount = fieldNames_.size();
    QVariantMap forecastData;
    QVariantList todayData;
    QVariantList tomorrowData;
    QVariantList in2DaysData;

    // Produce data for forecast
    for (int i = 0; i + fieldCount <= values.size(); i += fieldCount) {
        QVariantMap row;

        // For every new row, add 1 hour to time
        int hoursOffset = i/fieldCount;
        QDateTime timeStamp = time.addSecs(hoursOffset*60*60);
        QString formattedTimeStamp = timeStamp.toString("HH");
        row["Time"] = formattedTimeStamp;

        // Add field names and values to data
        for (int j = 0; j < fieldCount; ++j) {
            QString label = fieldNames_[j];
            QString value = values[i + j];
            row[label] = value;
        }

        // Group data by day
        if (timeStamp.date() == time.date()) {
            todayData.append(row);
        }
        else if (timeStamp.date() == time.addDays(1).date()) {
            tomorrowData.append(row);
        }
        else if (timeStamp.date() == time.addDays(2).date()) {
            in2DaysData.append(row);
        }
    }

    // Add data from different days to same variable
    forecastData["Today"] = todayData;
    forecastData["Tomorrow"] = tomorrowData;
    forecastData["In2Days"] = in2DaysData;

    // Produces data of current weather
    QVariantMap currentData;
    currentData["Place"] = place;
    for (int j = 0; j < fieldCount; ++j) {
        QString label = fieldNames_[j];
        QString value = values[j];
        currentData[label] = value;
    }

    // Produce data of next 12 h forecast
    for (int i = 3; i <= 12; i += 3) {
        QVariantMap data;

        // Add symbol and temperature values to data
        for (int j = 0; j <= 1; ++j) {
            QString label = fieldNames_[j];
            QString value = values[i * fieldCount + j];
            data[label] = value;
        }
        QString label = "In" + QString::number(i) + "hours";
        currentData[label] = data;
    }

    // Emit signals
    if (xml.hasError()) {
        emit errorOccurred(xml.errorString());
    } else {
        // Signal to QML
        emit currentDataReady(currentData);
        emit forecastDataReady(forecastData);
    }

    reply->deleteLater();
}
