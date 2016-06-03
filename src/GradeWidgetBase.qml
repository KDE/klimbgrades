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
import org.kde.kirigami 1.0 as Kirigami

Item {
    id: root

    width: 100
    height: 100

    property alias scaleName: scaleNameLabel.text
    property string url
    property string description

    property int decimalGrade: 1

    function increment() {
        print("Decimal grade: " + decimalGrade);

        decimalGrade++;
    }

    function decrement() {
        print("Decimal grade: " + decimalGrade);
        decimalGrade = Math.max(0, decimalGrade - 1);
    }

    function format(decimalGrade) {
        return decimalGrade;
    }

    onDecimalGradeChanged: {
        parent.grade = decimalGrade;
    }
    Connections {
        target: parent
        onGradeChanged: decimalGrade = parent.grade
    }

    Column {
        Kirigami.Label {
            id: scaleNameLabel
        }
        Kirigami.Heading {
            text: format(decimalGrade);
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        property int startX
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
