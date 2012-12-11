/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing
**
** This file is part of Qt Creator.
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company.  For licensing terms and
** conditions see http://www.qt.io/terms-conditions.  For further information
** use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file.  Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, The Qt Company gives you certain additional
** rights.  These rights are described in The Qt Company LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
****************************************************************************/

#include "helpplugin.h"

#include "centralwidget.h"
#include "docsettingspage.h"
#include "filtersettingspage.h"
#include "generalsettingspage.h"
#include "helpconstants.h"
#include "helpfindsupport.h"
#include "helpindexfilter.h"
#include "helpmode.h"
#include "helpviewer.h"
#include "localhelpmanager.h"
#include "openpagesmanager.h"
#include "openpagesmodel.h"
#include "qtwebkithelpviewer.h"
#include "remotehelpfilter.h"
#include "searchwidget.h"
#include "searchtaskhandler.h"
#include "textbrowserhelpviewer.h"

#ifdef QTC_MAC_NATIVE_HELPVIEWER
#include "macwebkithelpviewer.h"
#endif

#include <bookmarkmanager.h>
#include <contentwindow.h>
#include <indexwindow.h>

#include <app/app_version.h>
#include <coreplugin/actionmanager/actionmanager.h>
#include <coreplugin/actionmanager/actioncontainer.h>
#include <coreplugin/actionmanager/command.h>
#include <coreplugin/id.h>
#include <coreplugin/coreconstants.h>
#include <coreplugin/editormanager/editormanager.h>
#include <coreplugin/editormanager/ieditor.h>
#include <coreplugin/findplaceholder.h>
#include <coreplugin/icore.h>
#include <coreplugin/minisplitter.h>
#include <coreplugin/modemanager.h>
#include <coreplugin/rightpane.h>
#include <coreplugin/sidebar.h>
#include <extensionsystem/pluginmanager.h>
#include <coreplugin/find/findplugin.h>
#include <texteditor/texteditorconstants.h>
#include <utils/hostosinfo.h>
#include <utils/qtcassert.h>
#include <utils/styledbar.h>
#include <utils/theme/theme.h>

#include <QDir>
#include <QFileInfo>
#include <QLibraryInfo>
#include <QTimer>
#include <QTranslator>
#include <qplugin.h>
#include <QRegExp>

#include <QAction>
#include <QComboBox>
#include <QDesktopServices>
#include <QMenu>
#include <QStackedLayout>
#include <QSplitter>

#include <QHelpEngine>

using namespace Help::Internal;

static const char kExternalWindowStateKey[] = "Help/ExternalWindowState";

#define IMAGEPATH ":/help/images/"

using namespace Core;
using namespace Utils;

HelpPlugin::HelpPlugin()
    : m_mode(0),
    m_centralWidget(0),
    m_rightPaneSideBarWidget(0),
    m_setupNeeded(true),
    m_helpManager(0),
    m_openPagesManager(0)
{
}

HelpPlugin::~HelpPlugin()
{
    delete m_openPagesManager;
    delete m_helpManager;
}

