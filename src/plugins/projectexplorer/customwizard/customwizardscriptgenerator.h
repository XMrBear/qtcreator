/**************************************************************************
**
** This file is part of Qt Creator
**
** Copyright (c) 2010 Nokia Corporation and/or its subsidiary(-ies).
**
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** Commercial Usage
**
** Licensees holding valid Qt Commercial licenses may use this file in
** accordance with the Qt Commercial License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Nokia.
**
** GNU Lesser General Public License Usage
**
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you are unsure which license is appropriate for your use, please
** contact the sales department at http://qt.nokia.com/contact.
**
**************************************************************************/

#ifndef CUSTOMWIZARDSCRIPTGENERATOR_H
#define CUSTOMWIZARDSCRIPTGENERATOR_H

#include <QtCore/QMap>
#include <QtCore/QList>
#include <QtCore/QString>

namespace Core {
class GeneratedFile;
};

namespace ProjectExplorer {
namespace Internal {

/* Custom wizard script generator functions. In addition to the <file> elements
 * that define template files in which macros are replaced, it is possible to have
 * a custom wizard call a generation script (specified in the "generatorscript"
 * attribute of the <files> element) which actually creates files.
 * The command line of the script must follow the convention
 *
 * script [--dry-run] [Field1=Value1 [Field2=Value2] [Field3:Filename3]]]...
 *
 * Multiline texts will be passed on as temporary files using the colon
 * separator.
 * The parameters are the field values from the UI.
 * As Qt Creator needs to know the file names before actually creates them to
 * do overwrite checking etc., this is  2-step process:
 * 1) Determine file names and attributes: The script is called with the
 *    --dry-run option and the field values. It then prints the relative path
 *    names it intends to create followed by comma-separated attributes
 *    matching those of the <file> element, for example:
 *        myclass.cpp,openeditor
 * 2) The script is called with the parameters only in the working directory
 * and then actually creates the files. If that involves directories, the script
 * should create those, too.
 */

// Step 1) Do a dry run of the generation script to get a list of files on stdout
QList<Core::GeneratedFile>
    dryRunCustomWizardGeneratorScript(const QString &targetPath, const QString &script,
                                      const QMap<QString, QString> &fieldMap,
                                      QString *errorMessage);

// Step 2) Generate files
bool runCustomWizardGeneratorScript(const QString &targetPath, const QString &script,
                                    const QMap<QString, QString> &fieldMap,
                                    QString *errorMessage);

} // namespace Internal
} // namespace ProjectExplorer

#endif // CUSTOMWIZARDSCRIPTGENERATOR_H
