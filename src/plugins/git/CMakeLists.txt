include(QtcPlugin)

set(target Git)

add_definitions(-DQT_NO_CAST_FROM_ASCII)
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(sources
    annotationhighlighter.cpp
    branchadddialog.cpp
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
    remotedialog.cpp
    remotemodel.cpp
    resetdialog.cpp
    settingspage.cpp
    stashdialog.cpp
)

set(mocheaders
    annotationhighlighter.h
    branchadddialog.h
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

target_link_libraries(${target} LINK_PRIVATE TextEditor VcsBase)
qt_use_modules(${target} LINK_PRIVATE Widgets Concurrent)
qtc_use_pch(${target} ${sources} ${qtsrcs})

#qt_detect_moc_files("" h cpp)
