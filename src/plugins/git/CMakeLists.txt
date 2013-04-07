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
    gitplugin.cpp
    gitsettings.cpp
    gitsubmiteditor.cpp
    gitsubmiteditorwidget.cpp
    gitutils.cpp
    gitversioncontrol.cpp
    mergetool.cpp
    remotedialog.cpp
    remotemodel.cpp
    resetdialog.cpp
    settingspage.cpp
    stashdialog.cpp
)

set(mocheaders
    annotationhighlighter.h
    branchadddialog.h
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
    mergetool.h
    remotedialog.h
    remotemodel.h
    resetdialog.h
    settingspage.h
    stashdialog.h
)

set(mocsources
    gitclient.cpp
)

set(uifiles
    branchadddialog.ui
    branchadddialog.ui
    branchcheckoutdialog.ui
    branchdialog.ui
    changeselectiondialog.ui
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

qtc_set_pch(${target} ../../shared/qtcreator_gui_pch.h)
qtc_add_plugin(${target}
    ${sources}
    ${qtsrcs}
    ${qtincs}
)

qt_use_modules(${target} LINK_PRIVATE Widgets Concurrent)
qtc_use_pch(${target} ${sources} ${qtsrcs})

target_link_libraries(${target} LINK_PRIVATE TextEditor VcsBase)

#qt_detect_moc_files("" h cpp)
