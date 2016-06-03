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
}
