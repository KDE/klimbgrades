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


#include "data.h"

#include <QFile>
#include <QDebug>
#include <QTextStream>

Data::Data(QObject *parent)
    : QObject(parent)
{
    QFile file(":/data.csv");
    /*file.open(QIODevice::ReadOnly);
    QByteArray line;
    while (!file.atEnd()) {
        line = file.readLine();
        qWarning()<<QString::fromLatin1(line).split(":");
    }
    */
    QString rawData;
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);
        rawData = in.readAll();
        file.close();
    }
    const QStringList lines = rawData.split('\n');
    bool first = true;
    int line = 0;
    foreach (const QString &string, lines) {
        if (first) {
            first = false;
            foreach (const QString &scale, string.split(':')) {
                m_data[scale] = QVector<QString>(lines.count());
                m_scales << scale;
            }
        } else {
            int i = 0;
            foreach (const QString &grade, string.split(':')) {
                if (i > m_data.size()) {
                    break;
                }
                m_data[m_scales[i]][line] = grade;
                ++i;
            }
            ++line;
        }
        qWarning()<<m_data;
    }
    
}

QString Data::gradeName(const QString &scale, int decimalGrade) const
{
    const int position = qRound((qreal)decimalGrade/(qreal)2.0);
    
    if (position < 0 || !m_data.contains(scale) || m_data[scale].size() <= position+1) {
        return QString();
    }

    return m_data[scale][position];
}

#include "moc_data.cpp"

