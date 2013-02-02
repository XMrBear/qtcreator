include(QtcPlugin)

set(target VcsBase)

add_definitions(-DVCSBASE_LIBRARY -DQT_NO_CAST_FROM_ASCII)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
include_directories(
    ../../libs/3rdparty
    ../../libs/3rdparty/cplusplus
    ../../libs/cplusplus
)

set(sources
    baseannotationhighlighter.cpp
    basecheckoutwizard.cpp
    basecheckoutwizardpage.cpp
    basevcseditorfactory.cpp
    basevcssubmiteditorfactory.cpp
    checkoutjobs.cpp
    checkoutprogresswizardpage.cpp
    checkoutwizarddialog.cpp
    cleandialog.cpp
    command.cpp
    commonsettingspage.cpp
    commonvcssettings.cpp
    corelistener.cpp
    diffhighlighter.cpp
    nicknamedialog.cpp
    submiteditorfile.cpp
    submiteditorwidget.cpp
    submitfieldwidget.cpp
    submitfilemodel.cpp
    vcsbaseclient.cpp
    vcsbaseclientsettings.cpp
    vcsbaseeditor.cpp
    vcsbaseeditorparameterwidget.cpp
    vcsbaseoptionspage.cpp
    vcsbaseoutputwindow.cpp
    vcsbaseplugin.cpp
    vcsbasesubmiteditor.cpp
    vcsconfigurationpage.cpp
    vcsplugin.cpp
)

set(mocheaders
    baseannotationhighlighter.h
    basecheckoutwizard.h
    basecheckoutwizardpage.h
    basevcseditorfactory.h
    basevcssubmiteditorfactory.h
    checkoutjobs.h
    checkoutprogresswizardpage.h
    checkoutwizarddialog.h
    cleandialog.h
    command.h
    commonsettingspage.h
    corelistener.h
    diffhighlighter.h
    nicknamedialog.h
    submiteditorfile.h
    submiteditorwidget.h
    submitfieldwidget.h
    submitfilemodel.h
    vcsbaseeditor.h
    vcsbaseeditorparameterwidget.h
    vcsbaseoutputwindow.h
    vcsbaseplugin.h
    vcsbasesubmiteditor.h
    vcsconfigurationpage.h
    vcsplugin.h
)

set(mocspecial
    vcsbaseclient.h
)

set(mocsources
    cleandialog.cpp
    submiteditorwidget.cpp
    vcsbaseeditor.cpp
    vcsbaseplugin.cpp
)

set(uifiles
    basecheckoutwizardpage.ui
    checkoutprogresswizardpage.ui
    cleandialog.ui
    commonsettingspage.ui
    nicknamedialog.ui
    submiteditorwidget.ui
)

set(qrcfiles
    vcsbase.qrc
)

qt_add_resources(qtsrcs ${qrcfiles})
qt_wrap_cpp(qtsrcs ${mocheaders})
qt_generate_moc_plus(qtincs moc_ .cpp ${mocspecial})
qt_generate_moc(qtincs ${mocsources})
qt_wrap_ui(qtincs ${uifiles})

qtc_set_pch(${target} ../../shared/qtcreator_gui_pch.h)
qtc_add_plugin(${target}
    ${sources}
    ${qtsrcs}
    ${qtincs}
)

target_link_libraries(${target} LINK_PRIVATE ProjectExplorer TextEditor CppTools)
qt_use_modules(${target} LINK_PRIVATE Widgets Concurrent)
qtc_use_pch(${target} ${sources} ${qtsrcs})

#qt_detect_moc_files("" h cpp)