bool HelpPlugin::initialize(const QStringList &arguments, QString *error)
{
    Q_UNUSED(arguments)
    Q_UNUSED(error)
    Context globalcontext(Core::Constants::C_GLOBAL);
    Context modecontext(Constants::C_MODE_HELP);

    const QString &locale = ICore::userInterfaceLanguage();
    if (!locale.isEmpty()) {
        QTranslator *qtr = new QTranslator(this);
        QTranslator *qhelptr = new QTranslator(this);
        const QString &creatorTrPath = ICore::resourcePath()
            + QLatin1String("/translations");
        const QString &qtTrPath = QLibraryInfo::location(QLibraryInfo::TranslationsPath);
        const QString &trFile = QLatin1String("assistant_") + locale;
        const QString &helpTrFile = QLatin1String("qt_help_") + locale;
        if (qtr->load(trFile, qtTrPath) || qtr->load(trFile, creatorTrPath))
            qApp->installTranslator(qtr);
        if (qhelptr->load(helpTrFile, qtTrPath) || qhelptr->load(helpTrFile, creatorTrPath))
            qApp->installTranslator(qhelptr);
    }

    m_helpManager = new LocalHelpManager(this);
    m_openPagesManager = new OpenPagesManager(this);
    addAutoReleasedObject(m_docSettingsPage = new DocSettingsPage());
    addAutoReleasedObject(m_filterSettingsPage = new FilterSettingsPage());
    addAutoReleasedObject(m_generalSettingsPage = new GeneralSettingsPage());
    addAutoReleasedObject(m_searchTaskHandler = new SearchTaskHandler);

    m_centralWidget = new Help::Internal::CentralWidget(modecontext);
    connect(m_centralWidget, SIGNAL(sourceChanged(QUrl)), this,
        SLOT(updateSideBarSource(QUrl)));
    connect(m_centralWidget, &CentralWidget::closeButtonClicked,
            &OpenPagesManager::instance(), &OpenPagesManager::closeCurrentPage);

    connect(m_generalSettingsPage, SIGNAL(fontChanged()), this,
        SLOT(fontChanged()));
    connect(m_generalSettingsPage, SIGNAL(returnOnCloseChanged()), m_centralWidget,
        SLOT(updateCloseButton()));
    connect(HelpManager::instance(), SIGNAL(helpRequested(QUrl,Core::HelpManager::HelpViewerLocation)),
            this, SLOT(handleHelpRequest(QUrl,Core::HelpManager::HelpViewerLocation)));
    connect(m_searchTaskHandler, SIGNAL(search(QUrl)), this,
            SLOT(showLinkInHelpMode(QUrl)));

    connect(m_filterSettingsPage, SIGNAL(filtersChanged()), this,
        SLOT(setupHelpEngineIfNeeded()));
    connect(HelpManager::instance(), SIGNAL(documentationChanged()), this,
        SLOT(setupHelpEngineIfNeeded()));
    connect(HelpManager::instance(), SIGNAL(collectionFileChanged()), this,
        SLOT(setupHelpEngineIfNeeded()));
    connect(HelpManager::instance(), SIGNAL(setupFinished()), this,
            SLOT(unregisterOldQtCreatorDocumentation()));

    Command *cmd;
    QAction *action;

    // Add Contents, Index, and Context menu items
    action = new QAction(QIcon::fromTheme(QLatin1String("help-contents")),
        tr(Constants::SB_CONTENTS), this);
    cmd = ActionManager::registerAction(action, "Help.ContentsMenu", globalcontext);
    ActionManager::actionContainer(Core::Constants::M_HELP)->addAction(cmd, Core::Constants::G_HELP_HELP);
    connect(action, SIGNAL(triggered()), this, SLOT(activateContents()));

    action = new QAction(tr(Constants::SB_INDEX), this);
    cmd = ActionManager::registerAction(action, "Help.IndexMenu", globalcontext);
    ActionManager::actionContainer(Core::Constants::M_HELP)->addAction(cmd, Core::Constants::G_HELP_HELP);
    connect(action, SIGNAL(triggered()), this, SLOT(activateIndex()));

    action = new QAction(tr("Context Help"), this);
    cmd = ActionManager::registerAction(action, Help::Constants::CONTEXT_HELP, globalcontext);
    ActionManager::actionContainer(Core::Constants::M_HELP)->addAction(cmd, Core::Constants::G_HELP_HELP);
    cmd->setDefaultKeySequence(QKeySequence(Qt::Key_F1));
    connect(action, SIGNAL(triggered()), this, SLOT(showContextHelp()));

    action = new QAction(tr("Technical Support"), this);
    cmd = ActionManager::registerAction(action, "Help.TechSupport", globalcontext);
    ActionManager::actionContainer(Core::Constants::M_HELP)->addAction(cmd, Core::Constants::G_HELP_SUPPORT);
    connect(action, SIGNAL(triggered()), this, SLOT(slotOpenSupportPage()));

    action = new QAction(tr("Report Bug..."), this);
    cmd = ActionManager::registerAction(action, "Help.ReportBug", globalcontext);
    ActionManager::actionContainer(Core::Constants::M_HELP)->addAction(cmd, Core::Constants::G_HELP_SUPPORT);
    connect(action, SIGNAL(triggered()), this, SLOT(slotReportBug()));

    if (ActionContainer *windowMenu = ActionManager::actionContainer(Core::Constants::M_WINDOW)) {
        // reuse EditorManager constants to avoid a second pair of menu actions
        // Goto Previous In History Action
        action = new QAction(this);
        Command *ctrlTab = ActionManager::registerAction(action, Core::Constants::GOTOPREVINHISTORY,
            modecontext);
        windowMenu->addAction(ctrlTab, Core::Constants::G_WINDOW_NAVIGATE);
        connect(action, SIGNAL(triggered()), &OpenPagesManager::instance(),
            SLOT(gotoPreviousPage()));

        // Goto Next In History Action
        action = new QAction(this);
        Command *ctrlShiftTab = ActionManager::registerAction(action, Core::Constants::GOTONEXTINHISTORY,
            modecontext);
        windowMenu->addAction(ctrlShiftTab, Core::Constants::G_WINDOW_NAVIGATE);
        connect(action, SIGNAL(triggered()), &OpenPagesManager::instance(),
            SLOT(gotoNextPage()));
    }

    auto helpIndexFilter = new HelpIndexFilter();
    addAutoReleasedObject(helpIndexFilter);
    connect(helpIndexFilter, &HelpIndexFilter::linkActivated,
            this, &HelpPlugin::showLinkInHelpMode);
    connect(helpIndexFilter, &HelpIndexFilter::linksActivated,
            this, &HelpPlugin::showLinksInHelpMode);

    RemoteHelpFilter *remoteHelpFilter = new RemoteHelpFilter();
    addAutoReleasedObject(remoteHelpFilter);
    connect(remoteHelpFilter, SIGNAL(linkActivated(QUrl)), this,
        SLOT(showLinkInHelpMode(QUrl)));

    QDesktopServices::setUrlHandler(QLatin1String("qthelp"), this, "handleHelpRequest");
    connect(ModeManager::instance(), SIGNAL(currentModeChanged(Core::IMode*,Core::IMode*)),
            this, SLOT(modeChanged(Core::IMode*,Core::IMode*)));

    m_mode = new HelpMode;
    m_mode->setWidget(m_centralWidget);
    addAutoReleasedObject(m_mode);

    return true;
}

