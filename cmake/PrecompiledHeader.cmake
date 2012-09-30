# TODO: missing clang support
cmake_minimum_required(VERSION 2.8.9 FATAL_ERROR)

macro(set_precompiled_header target language precompiledHeader precompiledSource)
    if(TARGET ${target})
        message(FATAL_ERROR "The first argument must be an non-existent target.")
    endif()
    set(${target}_PCH_LANGUAGE ${language}
        CACHE INTERNAL "Which language (C/CXX) using for PCH support"
    )
    get_source_file_property(pchHeaderFile ${precompiledHeader} LOCATION)
    message(STATUS "[${target}] Precompiled header is \"${pchHeaderFile}\"")
    set(${target}_PCH_HEADER_FILE ${pchHeaderFile}
        CACHE INTERNAL "Precompiled header file"
    )
    if(MSVC)
        if(${language} STREQUAL CXX)
            set(${precompiledSource} ${target}_pch.cpp)
        elseif(${language} STREQUAL C)
            set(${precompiledSource} ${target}_pch.c)
        else()
            message(FATAL_ERROR "[${target}] Unknown language \"${language}\"")
            return()
        endif()
        set(${target}_PCH_SOURCE_VAR ${precompiledSource}
            CACHE INTERNAL "Precompiled source file variable"
        )
        if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/${${precompiledSource}})
            file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${${precompiledSource}}
                "/* This file is autogenerated, do not edit! */\n"
                "#include \"${pchHeaderFile}\"\n"
            )
        endif()
        add_custom_target(${target}_pch)
        add_custom_command(TARGET ${target}_pch POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E touch_nocreate ${CMAKE_CURRENT_BINARY_DIR}/${${precompiledSource}}
            COMMENT "[${target}] Update precompiled source - done"
        )
    endif()
endmacro()

macro(use_precompiled_header target)
    if(NOT TARGET ${target})
        message(FATAL_ERROR "The first argument must be an existing target.")
    endif()
    get_target_property(targetAutomoc ${target} AUTOMOC)
    if(CMAKE_AUTOMOC OR targetAutomoc)
        set(automocFile ${target}_automoc.cpp)
        if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/${automocFile})
            file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/${automocFile}
                "/* This file is autogenerated, do not edit! */\n"
            )
        endif()
    endif()
    if(MSVC)
        add_msvc_precompiled_header(${target})
        use_msvc_precompiled_header(${target} ${ARGN} ${automocFile})
    elseif(CMAKE_COMPILER_IS_GNUC OR CMAKE_COMPILER_IS_GNUCXX OR MINGW)
        add_gcc_precompiled_header(${target})
        use_gcc_precompiled_header(${target} ${ARGN} ${automocFile})
    endif()
endmacro()

function(add_msvc_precompiled_header target)
    set(pchBinaryFile ${CMAKE_CURRENT_BINARY_DIR}/${target}_pch.pch)
    set_source_files_properties(${${${target}_PCH_SOURCE_VAR}} PROPERTIES
        COMPILE_FLAGS "/Yc\"${${target}_PCH_HEADER_FILE}\" /Fp\"${pchBinaryFile}\""
        OBJECT_OUTPUTS ${pchBinaryFile}
    )
    message(STATUS "[${target}] Precompiled binary is \"${pchBinaryFile}\"")
    set(${target}_PCH_BINARY_FILE ${pchBinaryFile}
        CACHE INTERNAL "Precompiled binary file"
    )
endfunction()

function(use_msvc_precompiled_header target)
    if(NOT ${target}_PCH_BINARY_FILE)
        message(FATAL_ERROR "[${target}] Precompiled binary does not exist")
        return()
    endif()
    get_target_property(targetSources ${target} SOURCES)
    list(FIND targetSources ${${${target}_PCH_SOURCE_VAR}} result)
    if(result EQUAL -1)
        message(FATAL_ERROR "[${target}] Please add '\${${${target}_PCH_SOURCE_VAR}}' or '${${${target}_PCH_SOURCE_VAR}}' to target")
        return()
    endif()
    set(pchBinaryFile ${${target}_PCH_BINARY_FILE})
    set_property(SOURCE ${ARGN} APPEND_STRING PROPERTY
        COMPILE_FLAGS "/Yu\"${pchBinaryFile}\" /FI\"${pchBinaryFile}\" /Fp\"${pchBinaryFile}\""
    )
    set_property(SOURCE ${ARGN} APPEND PROPERTY
        OBJECT_DEPENDS ${pchBinaryFile}
    )
