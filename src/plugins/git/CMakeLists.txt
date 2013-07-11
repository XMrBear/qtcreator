include(QtcPlugin)

set(target Git)

set(sources
    annotationhighlighter.cpp
    branchadddialog.cpp
    branchadddialog.cpp
    branchcheckoutdialog.cpp
    branchdialog.cpp
    branchmodel.cpp
    changeselectiondialog.cpp
    clonewizard.cpp
    clonewizardpage.cpp
    commitdata.cpp
    gitclient.cpp
    giteditor.cpp
    githighlighters.cpp
    gitplugin.cpp
    gitsettings.cpp
    gitsubmiteditor.cpp
    gitsubmiteditorwidget.cpp
    gitutils.cpp
    gitversioncontrol.cpp
    logchangedialog.cpp
    mergetool.cpp
    remotedialog.cpp
    remotemodel.cpp
    settingspage.cpp
    stashdialog.cpp
)

set(mocsources
    gitclient.cpp
)

set(mocheaders
    annotationhighlighter.h
    branchadddialog.h
    branchcheckoutdialog.h
    branchdialog.h
    branchmodel.h
    changeselectiondialog.h
    clonewizard.h
    clonewizardpage.h
    gitclient.h
    giteditor.h
    gitplugin.h
    gitsubmiteditor.h
    gitsubmiteditorwidget.h
    gitversioncontrol.h
    logchangedialog.h
    mergetool.h
    remotedialog.h
    remotemodel.h
    settingspage.h
    stashdialog.h
)

set(uifiles
    branchadddialog.ui
    branchadddialog.ui
    branchcheckoutdialog.ui
    branchdialog.ui
    gitsubmitpanel.ui
    remoteadditiondialog.ui
    remotedialog.ui
    settingspage.ui
    stashdialog.ui
)

set(qrcfiles
    git.qrc
)

qt_add_resources(qtsrcs ${qrcfiles})
qt_wrap_cpp(qtsrcs ${mocheaders})
qt_generate_moc(qtincs ${mocsources})
qt_wrap_ui(qtincs ${uifiles})

set(depends TextEditor VcsBase DiffEditor)
qtc_set_pch(${target} ../../shared/qtcreator_gui_pch.h)
qtc_add_plugin(${target}
    ${sources}
    ${qtsrcs}
    ${qtincs}
)

qt_use_modules(${target} LINK_PRIVATE Widgets Concurrent)
qtc_use_pch(${target} ${sources} ${qtsrcs})

target_link_libraries(${target} LINK_PRIVATE ${depends})

#qt_detect_moc_files("" h cpp)
