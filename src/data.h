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

#include <QHash>
#include <QObject>
#include <QStandardItemModel>
#include <QVector>

#include <ksharedconfig.h>

class QTimer;
class AvailableGradesModel;

class Data : public QObject
{
    Q_OBJECT
    Q_PROPERTY(AvailableGradesModel *availableLeadModel READ availableLeadModel CONSTANT)
    Q_PROPERTY(AvailableGradesModel *availableBoulderModel READ availableBoulderModel CONSTANT)
    Q_PROPERTY(int currentTab READ currentTab WRITE setCurrentTab NOTIFY currentTabChanged)
    Q_PROPERTY(bool leadAndBoulderLinked READ isLeadAndBoulderLinked WRITE setLeadAndBoulderLinked NOTIFY leadAndBoulderLinkedChanged)

public:
    Data(QObject *parent = 0);
    ~Data();

    AvailableGradesModel *availableLeadModel();
    AvailableGradesModel *availableBoulderModel();

    KSharedConfigPtr config();

    int currentTab() const;
    void setCurrentTab(int tab);

    int isLeadAndBoulderLinked() const;
    void setLeadAndBoulderLinked(bool linked);

    void configNeedsSaving();

    Q_INVOKABLE QString gradeName(const QString &scale, int decimalGrade) const;

Q_SIGNALS:
    void currentTabChanged();
    void leadAndBoulderLinkedChanged();

private:
    QStringList m_scales;
    QHash<QString, QVector<QString>> m_data;
    AvailableGradesModel *m_availableLeadModel;
    AvailableGradesModel *m_availableBoulderModel;
    QTimer *m_configSyncTimer;
    KSharedConfigPtr m_config;
    int m_currentTab;
    bool m_leadAndBoulderLinked : 1;
};

#endif
