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
import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm

Kirigami.ScrollablePage {
    id: root

    required property var leadModel
    required property var boulderModel

    readonly property var model: isLead ? leadModel : boulderModel
    readonly property int defaultGrade: isLead ? 45 : 66

    property bool isLead: true

    leftPadding: 0
    rightPadding: 0

    title: isLead ? qsTr("Lead") : qsTr("Bouldering")

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

    header: Kirigami.NavigationTabBar {
        actions: [
            Kirigami.Action {
                text: qsTr("Lead")
                checked: root.isLead
                onTriggered: root.isLead = true
            },
            Kirigami.Action {
                text: qsTr("Boulder")
                checked: !root.isLead
                onTriggered: root.isLead = false
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

        MobileForm.FormCard {
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing: 0
                Repeater {
                    model: root.model
                    delegate: ColumnLayout {
                        id: gradeDelegate

                        required property string name
                        required property string url
                        required property string description

                        spacing: 0
                        GradeWidgetBase {
                            page: root
                            availableGradesModel: root.model
                            name: gradeDelegate.name
                            url: gradeDelegate.url
                            description: gradeDelegate.description
                        }

                        MobileForm.FormDelegateSeparator {}
                    }
                }
            }
        }
    }
}
