#include <QtCore/qglobal.h>
#if QT_VERSION >= 0x050000
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#else
#endif
#include <QQmlContext>

#include "units.h"
#include "qml-box2d/box2dplugin.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Box2DPlugin plugin;
    plugin.registerTypes("Box2D");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("units", new Units());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
