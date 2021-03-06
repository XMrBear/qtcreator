/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of Qt Creator.
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
****************************************************************************/

#include "ModelManagerInterface.h"

#include <QtCore/QSet>

using namespace CPlusPlus;

static CppModelManagerInterface *g_instance = 0;

CppModelManagerInterface::CppModelManagerInterface(QObject *parent)
    : QObject(parent)
{
    Q_ASSERT(! g_instance);
    g_instance = this;
}

CppModelManagerInterface::~CppModelManagerInterface()
{
    Q_ASSERT(g_instance == this);
    g_instance = 0;
}

CppModelManagerInterface *CppModelManagerInterface::instance()
{
    return g_instance;
}


void CppModelManagerInterface::ProjectInfo::clearProjectParts()
{
    m_projectParts.clear();
    m_includePaths.clear();
    m_frameworkPaths.clear();
    m_sourceFiles.clear();
    m_defines.clear();
}

void CppModelManagerInterface::ProjectInfo::appendProjectPart(
        const CppModelManagerInterface::ProjectPart::Ptr &part)
{
    if (!part)
        return;

    m_projectParts.append(part);

    // update include paths
    QSet<QString> incs = QSet<QString>::fromList(m_includePaths);
    foreach (const QString &ins, part->includePaths)
        incs.insert(ins);
    m_includePaths = incs.toList();

    // update framework paths
    QSet<QString> frms = QSet<QString>::fromList(m_frameworkPaths);
    foreach (const QString &frm, part->frameworkPaths)
        frms.insert(frm);
    m_frameworkPaths = frms.toList();

    // update source files
    QSet<QString> srcs = QSet<QString>::fromList(m_sourceFiles);
    foreach (const QString &src, part->sourceFiles)
        srcs.insert(src);
    m_sourceFiles = srcs.toList();

    // update defines
    if (!m_defines.isEmpty())
        m_defines.append('\n');
    m_defines.append(part->defines);
}