void HelpPlugin::extensionsInitialized()
{
    QStringList filesToRegister;
    // we might need to register creators inbuild help
    filesToRegister.append(ICore::documentationPath() + QLatin1String("/qtcreator.qch"));
    // Other qch files
#ifdef Q_OS_WIN
    const QString newDocPath = QDir::cleanPath(QCoreApplication::applicationDirPath()
        + QLatin1String("/../../../../share/doc"));
#else
    const QString newDocPath = QDir::cleanPath(QCoreApplication::applicationDirPath()
        + QLatin1String("/../doc"));
#endif
    QDir otherDocDir(newDocPath);
    const QStringList &newDocFiles = otherDocDir.entryList(QStringList(QLatin1String("*.qch")));
    foreach(const QString &doc, newDocFiles)
        filesToRegister.append(QDir::cleanPath(newDocPath + QLatin1Char('/') + doc));
    HelpManager::registerDocumentation(filesToRegister);
}

ExtensionSystem::IPlugin::ShutdownFlag HelpPlugin::aboutToShutdown()
{
    if (m_externalWindow)
        delete m_externalWindow.data();
    if (m_centralWidget)
        delete m_centralWidget;
    if (m_rightPaneSideBarWidget)
        delete m_rightPaneSideBarWidget;
    return SynchronousShutdown;
}

