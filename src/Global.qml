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
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0 as Controls
import org.kde.kirigami 2.19 as Kirigami

Kirigami.ScrollablePage {
    id: root

    property var model
    property int defaultGrade

    Kirigami.ColumnView.fillWidth: true
    Kirigami.ColumnView.reservedSpace: Kirigami.ColumnView.view.width/2

    //Close the drawer with the back button
    onBackRequested: {
        if (sheet.sheetOpen) {
            event.accepted = true;
            sheet.close();
        }
    }

    actions {
        main: Kirigami.Action {
            iconName: "view-refresh"
            text: qsTr("Reset")
            onTriggered: root.model.currentGrade = root.defaultGrade;
        }
        contextualActions: [
            Kirigami.Action {
                text: qsTr("Set Record")
                tooltip: qsTr("Set Grade As Personal Record")
                iconName: "games-highscores"
                onTriggered: {
                    root.model.personalRecord = root.model.currentGrade;
                }
            },
            Kirigami.Action {
                text: qsTr("Clear")
                tooltip: qsTr("Clear Personal Record")
                iconName: "edit-clear"
                enabled: root.model.personalRecord > 0
                onTriggered: {
                    root.model.personalRecord = 0;
                }
            }
        ]
    }

    Kirigami.OverlaySheet {
        id: sheet
        parent: applicationWindow().overlay
        property alias description: descrLabel.text
        property string url
        ColumnLayout {
            property int implicitWidth: Kirigami.Units.gridUnit * 25
            Controls.Label {
                id: descrLabel
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            Controls.Button {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Source: Wikipedia")
                onClicked: {
                    Qt.openUrlExternally(sheet.url);
                    sheet.close();
                }
            }
        }
    }

    ColumnLayout {
        id: mainLayout
        spacing: 0

        Kirigami.AbstractCard {
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing: 0
                Repeater {
                    id: repeater
                    model: root.model
                    delegate: GradeWidgetBase {
                        page: root
                        availableGradesModel: root.model
                        isLast: index == repeater.count - 1
                    }
                }
            }
        }
    }
}
