include(QtcPlugin)

set(target CppEditor)

set(sources
    cppautocompleter.cpp
    cppclasswizard.cpp
    cppeditor.cpp
    cppeditorplugin.cpp
    cppelementevaluator.cpp
    cppfilewizard.cpp
    cppfunctiondecldeflink.cpp
    cpphighlighter.cpp
    cpphoverhandler.cpp
    cppoutline.cpp
    cppquickfixassistant.cpp
    cppquickfix.cpp
    cppquickfixes.cpp
    cppsnippetprovider.cpp
    cpptypehierarchy.cpp
)

set(mocsources
    cppeditor.cpp
    cppquickfixes.cpp
)

set(mocheaders
    cppclasswizard.h
    cppeditor.h
    cppeditorplugin.h
    cppfilewizard.h
    cppfunctiondecldeflink.h
    cpphighlighter.h
    cpphoverhandler.h
    cppoutline.h
    cppquickfix.h
    cppquickfixes.h
    cpptypehierarchy.h
)

set(qrcfiles
    cppeditor.qrc
)

qt_add_resources(qtsrcs ${qrcfiles})
qt_wrap_cpp(qtsrcs ${mocheaders})
qt_generate_moc(qtincs ${mocsources})

set(depends TextEditor CppTools ProjectExplorer)
qtc_set_pch(${target} ../../shared/qtcreator_gui_pch.h)
qtc_add_plugin(${target}
    ${sources}
    ${qtsrcs}
    ${qtincs}
)

qt_use_modules(${target} LINK_PRIVATE Widgets Concurrent)
qtc_use_pch(${target} ${sources} ${qtsrcs})

target_compile_definitions(${target} PRIVATE -DCPPEDITOR_LIBRARY)
target_link_libraries(${target} ${depends})
target_include_directories(${target} PRIVATE
    ../../libs/3rdparty
    ../../libs/cplusplus
)

#qt_detect_moc_files("" h cpp)
