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
    scaleName: "French"

    visible: applicationWindow().french
    url: "https://en.wikipedia.org/wiki/Grade_%28climbing%29#French_numerical_grades"

    function format(grade) {
        var formattedGrade = dataStore.gradeName("French", grade);
        if (formattedGrade) {
            return formattedGrade;
        }

        //completely aleatory but whatever
        //10.6 is 53/50: the ratio of number of lines in the table and the grade 10a
        var adjusted = grade/10.6;

        print("Fallback to calculation, Raw french: " + adjusted);

        var numberForLetter = adjusted - Math.floor(adjusted);
        var letter = "";
        var plus = "";
        if (numberForLetter >= 0.6) {
            letter = "c";
            if (numberForLetter >= 0.75) {
                plus = "+";
            }
        } else if (numberForLetter >= 0.3) {
            letter = "b";
            if (numberForLetter >= 0.45) {
                plus = "+";
            }
        } else {
            letter = "a";
            if (numberForLetter >= 0.15) {
                plus = "+";
            }
        }

        return Math.floor(adjusted) + letter + plus;
    }

    description: "The French numerical system rates a climb according to the overall technical difficulty and strenuousness of the route. Grades start at 1 (very easy) and the system is open-ended. Each numerical grade can be subdivided by adding a letter (a, b or c). Examples: 2, 4, 4b, 6a, 7c. An optional + may be used to further differentiate difficulty. For example, these routes are sorted by ascending difficulty: 5c+, 6a, 6a+, 6b, 6b+. Although some countries in Europe use a system with similar grades but not necessarily matching difficulties, the French system remains the main system used in the vast majority of European countries and in many international events outside the USA."
}
