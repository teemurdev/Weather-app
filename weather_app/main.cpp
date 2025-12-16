#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>
#include "datafetcher.h"

int main(int argc, char *argv[])
{
    // Create the main application object for application
    QGuiApplication app(argc, argv);

    // Register the C++ class DataFetcher as a QML type
    qmlRegisterType<DataFetcher>("weather_app", 1, 0, "DataFetcher");

    // Create the QML application engine
    QQmlApplicationEngine engine;

    // Connect the engine's object creation failure signal
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // Load the QML module "weather_app" and the main QML file "Main"
    engine.loadFromModule("weather_app", "Main");

    // Start the application.
    return app.exec();
}
