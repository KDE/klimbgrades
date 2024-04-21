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
#include "availablegradesmodel.h"

#include <KConfigGroup>
#include <QCoreApplication>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QTimer>

Data::Data(QObject *parent)
    : QObject(parent)
{
    m_configSyncTimer = new QTimer(this);
    m_configSyncTimer->setSingleShot(false);
    connect(m_configSyncTimer, &QTimer::timeout, this, [this]() {
        config()->sync();
    });

    KConfigGroup cg(config(), "General");
    m_currentTab = cg.readEntry("currentTab", 0);
    m_leadAndBoulderLinked = cg.readEntry("leadAndBoulderLinked", false);

    m_availableLeadModel = new AvailableGradesModel(this);
    m_availableLeadModel->load("lead");
    m_availableBoulderModel = new AvailableGradesModel(this);
    m_availableBoulderModel->load("boulder");

    QFile file(":/data.csv");

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
            foreach (const QString &scale, string.split(',')) {
                m_data[scale] = QVector<QString>(lines.count());
                m_scales << scale;
            }
        } else {
            int i = 0;
            foreach (const QString &grade, string.split(',')) {
                if (i > m_data.size()) {
                    break;
                }
                m_data[m_scales[i]][line] = grade;
                ++i;
            }
            ++line;
        }
        // qWarning()<<m_data;
    }
}

Data::~Data()
{
    config()->sync();
}

void Data::configNeedsSaving()
{
    m_configSyncTimer->start(1000);
}

KSharedConfigPtr Data::config()
{
    if (!m_config) {
        m_config = KSharedConfig::openConfig("climbinggradesrc", KConfig::SimpleConfig);
    }

    return m_config;
}

AvailableGradesModel *Data::availableLeadModel()
{
    return m_availableLeadModel;
}

AvailableGradesModel *Data::availableBoulderModel()
{
    return m_availableBoulderModel;
}

QString Data::gradeName(const QString &scale, int decimalGrade) const
{
    const int position = qRound((qreal)decimalGrade / (qreal)2.0);

    if (position < 0 || !m_data.contains(scale) || m_data[scale].size() <= position + 1) {
        return QString();
    }

    return m_data[scale][position];
}

int Data::currentTab() const
{
    return m_currentTab;
}

void Data::setCurrentTab(int tab)
{
    if (tab == m_currentTab) {
        return;
    }

    m_currentTab = tab;

    KConfigGroup cg(config(), "General");
    cg.writeEntry("currentTab", tab);
    configNeedsSaving();

    emit currentTabChanged();
}

int Data::isLeadAndBoulderLinked() const
{
    return m_leadAndBoulderLinked;
}

void Data::setLeadAndBoulderLinked(bool linked)
{
    if (linked == m_leadAndBoulderLinked) {
        return;
    }

    m_leadAndBoulderLinked = linked;

    KConfigGroup cg(config(), "General");
    cg.writeEntry("leadAndBoulderLinked", linked);
    configNeedsSaving();

    emit leadAndBoulderLinkedChanged();
}

#include "moc_data.cpp"
