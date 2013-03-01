include(../../qtcreator.pri)

TEMPLATE  = subdirs

SUBDIRS   = \
    coreplugin \
    find \
    texteditor \
    cppeditor \
    diffeditor \
    bookmarks \
    projectexplorer \
    vcsbase \
    git \
    cpptools \
    locator \
    debugger \
    help \
    cmakeprojectmanager \
    classview \
    macros \
    todo

!win32:SUBDIRS += analyzerbase \
                  valgrind

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

