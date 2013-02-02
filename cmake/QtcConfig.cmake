function(qtc_configure_file inFile outFile)
    if(${inFile} IS_NEWER_THAN ${outFile} OR VERSION_UPDATED)
        set(VERSION_UPDATED OFF)
        set(APP_VERSION ${QTCREATOR_VERSION} CACHE INTERNAL "Applicatin version")
        string(SUBSTRING ${QTCREATOR_VERSION} 0 1 majorVersion)
        string(SUBSTRING ${QTCREATOR_VERSION} 2 1 minorVersion)
        string(SUBSTRING ${QTCREATOR_VERSION} 4 2 releaseVersion)
        file(READ ${inFile} inContent)
        string(REPLACE "$$replace(QTCREATOR_VERSION, \"^(\\\\d+)\\\\.\\\\d+\\\\.\\\\d+(-.*)?$\", \\\\1)"
            ${majorVersion} inContent "${inContent}")
        string(REPLACE "$$replace(QTCREATOR_VERSION, \"^\\\\d+\\\\.(\\\\d+)\\\\.\\\\d+(-.*)?$\", \\\\1)"
            ${minorVersion} inContent "${inContent}")
        string(REPLACE "$$replace(QTCREATOR_VERSION, \"^\\\\d+\\\\.\\\\d+\\\\.(\\\\d+)(-.*)?$\", \\\\1)"
            ${releaseVersion} inContent "${inContent}")
        string(REPLACE "$\${QTCREATOR_VERSION}" ${QTCREATOR_VERSION} inContent "${inContent}")
        string(REPLACE "\\\"" "\"" inContent "${inContent}")
        file(WRITE ${outFile} "${inContent}")
    endif()
endfunction()

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(WINDOWS TRUE)
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(LINUX TRUE)
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(MACOSX TRUE)
endif()

if(CMAKE_COMPILER_IS_GNUC OR CMAKE_COMPILER_IS_GNUCXX)
    set(GCC TRUE)
endif()

set(QTC_PCH_SUPPORT ON
    CACHE BOOL "Precompiled Header support"
)
