/*
 *   Copyright 2017 Marco Martin <mart@kde.org>
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

function formatYDS(decimalGrade)
{
    var adjusted = decimalGrade/6.5;

    print("Fallback to calculation, Raw YDS: " + adjusted);

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

function formatFrench(decimalGrade)
{
    //completely aleatory but whatever
    //10.6 is 52/50: the ratio of number of lines in the table and the grade 10a
    var adjusted = decimalGrade/10.4;

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

function convertToRoman(num) {

    var decimalValue = [ 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 ];
    var romanNumeral = [ 'M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I' ];

    var romanized = '';

    for (var index = 0; index < decimalValue.length; index++) {
        while (decimalValue[index] <= num) {
            romanized += romanNumeral[index];
            num -= decimalValue[index];
        }
    }

    return romanized;
}

function formatUIAA(decimalGrade)
{
    var adjusted = decimalGrade/3 - 22 + 1/3;

    var numberForsign = adjusted - Math.floor(adjusted);
    var sign = "";

    if (numberForsign < 0.2 || numberForsign > 0.8) {
        sign = "";
    } else if (numberForsign > 0.5) {
        sign = "-";
    } else {
        sign = "+";
    }
    return convertToRoman(Math.round(adjusted)) + sign;
}

function formatFont(decimalGrade)
{
    //completely aleatory similar to french
    var adjusted = decimalGrade/10.4;
    adjusted -= 0.6;

    print("Fallback to calculation, Raw french: " + adjusted);

    var numberForLetter = adjusted - Math.floor(adjusted);
    var letter = "";
    var plus = "";
    if (numberForLetter >= 0.6) {
        letter = "C";
        if (numberForLetter >= 0.75) {
            plus = "+";
        }
    } else if (numberForLetter >= 0.3) {
        letter = "B";
        if (numberForLetter >= 0.45) {
            plus = "+";
        }
    } else {
        letter = "A";
        if (numberForLetter >= 0.15) {
            plus = "+";
        }
    }

    return Math.floor(adjusted) + letter + plus;
}

function formatHueco(decimalGrade)
{
    return "V" + (decimalGrade - 84);
}

function formatBGrade(decimalGrade)
{
    return "B" + (decimalGrade - 84);
}
