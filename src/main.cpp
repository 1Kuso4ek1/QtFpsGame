#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char* argv[])
{
    const QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.loadFromModule("FpsGame", "Main");

    return app.exec();
}
