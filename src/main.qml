/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
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

import QtQuick 2.1
import org.kde.kirigami 1.0 as Kirigami

Kirigami.ApplicationWindow {
    id: root

    property bool french: true
    property bool yds: true

    globalDrawer: Kirigami.GlobalDrawer {
        title: "climbing grades"
        titleIcon: "kruler"
        bannerImageSource: "halfdome.jpg"

        actions: [
            Kirigami.Action {
                text: "French"
                checkable: true
                checked: true
                onCheckedChanged: root.french = checked;
            },
            Kirigami.Action {
                text: "YDS"
                checkable: true
                checked: true
                onCheckedChanged: root.yds = checked;
            }
        ]
    }
    pageStack.initialPage: mainPageComponent

    Component {
        id: mainPageComponent
        Global {}
    }
}