endfunction()

function(add_gcc_precompiled_header target)
    set(origPCHHeaderFile ${${target}_PCH_HEADER_FILE})
    get_filename_component(pchHeaderPath ${origPCHHeaderFile} PATH)
    if(NOT ${pchHeaderPath} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
        set(pchSearchPath -I"${pchHeaderPath}")
        separate_arguments(pchSearchPath)
    endif()
    set(pchHeaderName ${target}_pch.h)
    set(pchHeaderFile ${CMAKE_CURRENT_BINARY_DIR}/${pchHeaderName})
    set(pchBinaryFile ${CMAKE_CURRENT_BINARY_DIR}/${pchHeaderName}.gch)
    add_custom_command(OUTPUT ${pchHeaderFile}
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${origPCHHeaderFile} ${pchHeaderFile}
        DEPENDS ${origPCHHeaderFile}
        COMMENT "[${target}] Update precompiled header - done"
    )
    if(${${target}_PCH_LANGUAGE} STREQUAL CXX)
        set(pchGenerator -x c++-header -c ${pchHeaderFile} -o ${pchBinaryFile})
    else(${${target}_PCH_LANGUAGE} STREQUAL C)
        set(pchGenerator -x c-header -c ${pchHeaderFile} -o ${pchBinaryFile})
    else()
        message(FATAL_ERROR "[${target}] Unknown language \"${${target}_PCH_LANGUAGE}\"")
        return()
    endif()
    get_gcc_compile_flags(${target} compileFlags)
    message(STATUS "[${target}] PCH compile flags is ${compileFlags}")
    add_custom_command(OUTPUT ${pchBinaryFile}
        COMMAND ${CMAKE_CXX_COMPILER} ${${target}_PCH_FLAGS} ${compileFlags} ${pchSearchPath} ${pchGenerator}
        DEPENDS ${pchHeaderFile}
        COMMENT "[${target}] Compile precompiled binary - done"
    )
    add_custom_target(${target}_pch
        DEPENDS ${pchHeaderFile} ${pchBinaryFile}
    )
    add_dependencies(${target} ${target}_pch)
    message(STATUS "[${target}] Precompiled binary is \"${pchBinaryFile}\"")
    set(${target}_PCH_NEW_HEADER_FILE ${pchHeaderFile}
        CACHE INTERNAL "Precompiled header file copy"
    )
endfunction()

function(use_gcc_precompiled_header target)
    if(NOT ${target}_PCH_NEW_HEADER_FILE)
        message(FATAL_ERROR "[${target}] Precompiled header copy does not exist")
        return()
    endif()
    set(pchHeaderFile ${${target}_PCH_NEW_HEADER_FILE})
    set_property(SOURCE ${ARGN} APPEND_STRING PROPERTY
        COMPILE_FLAGS "-include \"${pchHeaderFile}\" -Winvalid-pch"
    )
    set_property(SOURCE ${ARGN} APPEND PROPERTY
        OBJECT_DEPENDS ${pchHeaderFile}
    )
endfunction()

function(get_gcc_compile_flags target flagsVar)
    string(TOUPPER "${CMAKE_BUILD_TYPE}" config)
    set(language ${${target}_PCH_LANGUAGE})
    # Collect options from CMake language variables
    if(CMAKE_${language}_FLAGS)
        list(APPEND compileFlags ${CMAKE_${language}_FLAGS})
    endif()
    if(CMAKE_${language}_FLAGS_${config})
        list(APPEND compileFlags ${CMAKE_${language}_FLAGS_${config}})
    endif()
    # Add option from CMake target type variable
    get_target_property(targetType ${target} TYPE)
    # handle POSITION_INDEPENDENT_CODE property introduced with CMake 2.8.9 if policy CMP0018 is turned on
    cmake_policy(GET CMP0018 _PIC_Policy)
    # Honor the POSITION_INDEPENDENT_CODE target property
    get_target_property(targetPIC ${target} POSITION_INDEPENDENT_CODE)
    if(targetPIC)
        if(targetType STREQUAL SHARED_LIBRARY)
            list(APPEND compileFlags ${CMAKE_${language}_COMPILE_OPTIONS_PIC})
        elseif(targetType STREQUAL EXECUTABLE)
            list(APPEND compileFlags ${CMAKE_${language}_COMPILE_OPTIONS_PIE})
        endif()
    endif()
    # Platform specific flags
    if(APPLE)
        get_target_property(architectures ${target} OSX_ARCHITECTURES_${config})
        if(NOT architectures)
            get_target_property(architectures ${target} OSX_ARCHITECTURES)
        endif()
        foreach(arch ${architectures})
            list(APPEND compileFlags -arch ${arch})
        endforeach()
        if(CMAKE_OSX_SYSROOT AND CMAKE_OSX_SYSROOT_DEFAULT AND CMAKE_${language}_HAS_ISYSROOT)
            if(NOT ${CMAKE_OSX_SYSROOT} STREQUAL ${CMAKE_OSX_SYSROOT_DEFAULT})
                list(APPEND compileFlags -isysroot ${CMAKE_OSX_SYSROOT})
            endif()
        endif()
        if(CMAKE_OSX_DEPLOYMENT_TARGET AND CMAKE_${language}_OSX_DEPLOYMENT_TARGET_FLAG)
            list(APPEND compileFlags ${CMAKE_${language}_OSX_DEPLOYMENT_TARGET_FLAG} ${CMAKE_OSX_DEPLOYMENT_TARGET})
        endif()
    endif()
    # Add current dir in the first order
    if(CMAKE_INCLUDE_CURRENT_DIR)
        list(APPEND compileFlags -I"${CMAKE_CURRENT_BINARY_DIR}")
        list(APPEND compileFlags -I"${CMAKE_CURRENT_SOURCE_DIR}")
    endif()
    # Add directory properties
    get_directory_property(defines COMPILE_DEFINITIONS)
    if(defines)
        foreach(item ${defines})
            list(APPEND compileFlags -D${item})
        endforeach()
    endif()
    get_directory_property(defines COMPILE_DEFINITIONS_${config})
    if(defines)
        foreach(item ${defines})
            list(APPEND compileFlags -D${item})
        endforeach()
    endif()
    get_directory_property(value ${target} INCLUDE_DIRECTORIES)
    if(value)
        foreach(item ${value})
            list(APPEND compileFlags -I"${item}")
        endforeach()
    endif()
    # Add target compile options
    get_target_property(targetflags ${target} COMPILE_FLAGS)
    if(targetflags)
        list(APPEND compileFlags ${targetflags})
    endif()
    # Add target compile definitions
    get_target_property(defines ${target} COMPILE_DEFINITIONS)
    if(defines)
        foreach(item ${defines})
            list(APPEND compileFlags -D${item})
        endforeach()
    endif()
    get_target_property(defines ${target} COMPILE_DEFINITIONS_${config})
    if(defines)
        foreach(item ${defines})
            list(APPEND compileFlags -D${item})
        endforeach()
    endif()
    # Add target include directories
    get_target_property(value ${target} INCLUDE_DIRECTORIES)
    if(value)
        foreach(item ${value})
            list(APPEND compileFlags -I"${item}")
        endforeach()
    endif()
    separate_arguments(compileFlags)
    set(${flagsVar} ${compileFlags} PARENT_SCOPE)
endfunction()

function(add_pch_compile_flags target)
    if(CMAKE_COMPILER_IS_GNUC OR CMAKE_COMPILER_IS_GNUCXX OR MINGW)
        set(${target}_PCH_FLAGS ${ARGN}
            CACHE INTERNAL "Prepend additional compile flags for Precompiled Header support"
        )
    endif()
endfunction()
