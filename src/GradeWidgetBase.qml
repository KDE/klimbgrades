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

import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.0 as Kirigami

Rectangle {
    id: root

    color: Kirigami.Theme.viewBackgroundColor
    width: mainLayout.width + Kirigami.Units.gridUnit * 2
    height: mainLayout.height + Kirigami.Units.gridUnit * 2

    property Item page
    property alias scaleName: scaleNameLabel.text
    property string url
    property string description

    function increment() {
        print("Decimal grade: " + dataStore.currentGrade);

        dataStore.currentGrade++;
    }

    function decrement() {
        print("Decimal grade: " + dataStore.currentGrade);
        dataStore.currentGrade = Math.max(0, dataStore.currentGrade - 1);
    }

    function format(decimalGrade) {
        var formattedGrade = dataStore.gradeName(scaleName, decimalGrade);
        if (formattedGrade) {
            return formattedGrade;
        }
        return decimalGrade;
    }

    signal infoClicked

    Column {
        id: mainLayout
        z: 2
        width: Math.max(Kirigami.Units.gridUnit * 8, implicitWidth)
        anchors {
            top: parent.top
            left: parent.left
            margins: Kirigami.Units.gridUnit
        }
        Kirigami.Label {
            id: scaleNameLabel
        }
        RowLayout {
            anchors {
                left: parent.left
                right: parent.right
            }
            IconButton {
                source: "go-previous"
                onClicked: dataStore.currentGrade -= 3;
            }
            Kirigami.Heading {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: format(dataStore.currentGrade);
            }
            IconButton {
                source: "go-next"
                onClicked: dataStore.currentGrade += 3;
            }
        }
    
        RowLayout {
            width: parent.width
            Kirigami.Label {
                Layout.fillWidth: true
                text: page.model.personalRecord > 0 ? ("Record: " + format(page.model.personalRecord)) : "";
            }
            IconButton {
                source: "documentinfo"

                onClicked: {
                    sheet.description = description
                    sheet.url = url
                    sheet.open();
                }
            }
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        property int startX
        preventStealing: true
        onPressed: {
            startX = mouse.x
        }
        onPositionChanged: {
            var change = false;

            if (mouse.x - startX > Kirigami.Units.gridUnit) {
                startX = mouse.x;
                increment();

            } else if (mouse.x - startX < -Kirigami.Units.gridUnit) {
                startX = mouse.x;
                decrement();
            }
        }
    }
    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 0
        radius: Kirigami.Units.gridUnit/1.6
        samples: 32
        color: Qt.rgba(0, 0, 0, 0.5)
    }
}
