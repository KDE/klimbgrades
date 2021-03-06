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
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0 as Controls
import org.kde.kirigami 2.0 as Kirigami

Kirigami.ApplicationWindow {
    id: root

    property bool french: true
    property bool yds: true
    property bool uiaa: true

    globalDrawer: Kirigami.GlobalDrawer {
        id: drawer
        title: "Klimbgrades"
        titleIcon: "klimbgrades"
        bannerImageSource: "halfdome.jpg"
        contentItem.implicitWidth: Math.min (Kirigami.Units.gridUnit * 15, root.width * 0.8)

        topContent: Column {
            anchors {
                left: parent.left
                right: parent.right
                margins: -Kirigami.Units.smallSpacing
            }
            Kirigami.Heading {
                text: qsTr("Lead")
                anchors {
                    left: parent.left
                    margins: Kirigami.Units.smallSpacing
                }
            }
            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                color: Kirigami.Theme.textColor
                opacity: 0.2
                height: Math.floor(Kirigami.Units.devicePixelRatio)
            }
            Repeater {
                model: dataStore.availableLeadModel
                delegate: Controls.CheckDelegate {
                    width: drawer.width
                    text: model.nameRole
                    checkState: model.enabledRole ? Qt.Checked : Qt.Unchecked
                    onCheckStateChanged: {
                        dataStore.availableLeadModel.setScaleEnabled(index, checkState == Qt.Checked);
                    }
                }
            }
            Item {
                width: 1
                height: Kirigami.Units.largeSpacing
            }
            Kirigami.Heading {
                text: qsTr("Boulder")
                anchors {
                    left: parent.left
                    margins: Kirigami.Units.smallSpacing
                }
            }
            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                color: Kirigami.Theme.textColor
                opacity: 0.2
                height: Math.floor(Kirigami.Units.devicePixelRatio)
            }
            Repeater {
                model: dataStore.availableBoulderModel
                delegate: Controls.CheckDelegate {
                    width: drawer.width
                    text: model.nameRole
                    checkState: model.enabledRole ? Qt.Checked : Qt.Unchecked
                    onCheckStateChanged: {
                        dataStore.availableBoulderModel.setScaleEnabled(index, checkState == Qt.Checked);
                    }
                }
            }
            Item {
                width: 1
                height: Kirigami.Units.largeSpacing
            }
            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                color: Kirigami.Theme.textColor
                opacity: 0.2
                height: Math.floor(Kirigami.Units.devicePixelRatio)
            }
            Controls.SwitchDelegate {
                width: drawer.width
                text: qsTr("Link Lead and Boulder")
                checked: dataStore.leadAndBoulderLinked
                onCheckedChanged: {
                    dataStore.leadAndBoulderLinked = checked;
                }
            }
        }
    }

    pageStack.initialPage: [leadPageComponent, boulderPageComponent]
    pageStack.onCurrentIndexChanged: {
        if (loaded) {
            dataStore.currentTab = pageStack.currentIndex;
        }
    }
    //HACK: use this as semaphore, don't know other ways to make this not
    //emit a signal otherwise
    property bool loaded: false;


    Component.onCompleted: {
        pageStack.currentIndex = dataStore.currentTab;
        loaded = true
    }

    Connections {
        target: dataStore.availableLeadModel
        onCurrentGradeChanged: {
            if (dataStore.leadAndBoulderLinked) {
                dataStore.availableBoulderModel.currentGrade = dataStore.availableLeadModel.currentGrade;
            }
        }
    }

    Connections {
        target: dataStore.availableBoulderModel
        onCurrentGradeChanged: {
            if (dataStore.leadAndBoulderLinked) {
                dataStore.availableLeadModel.currentGrade = dataStore.availableBoulderModel.currentGrade;
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
}
