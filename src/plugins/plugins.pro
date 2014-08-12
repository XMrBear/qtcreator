include(../../qtcreator.pri)

TEMPLATE  = subdirs

SUBDIRS   = \
    coreplugin \
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

minQtVersion(5, 0, 0) {
    isEmpty(QBS_INSTALL_DIR): QBS_INSTALL_DIR = $$(QBS_INSTALL_DIR)
    exists(../shared/qbs/qbs.pro)|!isEmpty(QBS_INSTALL_DIR): \
        SUBDIRS += \
            qbsprojectmanager
}

!win32:SUBDIRS += \
    valgrind \
    android

# prefer qmake variable set on command line over env var
isEmpty(LLVM_INSTALL_DIR):LLVM_INSTALL_DIR=$$(LLVM_INSTALL_DIR)
!isEmpty(LLVM_INSTALL_DIR) {
    SUBDIRS += clangcodemodel
}

minQtVersion(5, 3, 1) {
    SUBDIRS += qmldesigner
} else {
     warning("QmlDesigner plugin has been disabled.")
     warning("This plugin requires Qt 5.3.1 or newer.")
}

minQtVersion(5, 2, 0) {
    SUBDIRS += \
        qmlprofiler \
        welcome
} else {
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

linux-* {
     SUBDIRS += debugger/ptracepreload.pro
}
