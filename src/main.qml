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
import QtQuick.Controls 1.2 as Controls
import org.kde.kirigami 1.0 as Kirigami

Kirigami.ApplicationWindow {
    id: root

    property bool french: true
    property bool yds: true
    property bool uiaa: true

    globalDrawer: Kirigami.GlobalDrawer {
        id: drawer
        title: "climbing grades"
        titleIcon: "climbinggrades"
        bannerImageSource: "halfdome.jpg"

        Column {
            anchors {
                left: parent.left
                right: parent.right
            }
            Kirigami.Heading {
                text: "Lead"
            }
            Repeater {
                model: dataStore.availableGradesModel
                delegate: Kirigami.BasicListItem {
                    height: Kirigami.Units.gridUnit * 3
                    Controls.CheckBox {
                        id: checkBox
                        enabled: false
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        checked: model.enabledRole
                    }
                    label: model.nameRole
                    onClicked: {
                        checkBox.checked = !checkBox.checked;
                        dataStore.availableGradesModel.setScaleEnabled(index, checkBox.checked);
                    }
                }
            }
            Kirigami.Heading {
                text: "Boulder"
            }
            Kirigami.Label {
                text: "TODO"
            }
        }
    }
    pageStack.initialPage: mainPageComponent

    Component {
        id: mainPageComponent
        Global {}
    }
}