void HelpPlugin::unregisterOldQtCreatorDocumentation()
{
    const QString &nsInternal = QString::fromLatin1("org.qt-project.qtcreator.%1%2%3")
        .arg(IDE_VERSION_MAJOR).arg(IDE_VERSION_MINOR).arg(IDE_VERSION_RELEASE);

    QStringList documentationToUnregister;
    foreach (const QString &ns, HelpManager::registeredNamespaces()) {
        if (ns.startsWith(QLatin1String("org.qt-project.qtcreator."))
                && ns != nsInternal) {
            documentationToUnregister << ns;
        }
    }
    if (!documentationToUnregister.isEmpty())
        HelpManager::unregisterDocumentation(documentationToUnregister);
}

void HelpPlugin::resetFilter()
{
    const QString &filterInternal = QString::fromLatin1("Qt Creator %1.%2.%3")
        .arg(IDE_VERSION_MAJOR).arg(IDE_VERSION_MINOR).arg(IDE_VERSION_RELEASE);
    QRegExp filterRegExp(QLatin1String("Qt Creator \\d*\\.\\d*\\.\\d*"));

    QHelpEngineCore *engine = &LocalHelpManager::helpEngine();
    const QStringList &filters = engine->customFilters();
    foreach (const QString &filter, filters) {
        if (filterRegExp.exactMatch(filter) && filter != filterInternal)
            engine->removeCustomFilter(filter);
    }

    // we added a filter at some point, remove previously added filter
    if (engine->customValue(Help::Constants::WeAddedFilterKey).toInt() == 1) {
        const QString &filter =
            engine->customValue(Help::Constants::PreviousFilterNameKey).toString();
        if (!filter.isEmpty())
            engine->removeCustomFilter(filter);
    }

    // potentially remove a filter with new name
    const QString filterName = tr("Unfiltered");
    engine->removeCustomFilter(filterName);
    engine->addCustomFilter(filterName, QStringList());
    engine->setCustomValue(Help::Constants::WeAddedFilterKey, 1);
    engine->setCustomValue(Help::Constants::PreviousFilterNameKey, filterName);
    engine->setCurrentFilter(filterName);

    LocalHelpManager::updateFilterModel();
    connect(engine, &QHelpEngineCore::setupFinished,
            LocalHelpManager::instance(), &LocalHelpManager::updateFilterModel);
}

void HelpPlugin::saveExternalWindowSettings()
{
    if (!m_externalWindow)
        return;
    m_externalWindowState = m_externalWindow->geometry();
    QSettings *settings = Core::ICore::settings();
    settings->setValue(QLatin1String(kExternalWindowStateKey),
                       qVariantFromValue(m_externalWindowState));
}

HelpWidget *HelpPlugin::createHelpWidget(const Context &context, HelpWidget::WidgetStyle style)
{
    HelpWidget *widget = new HelpWidget(context, style);

    connect(widget->currentViewer(), SIGNAL(loadFinished()),
            this, SLOT(highlightSearchTermsInContextHelp()));
    connect(widget, SIGNAL(openHelpMode(QUrl)),
            this, SLOT(showLinkInHelpMode(QUrl)));
    connect(widget, SIGNAL(closeButtonClicked()),
            this, SLOT(slotHideRightPane()));
    connect(widget, SIGNAL(aboutToClose()),
            this, SLOT(saveExternalWindowSettings()));

    // force setup, as we might have never switched to full help mode
    // thus the help engine might still run without collection file setup
    m_helpManager->setupGuiHelpEngine();

    return widget;
}

void HelpPlugin::createRightPaneContextViewer()
{
    if (m_rightPaneSideBarWidget)
        return;
    m_rightPaneSideBarWidget = createHelpWidget(Core::Context(Constants::C_HELP_SIDEBAR),
                                                HelpWidget::SideBarWidget);
}

