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

#ifndef AVAILABLEGRADESMODEL_H
#define AVAILABLEGRADESMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

class Data;

class AvailableGradesModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int currentGrade READ currentGrade WRITE setCurrentGrade NOTIFY currentGradeChanged)
    Q_PROPERTY(int personalRecord READ personalRecord WRITE setPersonalRecord NOTIFY personalRecordChanged)

public:
    enum Roles {
        NameRole = Qt::UserRole,
        EnabledRole,
        DescriptionRole,
        UrlRole,
    };

    explicit AvailableGradesModel(Data *parent = 0);
    ~AvailableGradesModel();

    int personalRecord() const;
    void setPersonalRecord(int record);

    int currentGrade() const;
    void setCurrentGrade(int tab);

    Q_INVOKABLE void setScaleEnabled(int row, bool enabled);
    virtual QHash<int, QByteArray> roleNames() const;
    virtual int rowCount(const QModelIndex &parent) const;
    virtual QVariant data(const QModelIndex &index, int role) const;

    void load(const QString &dataName);

Q_SIGNALS:
    void personalRecordChanged();
    void currentGradeChanged();

private:
    QHash<int, QByteArray> m_roleNames;

    Data *m_data;
    QJsonDocument m_jsonDoc;
    QString m_dataName;
    int m_personalRecord;
    int m_currentGrade;
};

#endif // AVAILABLEGRADESMODEL_H
