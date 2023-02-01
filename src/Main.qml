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

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as Controls
import org.kde.kirigami 2.19 as Kirigami

Kirigami.ApplicationWindow {
    id: root

    property bool french: true
    property bool yds: true
    property bool uiaa: true

    minimumWidth: Kirigami.Units.gridUnit * 15
    minimumHeight: Kirigami.Units.gridUnit * 20

    pageStack {
        defaultColumnWidth: Kirigami.Units.gridUnit * 30
        globalToolBar {
            canContainHandles: true
            style: Kirigami.ApplicationHeaderStyle.ToolBar
            showNavigationButtons: applicationWindow().pageStack.currentIndex > 0 ? Kirigami.ApplicationHeaderStyle.ShowBackButton : 0
        }
    }

    globalDrawer: Kirigami.OverlayDrawer {
        id: drawer

        edge: Qt.application.layoutDirection === Qt.RightToLeft ? Qt.RightEdge : Qt.LeftEdge
        modal: Kirigami.Settings.isMobile || (applicationWindow().width < Kirigami.Units.gridUnit * 50 && !collapsed) // Only modal when not collapsed, otherwise collapsed won't show.
        z: modal ? Math.round(position * 10000000) : 100
        drawerOpen: !Kirigami.Settings.isMobile && enabled
        width: Kirigami.Units.gridUnit * 16
        Behavior on width {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
        Kirigami.Theme.colorSet: Kirigami.Theme.Window

        handleClosedIcon.source: modal ? null : "sidebar-expand-left"
        handleOpenIcon.source: modal ? null : "sidebar-collapse-left"
        handleVisible: modal

        onModalChanged: if (!modal) {
            drawerOpen = true;
        }

        leftPadding: 0
        rightPadding: 0
        topPadding: 0
        bottomPadding: 0

        contentItem: ColumnLayout {
            Controls.ToolBar {
                Layout.fillWidth: true
                Layout.preferredHeight: pageStack.globalToolBar.preferredHeight

                leftPadding: 3
                rightPadding: 3
                topPadding: 3
                bottomPadding: 3

                contentItem: Kirigami.Heading {
                    text: qsTr("Klimbgrades")
                }
            }
            Kirigami.Heading {
                text: qsTr("Lead")
                level: 2
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing
            }
            Kirigami.Separator {
                Layout.fillWidth: true
            }
            Repeater {
                model: dataStore.availableLeadModel
                delegate: Controls.CheckDelegate {
                    required property int index
                    required property string name

                    Layout.fillWidth: true
                    text: name
                    checkState: enabled ? Qt.Checked : Qt.Unchecked
                    onCheckStateChanged: dataStore.availableLeadModel.setScaleEnabled(index, checkState == Qt.Checked)
                }
            }
            Kirigami.Heading {
                text: qsTr("Boulder")
                level: 2
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing
            }
            Kirigami.Separator {
                Layout.fillWidth: true
            }
            Repeater {
                model: dataStore.availableBoulderModel
                delegate: Controls.CheckDelegate {
                    required property int index
                    required property string name

                    Layout.fillWidth: true
                    text: name
                    checkState: enabled ? Qt.Checked : Qt.Unchecked
                    onCheckStateChanged: dataStore.availableBoulderModel.setScaleEnabled(index, checkState == Qt.Checked)
                }
            }
            Kirigami.Separator {
                Layout.fillWidth: true
            }
            Controls.SwitchDelegate {
                Layout.fillWidth: true
                text: qsTr("Link Lead and Boulder")
                checked: dataStore.leadAndBoulderLinked
                onCheckedChanged: dataStore.leadAndBoulderLinked = checked
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }

    pageStack.initialPage: Global {
        leadModel: dataStore.availableLeadModel
        boulderModel: dataStore.availableBoulderModel
    }

    Connections {
        target: dataStore.availableLeadModel
        function onCurrentGradeChanged() {
            if (dataStore.leadAndBoulderLinked) {
                dataStore.availableBoulderModel.currentGrade = dataStore.availableLeadModel.currentGrade;
            }
        }
    }

    Connections {
        target: dataStore.availableBoulderModel
        function onCurrentGradeChanged() {
            if (dataStore.leadAndBoulderLinked) {
                dataStore.availableLeadModel.currentGrade = dataStore.availableBoulderModel.currentGrade;
            }
        }
    }
}
