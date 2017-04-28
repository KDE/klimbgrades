/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>

#include "data.h"
#include "availablegradesmodel.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    //qputenv("QT_QUICK_CONTROLS_STYLE", "Material");
    //TODO: make it selectively a QAplpication or a QGuiApplication with ifdefs
#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
#else
    QApplication app(argc, argv);
#endif
    QCoreApplication::setOrganizationName("KDE");
    QCoreApplication::setOrganizationDomain("kde.org");
    QCoreApplication::setApplicationName("Climbing Grades");

    //qputenv("QML_IMPORT_TRACE", "1");
    qmlRegisterType<AvailableGradesModel>();
    QQmlApplicationEngine engine;

    Data *data = new Data;

    engine.rootContext()->setContextProperty(QLatin1String("dataStore"), data);
    //we want different main files on desktop or mobile
    //very small difference as they as they are subclasses of the same thing
    if (QString::fromLatin1(qgetenv("QT_QUICK_CONTROLS_STYLE")) == QStringLiteral("org.kde.desktop")) {
        engine.load(QUrl(QStringLiteral("qrc:///desktopmain.qml")));
    } else {
        engine.load(QUrl(QStringLiteral("qrc:///mobilemain.qml")));
    }

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    int ret = app.exec();
    delete data;
    return ret;
}
