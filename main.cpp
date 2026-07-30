#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "services/ApiService.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    ApiService apiService;
    engine.rootContext()->setContextProperty("apiService", &apiService);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Turista", "Main");

    return QGuiApplication::exec();
}
