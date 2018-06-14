## # vcpkg_configure_autoconf
##
## Configure CMake for Debug and Release builds of a project.
##
## ## Usage
## ```cmake
## vcpkg_configure_autoconf(
##     SOURCE_PATH <${SOURCE_PATH}>
##     [OPTIONS <--option-for-all-builds>...]
##     [OPTIONS_RELEASE <--option-for-release>...]
##     [OPTIONS_DEBUG <--option-for-debug>...]
## )
## ```
##
## ## Parameters
## ### SOURCE_PATH
## Specifies the directory containing the configure script. By convention, this is usually set in the portfile as the variable `SOURCE_PATH`.
##
## ### OPTIONS
## Additional options passed to autoconf during the configuration.
##
## ### OPTIONS_RELEASE
## Additional options passed to autoconf during the Release configuration. These are in addition to `OPTIONS`.
##
## ### OPTIONS_DEBUG
## Additional options passed to autoconf during the Debug configuration. These are in addition to `OPTIONS`.
##
## ## Notes
## This command supplies many common arguments to autoconf. To see the full list, examine the source.
##
set (_csc_CURRENT_LIST_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE PATH "")

function(vcpkg_configure_autoconf)
    cmake_parse_arguments(_csc "IN_SOURCE" "SOURCE_PATH;SOURCE_PATH_DEBUG;SOURCE_PATH_RELEASE" "OPTIONS;OPTIONS_DEBUG;OPTIONS_RELEASE" ${ARGN})

    if(DEFINED ENV{PROCESSOR_ARCHITEW6432})
        set(_csc_HOST_ARCHITECTURE $ENV{PROCESSOR_ARCHITEW6432})
    else()
        set(_csc_HOST_ARCHITECTURE $ENV{PROCESSOR_ARCHITECTURE})
    endif()

    file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)

    if((NOT DEFINED VCPKG_CXX_FLAGS_DEBUG AND NOT DEFINED VCPKG_C_FLAGS_DEBUG) OR
        (DEFINED VCPKG_CXX_FLAGS_DEBUG AND DEFINED VCPKG_C_FLAGS_DEBUG))
    else()
        message(FATAL_ERROR "You must set both the VCPKG_CXX_FLAGS_DEBUG and VCPKG_C_FLAGS_DEBUG")
    endif()
    if((NOT DEFINED VCPKG_CXX_FLAGS_RELEASE AND NOT DEFINED VCPKG_C_FLAGS_RELEASE) OR
        (DEFINED VCPKG_CXX_FLAGS_RELEASE AND DEFINED VCPKG_C_FLAGS_RELEASE))
    else()
        message(FATAL_ERROR "You must set both the VCPKG_CXX_FLAGS_RELEASE and VCPKG_C_FLAGS_RELEASE")
    endif()
    if((NOT DEFINED VCPKG_CXX_FLAGS AND NOT DEFINED VCPKG_C_FLAGS) OR
        (DEFINED VCPKG_CXX_FLAGS AND DEFINED VCPKG_C_FLAGS))
    else()
        message(FATAL_ERROR "You must set both the VCPKG_CXX_FLAGS and VCPKG_C_FLAGS")
    endif()

    if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" OR NOT DEFINED VCPKG_CMAKE_SYSTEM_NAME)
        include(${VCPKG_ROOT_DIR}/scripts/toolchains/windows.cmake)
    elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux")
        include(${VCPKG_ROOT_DIR}/scripts/toolchains/linux.cmake)
    elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Android")
        include(${VCPKG_ROOT_DIR}/scripts/toolchains/android.cmake)
    elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        message(STATUS "include osx toolchain")
        include(${VCPKG_ROOT_DIR}/scripts/toolchains/osx.cmake)
    elseif (VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Windows" AND CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
        set(CMAKE_CROSSCOMPILING ON CACHE BOOL "")
    endif()

    foreach (_variableName ${_variableNames})
        message(STATUS "${_variableName}=${${_variableName}}")
    endforeach()

    # list(APPEND _csc_OPTIONS
    #     "-DVCPKG_TARGET_TRIPLET=${TARGET_TRIPLET}"
    #     "-DVCPKG_PLATFORM_TOOLSET=${VCPKG_PLATFORM_TOOLSET}"
    #     "-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON"
    #     "-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON"
    #     "-DCMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY=ON"
    #     "-DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=TRUE"
    #     "-DCMAKE_VERBOSE_MAKEFILE=ON"
    #     "-DVCPKG_APPLOCAL_DEPS=OFF"
    #     "-DCMAKE_TOOLCHAIN_FILE=${VCPKG_ROOT_DIR}/scripts/buildsystems/vcpkg.cmake"
    #     "-DCMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION=ON"
    #     "-DVCPKG_CXX_FLAGS=${VCPKG_CXX_FLAGS}"
    #     "-DVCPKG_CXX_FLAGS_RELEASE=${VCPKG_CXX_FLAGS_RELEASE}"
    #     "-DVCPKG_CXX_FLAGS_DEBUG=${VCPKG_CXX_FLAGS_DEBUG}"
    #     "-DVCPKG_C_FLAGS=${VCPKG_C_FLAGS}"
    #     "-DVCPKG_C_FLAGS_RELEASE=${VCPKG_C_FLAGS_RELEASE}"
    #     "-DVCPKG_C_FLAGS_DEBUG=${VCPKG_C_FLAGS_DEBUG}"
    #     "-DVCPKG_CRT_LINKAGE=${VCPKG_CRT_LINKAGE}"
    #     "-DVCPKG_LINKER_FLAGS=${VCPKG_LINKER_FLAGS}"
    #     "-DCMAKE_INSTALL_LIBDIR:STRING=lib"
    #     "-DCMAKE_INSTALL_BINDIR:STRING=bin"
    # )

    SET(CFLAGS)
    SET(CXXFLAGS)

    if (CMAKE_C_FLAGS_INIT)
        set (_ac_CFLAGS ${CMAKE_C_FLAGS_INIT})
    else ()
        set (_ac_CFLAGS ${CMAKE_C_FLAGS_INIT})
    endif ()

    if (CMAKE_C_FLAGS_INIT_DEBUG)
        set (_ac_CFLAGS_DEBUG ${CMAKE_C_FLAGS_INIT_DEBUG})
    else ()
        set (_ac_CFLAGS_DEBUG -g)
    endif ()

    if (CMAKE_C_FLAGS_INIT_RELEASE)
        set (_ac_CFLAGS_RELEASE ${CMAKE_C_FLAGS_INIT_RELEASE})
    else ()
        set (_ac_CFLAGS_RELEASE -O3 -DNDEBUG)
    endif ()

    if (CMAKE_CCC_FLAGS_INIT_DEBUG)
        set (_ac_CXXFLAGS_DEBUG ${CMAKE_CXX_FLAGS_INIT_DEBUG})
    else ()
        set (_ac_CXXFLAGS_DEBUG -g)
    endif ()

    if (CMAKE_C_FLAGS_INIT_RELEASE)
        set (_ac_CXXFLAGS_RELEASE ${CMAKE_CXX_FLAGS_INIT_RELEASE})
    else ()
        set (_ac_CXXFLAGS_RELEASE -O3 -DNDEBUG)
    endif ()

    if (CMAKE_CXX_FLAGS_INIT)
        set (_ac_CXXFLAGS ${CMAKE_CXX_FLAGS_INIT})
    endif ()

    if (CMAKE_C_VISIBILITY_PRESET)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=${CMAKE_C_VISIBILITY_PRESET}")
    endif ()

    if (CMAKE_CXX_VISIBILITY_PRESET)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=${CMAKE_CXX_VISIBILITY_PRESET}")
    endif ()

    if (CMAKE_VISIBILITY_INLINES_HIDDEN)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility-inlines-hidden")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility-inlines-hidden")
    endif ()

    if (CMAKE_POSITION_INDEPENDENT_CODE)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
    endif ()

    if (CMAKE_SYSROOT)
        set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} --sysroot=${CMAKE_SYSROOT})
        set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} --sysroot=${CMAKE_SYSROOT})
    endif ()

    message(STATUS "CROSS: ${CMAKE_CROSSCOMPILING}")
    if (CMAKE_CROSSCOMPILING OR HOST MATCHES ".*-musl")
        set(HOST_ARG --host=${HOST})
    endif ()

    set (_ac_CFLAGS_REL ${_ac_CFLAGS} ${_ac_CFLAGS_RELEASE})
    set (_ac_CXXFLAGS_REL ${_ac_CXXFLAGS} ${_ac_CXXFLAGS_RELEASE})
    set (_ac_CFLAGS_DEB ${_ac_CFLAGS} ${_ac_CFLAGS_DEBUG})
    set (_ac_CXXFLAGS_DEB ${_ac_CXXFLAGS} ${_ac_CXXFLAGS_DEBUG})

    message(STATUS "PIC: ${CMAKE_POSITION_INDEPENDENT_CODE}")
    message(STATUS "Visibility C: ${CMAKE_C_VISIBILITY_PRESET}")
    message(STATUS "Visibility C++: ${CMAKE_CXX_VISIBILITY_PRESET}")

    if (CMAKE_EXE_LINKER_FLAGS)
        STRING(REPLACE ";" " " EXPORT_LDFLAGS "${CMAKE_EXE_LINKER_FLAGS}")
    endif ()

    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        if (_csc_SOURCE_PATH_DEBUG)
            set (SOURCE_DIR ${_csc_SOURCE_PATH_DEBUG})
        elseif(_csc_SOURCE_PATH)
            set (SOURCE_DIR ${_csc_SOURCE_PATH})
        else ()
            message (FATAL_ERROR "No valid debug SOURCE_PATH provided")
        endif ()

        if (_csc_IN_SOURCE)
            set (WORKING_DIR ${SOURCE_DIR})
        else ()
            set (WORKING_DIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)
        endif ()

        STRING(REPLACE ";" " " EXPORT_CFLAGS "${_ac_CFLAGS_DEB}")
        STRING(REPLACE ";" " " EXPORT_CXXFLAGS "${_ac_CXXFLAGS_DEB}")
        set(EXPORT_CPPFLAGS "${EXPORT_CFLAGS}")
        configure_file(${_csc_CURRENT_LIST_DIR}/runconfigure.sh.in ${WORKING_DIR}/runconfigure.sh)

        set(command
            ${WORKING_DIR}/runconfigure.sh
            ${HOST_ARG}
            "${_csc_OPTIONS}"
            "${_csc_OPTIONS_DEBUG}"
            --enable-debug
            --prefix=${CURRENT_PACKAGES_DIR}/debug
        )
        
        message(STATUS "Autoconf deb cmd ${command}")

        message(STATUS "Configuring ${TARGET_TRIPLET}-dbg in ${WORKING_DIR}")
        message(STATUS "CFLAGS: ${EXPORT_CFLAGS}")
        message(STATUS "CXXFLAGS: ${EXPORT_CXXFLAGS}")
        message(STATUS "LDFLAGS: ${EXPORT_LDFLAGS}")
        file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)
        
        vcpkg_execute_required_process(
            COMMAND ${command}
            WORKING_DIRECTORY ${WORKING_DIR}
            LOGNAME config-${TARGET_TRIPLET}-dbg
        )
        message(STATUS "Configuring ${TARGET_TRIPLET}-dbg done")
    endif()

    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        if (_csc_SOURCE_PATH_RELEASE)
            set (SOURCE_DIR ${_csc_SOURCE_PATH_RELEASE})
        elseif(_csc_SOURCE_PATH)
            set (SOURCE_DIR ${_csc_SOURCE_PATH})
        else ()
            message (FATAL_ERROR "No valid release SOURCE_PATH provided")
        endif ()

        if (_csc_IN_SOURCE)
            set (WORKING_DIR ${SOURCE_DIR})
        else ()
            set (WORKING_DIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
        endif ()

        STRING(REPLACE ";" " " EXPORT_CFLAGS "${_ac_CFLAGS_REL}")
        STRING(REPLACE ";" " " EXPORT_CXXFLAGS "${_ac_CXXFLAGS_REL}")
        set(EXPORT_CPPFLAGS "${EXPORT_CFLAGS}")
        configure_file(${_csc_CURRENT_LIST_DIR}/runconfigure.sh.in ${WORKING_DIR}/runconfigure.sh)

        set(command
            ${WORKING_DIR}/runconfigure.sh
                ${HOST_ARG}    
                "${_csc_OPTIONS}"
                "${_csc_OPTIONS_RELEASE}"
                --prefix=${CURRENT_PACKAGES_DIR}
        )

        message(STATUS "Autoconf rel cmd ${command}")
        message(STATUS "Configuring ${TARGET_TRIPLET}-rel in ${WORKING_DIR}")
        message(STATUS "CFLAGS: ${EXPORT_CFLAGS}")
        message(STATUS "CXXFLAGS: ${EXPORT_CXXFLAGS}")
        message(STATUS "LDFLAGS: ${EXPORT_LDFLAGS}")
        file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)

        vcpkg_execute_required_process(
            COMMAND ${command}
            WORKING_DIRECTORY ${WORKING_DIR}
            LOGNAME config-${TARGET_TRIPLET}-rel
        )
        message(STATUS "Configuring ${TARGET_TRIPLET}-rel done")
    endif()
endfunction()
