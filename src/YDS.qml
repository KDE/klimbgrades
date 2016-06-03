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

GradeWidgetBase {
    scaleName: "YDS"

    visible: applicationWindow().yds
    url: "https://en.wikipedia.org/wiki/Yosemite_Decimal_System"

    function format(grade) {
        var formattedGrade = dataStore.gradeName("YDS", grade);
        if (formattedGrade) {
            return formattedGrade;
        }

        var adjusted = grade/6.5;

        print("Fallback to calcumation, Raw YDS: " + adjusted);

        var numberForLetter = adjusted - Math.floor(adjusted);
        var letter;
        if (numberForLetter >= 0.75) {
            letter = "d";
        } else if (numberForLetter >= 0.5) {
            letter = "c";
        } else if (numberForLetter >= 0.25) {
            letter = "b";
        } else {
            letter = "a";
        }
        return "5." + Math.floor(adjusted) + letter;
    }

    description: "The system was initially developed as the Sierra Club grading system in the 1930s to classify hikes and climbs in the Sierra Nevada. Previously, these were described relative to others. For example, Z is harder than X but easier than Y. This primitive system was difficult to learn for those who did not yet have experience of X or Y. The club adapted a numerical system of classification that was easy to learn and which seemed practical in its application.

The system now divides all hikes and climbs into five classes: The exact definition of the classes is somewhat controversial, and updated versions of these classifications have been proposed.

    Class 1: Walking with a low chance of injury, hiking boots a good idea.
    Class 2: Simple scrambling, with the possibility of occasional use of the hands. Little potential danger is encountered. Hiking Boots highly recommended.
    Class 3: Scrambling with increased exposure. Handholds are necessary. A rope should be available for learning climbers, or if you just choose to use one that day, but is usually not required. Falls could easily be fatal.
    Class 4: Simple climbing, with exposure. A rope is often used. Natural protection can be easily found. Falls may well be fatal.
    Class 5: Is considered technical roped free (without hanging on the rope, pulling on, or stepping on anchors) climbing; belaying, and other protection hardware is used for safety. Un-roped falls can result in severe injury or death.
        Class 5.0 to 5.15c[5] is used to define progressively more difficult free moves.
    Class 6: Is considered Aid (often broken into A.0 to A.5) climbing. Equipment (Etriers, aiders, or stirrups are often used to stand in, and the equipment is used for hand holds) is used for more than just safety.
"
}
