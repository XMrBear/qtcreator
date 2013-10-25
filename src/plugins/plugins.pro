include(../../qtcreator.pri)

TEMPLATE  = subdirs

SUBDIRS   = \
    coreplugin \
    find \
    texteditor \
    cppeditor \
    bineditor \
    diffeditor \
    imageviewer \
    bookmarks \
    projectexplorer \
    vcsbase \
    git \
    cpptools \
    qtsupport \
    qmakeprojectmanager \
    locator \
    debugger \
    help \
    cmakeprojectmanager \
    resourceeditor \
    genericprojectmanager \
    qmljseditor \
    qmlprojectmanager \
    classview \
    analyzerbase \
    qmljstools \
    macros \
    todo

!win32:SUBDIRS += valgrind

isEmpty(QBS_INSTALL_DIR): QBS_INSTALL_DIR = $$(QBS_INSTALL_DIR)
exists(../shared/qbs/qbs.pro)|!isEmpty(QBS_INSTALL_DIR): \
    SUBDIRS += \
        qbsprojectmanager

minQtVersion(5, 2, 0) {
    SUBDIRS += \
        qmldesigner \
        qmlprofiler \
        welcome
} else {
     warning("QmlDesigner plugin has been disabled.")
     warning("QmlProfiler plugin has been disabled.")
     warning("Welcome plugin has been disabled.")
     warning("These plugins need at least Qt 5.2.")
}

for(p, SUBDIRS) {
    QTC_PLUGIN_DEPENDS =
    include($$p/$${p}_dependencies.pri)
    pv = $${p}.depends
    $$pv = $$QTC_PLUGIN_DEPENDS
}

SUBDIRS += debugger/dumper.pro
linux-* {
     SUBDIRS += debugger/ptracepreload.pro
}

include (debugger/lldblib/guest/qtcreator-lldb.pri)
