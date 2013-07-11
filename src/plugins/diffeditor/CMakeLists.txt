include(QtcPlugin)

set(target DiffEditor)

set(sources
    diffeditor.cpp
    diffeditorfactory.cpp
    diffeditorfile.cpp
    diffeditorplugin.cpp
    diffeditorwidget.cpp
    differ.cpp
    diffshoweditorfactory.cpp
    diffshoweditor.cpp
)

set(mocsources
    diffeditorwidget.cpp
    diffshoweditor.cpp
)

set(mocheaders
    diffeditorfactory.h
    diffeditorfile.h
    diffeditor.h
    diffeditorplugin.h
    diffeditorwidget.h
    diffshoweditorfactory.h
    diffshoweditor.h
)

qt_generate_moc(qtincs ${mocsources})
qt_wrap_cpp(qtsrcs ${mocheaders})

set(depends Core Find TextEditor)
qtc_set_pch(${target} ../../shared/qtcreator_gui_pch.h)
qtc_add_plugin(${target}
    ${sources}
    ${qtsrcs}
    ${qtincs}
)

qt_use_modules(${target} LINK_PRIVATE Widgets)
qtc_use_pch(${target} ${sources} ${qtsrcs})

target_compile_definitions(${target} PRIVATE -DDIFFEDITOR_LIBRARY)
target_link_libraries(${target} LINK_PRIVATE ${depends})

#qt_detect_moc_files("" h cpp)