HelpViewer *HelpPlugin::externalHelpViewer()
{
    if (m_externalWindow)
        return m_externalWindow->currentViewer();
    doSetupIfNeeded();
    m_externalWindow = createHelpWidget(Core::Context(Constants::C_HELP_EXTERNAL),
                                        HelpWidget::ExternalWindow);
    if (m_externalWindowState.isNull()) {
        QSettings *settings = Core::ICore::settings();
        m_externalWindowState = settings->value(QLatin1String(kExternalWindowStateKey)).toRect();
    }
    if (m_externalWindowState.isNull())
        m_externalWindow->resize(650, 700);
    else
        m_externalWindow->setGeometry(m_externalWindowState);
    m_externalWindow->show();
    m_externalWindow->setFocus();
    return m_externalWindow->currentViewer();
}

HelpViewer *HelpPlugin::createHelpViewer(qreal zoom)
{
    HelpViewer *viewer = 0;
    const QString backend = QLatin1String(qgetenv("QTC_HELPVIEWER_BACKEND"));
    if (backend.compare(QLatin1String("native"), Qt::CaseInsensitive) == 0) {
#ifdef QTC_MAC_NATIVE_HELPVIEWER
        viewer = new MacWebKitHelpViewer(zoom);
#else
        qWarning() << "native help viewer is requested, but was not enabled during compilation";
        viewer = new TextBrowserHelpViewer(zoom);
#endif
    } else if (backend.compare(QLatin1String("textbrowser"), Qt::CaseInsensitive) == 0) {
        viewer = new TextBrowserHelpViewer(zoom);
    } else {
#ifndef QT_NO_WEBKIT
        viewer = new QtWebKitHelpViewer(zoom);
#else
        viewer = new TextBrowserHelpViewer(zoom);
#endif
    }

    // initialize font
    QVariant fontSetting = LocalHelpManager::engineFontSettings();
    if (fontSetting.isValid())
        viewer->setViewerFont(fontSetting.value<QFont>());

    // add find support
    Aggregation::Aggregate *agg = new Aggregation::Aggregate();
    agg->add(viewer);
    agg->add(new HelpViewerFindSupport(viewer));

    return viewer;
}

void HelpPlugin::activateHelpMode()
{
    ModeManager::activateMode(Id(Constants::ID_MODE_HELP));
}

void HelpPlugin::showLinkInHelpMode(const QUrl &source)
{
    activateHelpMode();
    Core::ICore::raiseWindow(m_mode->widget());
    m_centralWidget->setSource(source);
    m_centralWidget->setFocus();
}

void HelpPlugin::showLinksInHelpMode(const QMap<QString, QUrl> &links, const QString &key)
{
    activateHelpMode();
    Core::ICore::raiseWindow(m_mode->widget());
    m_centralWidget->showTopicChooser(links, key);
}

void HelpPlugin::slotHideRightPane()
{
    RightPaneWidget::instance()->setShown(false);
}

void HelpPlugin::modeChanged(IMode *mode, IMode *old)
{
    Q_UNUSED(old)
    if (mode == m_mode) {
        qApp->setOverrideCursor(Qt::WaitCursor);
        doSetupIfNeeded();
        qApp->restoreOverrideCursor();
    }
}

void HelpPlugin::updateSideBarSource()
{
    if (HelpViewer *viewer = m_centralWidget->currentViewer()) {
        const QUrl &url = viewer->source();
        if (url.isValid())
            updateSideBarSource(url);
    }
}

void HelpPlugin::updateSideBarSource(const QUrl &newUrl)
{
    if (m_rightPaneSideBarWidget) {
        // This is called when setSource on the central widget is called.
        // Avoid nested setSource calls (even of different help viewers) by scheduling the
        // sidebar viewer update on the event loop (QTCREATORBUG-12742)
        QMetaObject::invokeMethod(m_rightPaneSideBarWidget->currentViewer(), "setSource",
                                  Qt::QueuedConnection, Q_ARG(QUrl, newUrl));
    }
}

void HelpPlugin::fontChanged()
{
    if (!m_rightPaneSideBarWidget)
        createRightPaneContextViewer();

    QVariant fontSetting = LocalHelpManager::engineFontSettings();
    QFont font = fontSetting.isValid() ? fontSetting.value<QFont>()
                                       : m_rightPaneSideBarWidget->currentViewer()->viewerFont();

    m_rightPaneSideBarWidget->setViewerFont(font);
    m_centralWidget->setViewerFont(font);
}

