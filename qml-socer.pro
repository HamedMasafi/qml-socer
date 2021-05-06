TEMPLATE = app

QT += core gui widgets qml quick
CONFIG += c++11

SOURCES += main.cpp \
    units.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Tooj plugin init
TOOJ_MODULES=game
#TOOJ_PLUGINS=cafebazaar notification fontawesome bfonts share
TOOJ_FONTS=fontawesome BYekan
TOOJ_BFONTS=BYekan

# Default rules for deployment.
include(deployment.pri)
include(qml-box2d/box2d-static.pri)
#include(../ToojFramework/tooj-toolkit.pri)
DISTFILES += \
    ScaleArea.qml

HEADERS += \
    units.h
