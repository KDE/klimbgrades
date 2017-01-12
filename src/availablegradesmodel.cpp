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
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include "availablegradesmodel.h"
#include "data.h"

#include <QCoreApplication>
#include <QDebug>
#include <QByteArray>
#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QStandardPaths>
#include <QSettings>

#include <KConfigGroup>


AvailableGradesModel::AvailableGradesModel(Data *parent)
    : QAbstractListModel(parent),
      m_data(parent),
      m_personalRecord(0)
{
    m_roleNames.insert(NameRole, "nameRole");
    m_roleNames.insert(EnabledRole, "enabledRole");
    m_roleNames.insert(DescriptionRole, "descriptionRole");
    m_roleNames.insert(UrlRole, "urlRole");
}

AvailableGradesModel::~AvailableGradesModel()
{
}

QHash<int, QByteArray> AvailableGradesModel::roleNames() const
{
    return m_roleNames;
}

int AvailableGradesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_jsonDoc.array().size();
}

void AvailableGradesModel::setScaleEnabled(int row, bool enabled)
{
    if (row < 0 || row > m_jsonDoc.array().size()) {
        return;
    }

    KConfigGroup cg(m_data->config(), "General");
    const QVariantMap value = m_jsonDoc.array().at(row).toObject().toVariantMap();
    cg.writeEntry(value.value("name").toString() + "-enabled", enabled);
    m_data->configNeedsSaving();

    emit dataChanged(index(row), index(row));
}

QVariant AvailableGradesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() > m_jsonDoc.array().size()) {
        return QVariant();
    }

    const QVariantMap value = m_jsonDoc.array().at(index.row()).toObject().toVariantMap();

    switch (role) {
    case NameRole:
        return value.value("name");
    case EnabledRole: {
        KConfigGroup cg(m_data->config(), "General");
        return cg.readEntry(value.value("name").toString() + "-enabled", true);
    }
    case DescriptionRole:
        return value.value("description");
    case UrlRole:
        return value.value("url");
    }

    return QVariant();
}


void AvailableGradesModel::load(const QString &dataName)
{
    beginResetModel();

    m_dataName = dataName;
    QFile jsonFile(":/" + dataName + "scales.json");
    jsonFile.open(QIODevice::ReadOnly);

    QJsonParseError error;
    m_jsonDoc = QJsonDocument::fromJson(jsonFile.readAll(), &error);

    if (error.error != QJsonParseError::NoError) {
        qWarning() << "Error parsing Json" << error.errorString();
    }

    endResetModel();

    KConfigGroup cg(m_data->config(), m_dataName);
    m_personalRecord = cg.readEntry("personalRecord", 0);

    emit personalRecordChanged();
}

int AvailableGradesModel::personalRecord() const
{
    return m_personalRecord;
}

void AvailableGradesModel::setPersonalRecord(int record)
{
    if (record == m_personalRecord) {
        return;
    }

    m_personalRecord = record;

    KConfigGroup cg(m_data->config(), m_dataName);
    cg.writeEntry("personalRecord", record);
    m_data->configNeedsSaving();

    emit personalRecordChanged();
}

#include "moc_availablegradesmodel.cpp"
