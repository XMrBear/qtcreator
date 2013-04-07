include(QtcPlugin)

set(target CppEditor)

set(sources
    cppplugin.cpp
    cppeditor.cpp
    cpphighlighter.cpp
    cpphoverhandler.cpp
    cppfilewizard.cpp
    cppclasswizard.cpp
    cppquickfixes.cpp
    cppoutline.cpp
    cppinsertdecldef.cpp
    cpptypehierarchy.cpp
    cppelementevaluator.cpp
    cppautocompleter.cpp
    cppcompleteswitch.cpp
    cppsnippetprovider.cpp
    cppinsertqtpropertymembers.cpp
    cppquickfixassistant.cpp
    cppquickfix.cpp
    cppfunctiondecldeflink.cpp
)

set(mocsources
    cppeditor.cpp
)

set(mocheaders
    cppclasswizard.h
    cppeditor.h
    cppfilewizard.h
    cppfunctiondecldeflink.h
    cpphighlighter.h
    cpphoverhandler.h
    cppinsertqtpropertymembers.h
    cppoutline.h
    cppplugin.h
    cppquickfix.h
    cpptypehierarchy.h
)

set(qrcfiles
    cppeditor.qrc
)

qt_add_resources(qtsrcs ${qrcfiles})
qt_wrap_cpp(qtsrcs ${mocheaders})
qt_generate_moc(qtincs ${mocsources})

qtc_set_pch(${target} ../../shared/qtcreator_gui_pch.h)
qtc_add_plugin(${target}
    ${sources}
    ${qtsrcs}
    ${qtincs}
)

qt_use_modules(${target} LINK_PRIVATE Widgets Concurrent)
qtc_use_pch(${target} ${sources} ${qtsrcs})

target_compile_definitions(${target} PRIVATE -DCPPEDITOR_LIBRARY)
target_link_libraries(${target} TextEditor CppTools ProjectExplorer)
target_include_directories(${target} PRIVATE
    ../../libs/3rdparty
    ../../libs/3rdparty/cplusplus
    ../../libs/cplusplus
)

#qt_detect_moc_files("" h cpp)