void HelpPlugin::setupHelpEngineIfNeeded()
{
    m_helpManager->setEngineNeedsUpdate();
    if (ModeManager::currentMode() == m_mode
        || contextHelpOption() == Core::HelpManager::ExternalHelpAlways)
        m_helpManager->setupGuiHelpEngine();
}

bool HelpPlugin::canShowHelpSideBySide() const
{
    RightPanePlaceHolder *placeHolder = RightPanePlaceHolder::current();
    if (!placeHolder)
        return false;
    if (placeHolder->isVisible())
        return true;

    IEditor *editor = EditorManager::currentEditor();
    if (!editor)
        return true;
    QTC_ASSERT(editor->widget(), return true);
    if (!editor->widget()->isVisible())
        return true;
    if (editor->widget()->width() < 800)
        return false;
    return true;
}

HelpViewer *HelpPlugin::viewerForHelpViewerLocation(Core::HelpManager::HelpViewerLocation location)
{
    Core::HelpManager::HelpViewerLocation actualLocation = location;
    if (location == Core::HelpManager::SideBySideIfPossible)
        actualLocation = canShowHelpSideBySide() ? Core::HelpManager::SideBySideAlways
                                                 : Core::HelpManager::HelpModeAlways;

    if (actualLocation == Core::HelpManager::ExternalHelpAlways)
        return externalHelpViewer();

    if (actualLocation == Core::HelpManager::SideBySideAlways) {
        createRightPaneContextViewer();
        RightPaneWidget::instance()->setWidget(m_rightPaneSideBarWidget);
        RightPaneWidget::instance()->setShown(true);
        return m_rightPaneSideBarWidget->currentViewer();
    }

    QTC_CHECK(actualLocation == Core::HelpManager::HelpModeAlways);

    activateHelpMode(); // should trigger an createPage...
    HelpViewer *viewer = m_centralWidget->currentViewer();
    if (!viewer)
        viewer = OpenPagesManager::instance().createPage();
    return viewer;
}

HelpViewer *HelpPlugin::viewerForContextHelp()
{
    return viewerForHelpViewerLocation(contextHelpOption());
}

static QUrl findBestLink(const QMap<QString, QUrl> &links, QString *highlightId)
{
    if (highlightId)
        highlightId->clear();
    if (links.isEmpty())
        return QUrl();
    QUrl source = links.constBegin().value();
    // workaround to show the latest Qt version
    int version = 0;
    QRegExp exp(QLatin1String("(\\d+)"));
    foreach (const QUrl &link, links) {
        const QString &authority = link.authority();
        if (authority.startsWith(QLatin1String("com.trolltech."))
                || authority.startsWith(QLatin1String("org.qt-project."))) {
            if (exp.indexIn(authority) >= 0) {
                const int tmpVersion = exp.cap(1).toInt();
                if (tmpVersion > version) {
                    source = link;
                    version = tmpVersion;
                    if (highlightId)
                        *highlightId = source.fragment();
                }
            }
        }
    }
    return source;
}

void HelpPlugin::showContextHelp()
{
    if (ModeManager::currentMode() == m_mode)
        return;

    // Find out what to show
    QMap<QString, QUrl> links;
    QString idFromContext;
    if (IContext *context = Core::ICore::currentContextObject()) {
        idFromContext = context->contextHelpId();
        links = HelpManager::linksForIdentifier(idFromContext);
        // Maybe the id is already an URL
        if (links.isEmpty() && LocalHelpManager::isValidUrl(idFromContext))
            links.insert(idFromContext, idFromContext);
    }

    if (HelpViewer *viewer = viewerForContextHelp()) {
        QUrl source = findBestLink(links, &m_contextHelpHighlightId);
        if (!source.isValid()) {
            // No link found or no context object
            viewer->setSource(QUrl(Help::Constants::AboutBlank));
            viewer->setHtml(tr("<html><head><title>No Documentation</title>"
                "</head><body><br/><center>"
                "<font color=\"%1\"><b>%2</b></font><br/>"
                "<font color=\"%3\">No documentation available.</font>"
                "</center></body></html>")
                .arg(creatorTheme()->color(Theme::TextColorNormal).name())
                .arg(idFromContext)
                .arg(creatorTheme()->color(Theme::TextColorNormal).name()));
        } else {
            const QUrl &oldSource = viewer->source();
            if (source != oldSource) {
                viewer->stop();
                viewer->setSource(source); // triggers loadFinished which triggers id highlighting
            } else {
                viewer->scrollToAnchor(source.fragment());
            }
            viewer->setFocus();
            Core::ICore::raiseWindow(viewer);
        }
    }
}

