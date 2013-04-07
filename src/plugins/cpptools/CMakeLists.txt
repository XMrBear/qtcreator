include(QtcPlugin)

set(target CppTools)

set(sources
    abstracteditorsupport.cpp
    builtinindexingsupport.cpp
    commentssettings.cpp
    completionsettingspage.cpp
    cppchecksymbols.cpp
    cppclassesfilter.cpp
    cppcodeformatter.cpp
    cppcodestylepreferences.cpp
    cppcodestylepreferencesfactory.cpp
    cppcodestylesettings.cpp
    cppcodestylesettingspage.cpp
    cppcompletionassist.cpp
    cppcompletionassistprovider.cpp
    cppcompletionsupport.cpp
    cppcurrentdocumentfilter.cpp
    cppdoxygen.cpp
    cppfilesettingspage.cpp
    cppfindreferences.cpp
    cppfunctionsfilter.cpp
    cpphighlightingsupport.cpp
    cpphighlightingsupportinternal.cpp
    cppindexingsupport.cpp
    cpplocalsymbols.cpp
    cpplocatorfilter.cpp
    cppmodelmanager.cpp
    cpppointerdeclarationformatter.cpp
    cppqtstyleindenter.cpp
    cpprefactoringchanges.cpp
    cppsemanticinfo.cpp
    cpptoolseditorsupport.cpp
    cpptoolsplugin.cpp
    cpptoolsreuse.cpp
    cpptoolssettings.cpp
    doxygengenerator.cpp
    insertionpointlocator.cpp
    ModelManagerInterface.cpp
    searchsymbols.cpp
    symbolfinder.cpp
    symbolsfindfilter.cpp
    TypeHierarchyBuilder.cpp
    uicodecompletionsupport.cpp
)

set(mocspecial
    cppcodeformatter.h
)

set(mocheaders
    ModelManagerInterface.h
    abstracteditorsupport.h
    completionsettingspage.h
    cppclassesfilter.h
    cppcodestylepreferences.h
    cppcodestylesettingspage.h
    cppcompletionassist.h
    cppcompletionassistprovider.h
    cppcurrentdocumentfilter.h
    cppfilesettingspage.h
    cppfindreferences.h
    cppfunctionsfilter.h
    cppindexingsupport.h
    cpplocatorfilter.h
    cppmodelmanager.h
    cpptoolseditorsupport.h
    cpptoolsplugin.h
    cpptoolssettings.h
    symbolsfindfilter.h
    uicodecompletionsupport.h
)

set(uifiles
    completionsettingspage.ui
    cppcodestylesettingspage.ui
    cppfilesettingspage.ui
)

qt_wrap_cpp(qtsrcs ${mocspecial})
qt_wrap_cpp(qtsrcs ${mocheaders})
qt_wrap_ui(qtincs ${uifiles})

qtc_set_pch(${target} ../../shared/qtcreator_gui_pch.h)
qtc_add_plugin(${target}
    ${sources}
    ${qtsrcs}
    ${qtincs}
)

qt_use_modules(${target} LINK_PRIVATE Widgets Concurrent)
qtc_use_pch(${target} ${sources} ${qtsrcs})

target_compile_definitions(${target} PRIVATE -DCPPTOOLS_LIBRARY)
target_link_libraries(${target} LINK_PUBLIC CPlusPlus LINK_PRIVATE TextEditor ProjectExplorer)
target_include_directories(${target} PRIVATE
    ../../libs/3rdparty
    ../../libs/3rdparty/cplusplus
    ../../libs/cplusplus
)

#qt_detect_moc_files("" h cpp)
