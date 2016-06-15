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
    scaleName: "UIAA"

    visible: applicationWindow().uiaa
    url: "https://en.wikipedia.org/wiki/Grade_%28climbing%29#UIAA"

    function format(grade) {
        var formattedGrade = dataStore.gradeName("UIAA", grade);
        if (formattedGrade) {
            return formattedGrade;
        }
    }

    description: "The UIAA grading system is mostly used for short rock routes in Germany, Austria, Switzerland, Czech Republic, Slovakia and Hungary. On long routes it is often used in the Alps and Himalaya. Using Roman numerals, it was originally intended to run from I (easiest) to VI (hardest), but as with all other grading systems, improvements to climbing standards have led to the system being open-ended after the grade VII was accepted in 1977. An optional + or − may be used to further differentiate difficulty. As of 2004, the hardest climbs are XII−."
}
