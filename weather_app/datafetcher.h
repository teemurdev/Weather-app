#ifndef DATAFETCHER_H
#define DATAFETCHER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

// This class handles network requests
class DataFetcher : public QObject {
    Q_OBJECT

public:
    explicit DataFetcher(QObject *parent = nullptr);

    // Callable from QML to start fetching weather data
    Q_INVOKABLE void fetchWeather(const QString &place);

signals:
    // Emits current weather data payload
    void currentDataReady(const QVariantMap &payload);

    // Emits forecast data payload
    void forecastDataReady(const QVariantMap &payload);

    // Emits error messages
    void errorOccurred(const QString &errorString);

private slots:
    // Handles the network reply
    void onFinished(QNetworkReply *reply);

private:
    // Builds the HTTP request and sends it
    void buildAndSendRequest(const QString &place);

    // Manages network operations
    QNetworkAccessManager manager_;

    // Field names in same order they will appear in parsed data
    const QStringList fieldNames_ = {
        "WeatherSymbol", "Temperature", "PrecipitationAmount",
        "WindDirection", "WindSpeed", "WindGust", "Humidity", "TotalCloudCover"
    };
};

#endif // DATAFETCHER_H
