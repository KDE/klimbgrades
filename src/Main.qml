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
            canContainHandles: !Kirigami.Settings.isMobile
            style: Kirigami.Settings.isMobile ? Kirigami.ApplicationHeaderStyle.Titles : Kirigami.ApplicationHeaderStyle.ToolBar
            showNavigationButtons: false//applicationWindow().pageStack.currentIndex > 0 ? Kirigami.ApplicationHeaderStyle.ShowBackButton : 0
            // HACK: ApplicationHeaderStyle.None doesn't load fabs
            preferredHeight: Kirigami.Settings.isMobile && !root.pageStack.wideMode ? 0 : (Kirigami.Units.gridUnit * 1.8) + Kirigami.Units.smallSpacing * 2
        }
    }

    pageStack.initialPage: [leadPageComponent, boulderPageComponent]

    header: Controls.ToolBar {
        //TODO: make the behavior of abstractapplicationheader sliding away work again
        visible: Kirigami.Settings.isMobile && !root.pageStack.wideMode
        height: visible ? implicitHeight : 0
        contentItem: Kirigami.Heading {
            text: qsTr("Climbing Grades")
        }
    }
    footer: Controls.ToolBar {
        id: bottomNavigation
        //FIXME: Kirigami.NavigationTabBar needs the possibility of setting stuff on either side
        position: Controls.TabBar.Footer
        visible: Kirigami.Settings.isMobile && !root.pageStack.wideMode
        height: visible ? implicitHeight : 0
        Kirigami.Theme.inherit: false
        Kirigami.Theme.colorSet: Kirigami.Theme.Header
        contentItem: RowLayout {
            Item {
                id: leftAnchor
                Layout.preferredWidth: Kirigami.Units.gridUnit * 2
                Layout.preferredHeight: Layout.preferredWidth
                Binding {
                    target: globalDrawer.handle
                    property: "handleAnchor"
                    value: leftAnchor
                    when: bottomNavigation.visible
                }
            }
            Kirigami.NavigationTabBar {
                Layout.fillWidth: true
                background: null
                actions: [
                    Kirigami.Action {
                        text: qsTr("Lead")
                        checked: root.pageStack.currentIndex === 0
                        onTriggered: root.pageStack.currentIndex = 0
                    },
                    Kirigami.Action {
                        text: qsTr("Boulder")
                        checked: root.pageStack.currentIndex === 1
                        onTriggered: root.pageStack.currentIndex = 1
                    }
                ]
            }
            Item {
                id: rightAnchor
                Layout.preferredWidth: Kirigami.Units.gridUnit * 2
                Layout.preferredHeight: Layout.preferredWidth
                Binding {
                    target: contextDrawer.handle
                    property: "handleAnchor"
                    value: rightAnchor
                    when: bottomNavigation.visible
                }
            }
        }
    }
    Component {
        id: leadPageComponent
        Global {
            title: qsTr("Lead")
            model: dataStore.availableLeadModel
            defaultGrade: 45
        }
    }
    Component {
        id: boulderPageComponent
        Global {
            title: qsTr("Boulder")
            model: dataStore.availableBoulderModel
            defaultGrade: 65
        }
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    globalDrawer: Kirigami.OverlayDrawer {
        id: drawer

        edge: Qt.application.layoutDirection === Qt.RightToLeft ? Qt.RightEdge : Qt.LeftEdge
        modal: Kirigami.Settings.isMobile || (applicationWindow().width < Kirigami.Units.gridUnit * 50 && !collapsed) // Only modal when not collapsed, otherwise collapsed won't show.
        z: modal ? Math.round(position * 10000000) : 100
        drawerOpen: !Kirigami.Settings.isMobile && enabled
        width: Kirigami.Units.gridUnit * 16

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
                Layout.preferredHeight: pageStack.globalToolBar.preferredHeight > 0 ? pageStack.globalToolBar.preferredHeight : undefined

                leftPadding: 3
                rightPadding: 3
                topPadding: 3
                bottomPadding: 3

                contentItem: Kirigami.SearchField {
                    id: filterField
                    placeholderText: qsTr("Filter…")
                }
            }
            Kirigami.AbstractListItem {
                Layout.fillWidth: true
                contentItem: Kirigami.Heading {
                    text: qsTr("Lead")
                    level: 2
                    Layout.fillWidth: true
                    Layout.leftMargin: Kirigami.Units.smallSpacing
                    Layout.rightMargin: Kirigami.Units.smallSpacing
                }
                checkable: true
                checked: root.pageStack.currentIndex == 0
                onClicked: {
                    root.pageStack.currentIndex = 0
                }
            }
            Kirigami.Separator {
                Layout.fillWidth: true
            }
            Repeater {
                model: dataStore.availableLeadModel
                delegate: Controls.CheckDelegate {
                    required property int index
                    required property string name

                    visible: name.toUpperCase().indexOf(filterField.text.toUpperCase()) !== -1
                    Layout.fillWidth: true
                    text: name
                    checkState: enabled ? Qt.Checked : Qt.Unchecked
                    onCheckStateChanged: dataStore.availableLeadModel.setScaleEnabled(index, checkState == Qt.Checked)
                }
            }
            Kirigami.AbstractListItem {
                Layout.fillWidth: true
                contentItem: Kirigami.Heading {
                    text: qsTr("Boulder")
                    level: 2
                    Layout.fillWidth: true
                    Layout.leftMargin: Kirigami.Units.smallSpacing
                    Layout.rightMargin: Kirigami.Units.smallSpacing
                }
                checkable: true
                checked: root.pageStack.currentIndex == 1
                onClicked: {
                    root.pageStack.currentIndex = 1
                }
            }
            Kirigami.Separator {
                Layout.fillWidth: true
            }
            Repeater {
                model: dataStore.availableBoulderModel
                delegate: Controls.CheckDelegate {
                    required property int index
                    required property string name

                    visible: name.toUpperCase().indexOf(filterField.text.toUpperCase()) !== -1
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