void HelpPlugin::activateIndex()
{
    activateHelpMode();
    m_centralWidget->activateSideBarItem(QLatin1String(Constants::HELP_INDEX));
}

void HelpPlugin::activateContents()
{
    activateHelpMode();
    m_centralWidget->activateSideBarItem(QLatin1String(Constants::HELP_CONTENTS));
}

void HelpPlugin::highlightSearchTermsInContextHelp()
{
    if (m_contextHelpHighlightId.isEmpty())
        return;
    HelpViewer *viewer = viewerForContextHelp();
    QTC_ASSERT(viewer, return);
    viewer->highlightId(m_contextHelpHighlightId);
    m_contextHelpHighlightId.clear();
}

void HelpPlugin::handleHelpRequest(const QUrl &url, Core::HelpManager::HelpViewerLocation location)
{
    if (HelpViewer::launchWithExternalApp(url))
        return;

    QString address = url.toString();
    if (!HelpManager::findFile(url).isValid()) {
        if (address.startsWith(QLatin1String("qthelp://org.qt-project."))
            || address.startsWith(QLatin1String("qthelp://com.nokia."))
            || address.startsWith(QLatin1String("qthelp://com.trolltech."))) {
                // local help not installed, resort to external web help
                QString urlPrefix = QLatin1String("http://qt-project.org/doc/");
                if (url.authority() == QLatin1String("org.qt-project.qtcreator"))
                    urlPrefix.append(QString::fromLatin1("qtcreator"));
                else
                    urlPrefix.append(QLatin1String("latest"));
            address = urlPrefix + address.mid(address.lastIndexOf(QLatin1Char('/')));
        }
    }

    const QUrl newUrl(address);
    HelpViewer *viewer = viewerForHelpViewerLocation(location);
    QTC_ASSERT(viewer, return);
    viewer->setSource(newUrl);
    Core::ICore::raiseWindow(viewer);
}

void HelpPlugin::slotOpenSupportPage()
{
    showLinkInHelpMode(QUrl(QLatin1String("qthelp://org.qt-project.qtcreator/doc/technical-support.html")));
}

void HelpPlugin::slotReportBug()
{
    QDesktopServices::openUrl(QUrl(QLatin1String("https://bugreports.qt.io")));
}

void HelpPlugin::doSetupIfNeeded()
{
    m_helpManager->setupGuiHelpEngine();
    if (m_setupNeeded) {
        qApp->processEvents();
        resetFilter();
        m_setupNeeded = false;
        OpenPagesManager::instance().setupInitialPages();
    }
}

Core::HelpManager::HelpViewerLocation HelpPlugin::contextHelpOption() const
{
    QSettings *settings = Core::ICore::settings();
    const QString key = QLatin1String(Help::Constants::ID_MODE_HELP) + QLatin1String("/ContextHelpOption");
    if (settings->contains(key))
        return Core::HelpManager::HelpViewerLocation(
                    settings->value(key, Core::HelpManager::SideBySideIfPossible).toInt());

    const QHelpEngineCore &engine = LocalHelpManager::helpEngine();
    return Core::HelpManager::HelpViewerLocation(engine.customValue(QLatin1String("ContextHelpOption"),
        Core::HelpManager::SideBySideIfPossible).toInt());
}
