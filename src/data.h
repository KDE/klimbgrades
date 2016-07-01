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

#ifndef DATA_H
#define DATA_H

#include <QObject>
#include <QHash>
#include <QStandardItemModel>
#include <QVector>

class AvailableGradesModel;

class Data : public QObject {
    Q_OBJECT
    Q_PROPERTY(AvailableGradesModel *availableGradesModel READ availableGradesModel CONSTANT)
    Q_PROPERTY(QStringList scales READ scales NOTIFY scalesChanged)

public:
    Data(QObject *parent = 0);

    QStringList scales() const;

    AvailableGradesModel *availableGradesModel();

    Q_INVOKABLE QString gradeName(const QString &scale, int decimalGrade) const;

Q_SIGNALS:
    void scalesChanged();
    void enabledScalesChanged();

private:
    QStringList m_scales;
    QHash<QString, QVector<QString> > m_data;
    AvailableGradesModel *m_availableGradesModel;
};

#endif
