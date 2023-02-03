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
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.19 as Kirigami
import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm
import "HeuristicConverter.js" as HeuristicConverter

MobileForm.AbstractFormDelegate {
    id: root

    property Item page
    required property QtObject availableGradesModel
    required property string name
    required property string url
    required property string description
    required property bool scaleEnabled

    visible: scaleEnabled
    background: null

    function increment() {
        print("Decimal grade: " + availableGradesModel.currentGrade);

        availableGradesModel.currentGrade++;
    }

    function decrement() {
        print("Decimal grade: " + availableGradesModel.currentGrade);
        availableGradesModel.currentGrade = Math.max(0, availableGradesModel.currentGrade - 1);
    }

    function format(decimalGrade) {
        var formattedGrade = dataStore.gradeName(root.name, decimalGrade);
        if (formattedGrade) {
            return formattedGrade;
        }
        var func = HeuristicConverter["format"+root.name.replace(/\s+/g, '')]
        if (func) {
            return func(decimalGrade);
        }
        return "--";
    }

    signal infoClicked

    contentItem: ColumnLayout {
        Kirigami.Heading {
            Layout.alignment: Qt.AlignHCenter
            level: 2
            text: root.name
        }
        RowLayout {
            Layout.fillWidth: true
            Controls.ToolButton {
                icon.name: "go-previous"
                onClicked: availableGradesModel.currentGrade -= 2;
            }
            Kirigami.Heading {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: availableGradesModel.currentGrade <= 100 ? Kirigami.Theme.textColor : "red"
                text: format(availableGradesModel.currentGrade);
            }
            Controls.ToolButton {
                icon.name: "go-next"
                onClicked: availableGradesModel.currentGrade += 2;
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Controls.Label {
                Layout.fillWidth: true
                text: page.model.personalRecord > 0 ? (qsTr("Record: ") + format(page.model.personalRecord)) : "";
            }
            Controls.ToolButton {
                icon.name: "documentinfo"

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
}
