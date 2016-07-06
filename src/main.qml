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
import QtQuick.Controls 1.2 as Controls
import org.kde.kirigami 1.0 as Kirigami

Kirigami.ApplicationWindow {
    id: root

    property bool french: true
    property bool yds: true
    property bool uiaa: true

    header: Kirigami.ApplicationHeader {
        separatorStyle: "TabBar"
    }

    globalDrawer: Kirigami.GlobalDrawer {
        id: drawer
        title: "climbing grades"
        titleIcon: "climbinggrades"
        bannerImageSource: "halfdome.jpg"

        topContent: Column {
            anchors {
                left: parent.left
                right: parent.right
                margins: -Kirigami.Units.smallSpacing
            }
            Kirigami.Heading {
                text: "Lead"
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
                delegate: Kirigami.BasicListItem {
                    height: Kirigami.Units.gridUnit * 3
                    width: parent.width
                    Controls.CheckBox {
                        id: checkBox
                        enabled: false
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: Kirigami.Units.smallSpacing
                        }
                        checked: model.enabledRole
                    }
                    label: model.nameRole
                    onClicked: {
                        checkBox.checked = !checkBox.checked;
                        dataStore.availableLeadModel.setScaleEnabled(index, checkBox.checked);
                    }
                }
            }
            Item {
                width: 1
                height: Kirigami.Units.largeSpacing
            }
            Kirigami.Heading {
                text: "Boulder"
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
                delegate: Kirigami.BasicListItem {
                    height: Kirigami.Units.gridUnit * 3
                    width: parent.width
                    Controls.CheckBox {
                        id: checkBox
                        enabled: false
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: Kirigami.Units.smallSpacing
                        }
                        checked: model.enabledRole
                    }
                    label: model.nameRole
                    onClicked: {
                        checkBox.checked = !checkBox.checked;
                        dataStore.availableBoulderModel.setScaleEnabled(index, checkBox.checked);
                    }
                }
            }
        }
    }
    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
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
    Component {
        id: leadPageComponent
        Global {
            title: "Lead"
            model: dataStore.availableLeadModel
            defaultGrade: 45
        }
    }
    Component {
        id: boulderPageComponent
        Global {
            title: "Boulder"
            model: dataStore.availableBoulderModel
            defaultGrade: 65
        }
    }
}
