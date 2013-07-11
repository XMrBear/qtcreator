include(QtcPlugin)

set(target CMakeProjectManager)

set(sources
    cmakebuildconfiguration.cpp
    cmakeeditor.cpp
    cmakeeditorfactory.cpp
    cmakefilecompletionassist.cpp
    cmakehighlighter.cpp
    cmakelocatorfilter.cpp
    cmakeopenprojectwizard.cpp
    cmakeproject.cpp
    cmakeprojectmanager.cpp
    cmakeprojectnodes.cpp
    cmakeprojectplugin.cpp
    cmakerunconfiguration.cpp
    cmakeuicodemodelsupport.cpp
    cmakevalidator.cpp
    makestep.cpp
)

set(mocheaders
    cmakebuildconfiguration.h
    cmakeeditor.h
    cmakeeditorfactory.h
    cmakehighlighter.h
    cmakelocatorfilter.h
    cmakeopenprojectwizard.h
    cmakeproject.h
    cmakeprojectmanager.h
    cmakeprojectnodes.h
    cmakeprojectplugin.h
    cmakerunconfiguration.h
    cmakeuicodemodelsupport.h
    cmakevalidator.h
    makestep.h
)

set(qrcfiles
    cmakeproject.qrc
)

qt_add_resources(qtsrcs ${qrcfiles})
qt_wrap_cpp(qtsrcs ${mocheaders})

set(depends ProjectExplorer TextEditor CppTools)
qtc_set_pch(${target} ../../shared/qtcreator_gui_pch.h)
qtc_add_plugin(${target}
    ${sources}
    ${qtsrcs}
)

qt_use_modules(${target} LINK_PRIVATE Widgets Concurrent Network)
qtc_use_pch(${target} ${sources} ${qtsrcs})

target_include_directories(${target} PRIVATE ../../libs/3rdparty ../../libs/cplusplus)
target_link_libraries(${target} LINK_PRIVATE ${depends})

foreach(wizard plaincapp-cmake plaincppapp-cmake)
    file(COPY ${CMAKE_SOURCE_DIR}/share/qtcreator/templates/wizards/${wizard}
        DESTINATION ${CMAKE_BINARY_DIR}/share/qtcreator/templates/wizards
    )
    install(DIRECTORY ${CMAKE_SOURCE_DIR}/share/qtcreator/templates/wizards/${wizard}
        DESTINATION share/qtcreator/templates/wizards
    )
endforeach()

#qt_detect_moc_files("" h cpp)
