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
import QtQuick.Controls 2.0 as Controls
import org.kde.kirigami 2.0 as Kirigami

Kirigami.ScrollablePage {
    id: root

    property alias model: mainRepeater.model
    property int defaultGrade

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
            text: "Reset"
            onTriggered: root.model.currentGrade = root.defaultGrade;
        }
        contextualActions: [
            Kirigami.Action {
                text: "Set Record"
                tooltip: "Set Grade As Personal Record"
                iconName: "games-highscores"
                onTriggered: {
                    root.model.personalRecord = root.model.currentGrade;
                }
            },
            Kirigami.Action {
                text: "Clear"
                tooltip: "Clear Personal Record"
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
            Kirigami.Label {
                id: descrLabel
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            Controls.Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Source: Wikipedia"
                onClicked: {
                    Qt.openUrlExternally(sheet.url);
                    sheet.close();
                }
            }
        }
    }

    Column {
        id: mainLayout
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Kirigami.Units.gridUnit * 2
        Repeater {
            id: mainRepeater
            delegate: GradeWidgetBase {
                page: root
                availableGradesModel: root.model
                anchors.horizontalCenter: parent.horizontalCenter
                visible: model.enabledRole
                scaleName: model.nameRole
                url: model.urlRole
                description: model.descriptionRole
            }
        }
    }
}
