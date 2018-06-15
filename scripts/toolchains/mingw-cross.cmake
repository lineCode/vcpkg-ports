set(HOST x86_64-w64-mingw32)
set(CROSS ${HOST}-)
set(CMAKE_C_COMPILER ${CROSS}gcc)
set(CMAKE_CXX_COMPILER ${CROSS}g++)
set(CMAKE_ASM_COMPILER ${CROSS}as)
set(CMAKE_RC_COMPILER ${CROSS}windres CACHE STRING "")
set(CMAKE_Fortran_COMPILER ${CROSS}gfortran CACHE STRING "")

if (UNIX)
    set(CMAKE_SYSROOT /tools/toolchains/x86_64-w64-mingw32/x86_64-w64-mingw32/sysroot)
elseif (APPLE)
    set(CMAKE_SYSROOT /usr/local/opt/mingw-w64/toolchain-x86_64/x86_64-w64-mingw32)
endif ()

get_property( _CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )
if(NOT _CMAKE_IN_TRY_COMPILE)
    set(CMAKE_CXX_FLAGS "${VCPKG_CXX_FLAGS}" CACHE STRING "")
    set(CMAKE_C_FLAGS "${VCPKG_C_FLAGS}" CACHE STRING "")

    set(CMAKE_CXX_FLAGS_DEBUG "${VCPKG_CXX_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_C_FLAGS_DEBUG "${VCPKG_C_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_RELEASE "${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")
    set(CMAKE_C_FLAGS_RELEASE "${VCPKG_C_FLAGS_RELEASE}" CACHE STRING "")

    set(CMAKE_SHARED_LINKER_FLAGS "${VCPKG_LINKER_FLAGS}" CACHE STRING "")
    set(CMAKE_MODULE_LINKER_FLAGS "${VCPKG_LINKER_FLAGS}" CACHE STRING "")
    set(CMAKE_EXE_LINKER_FLAGS "${VCPKG_LINKER_FLAGS}" CACHE STRING "")

    if (VCPKG_HIDDEN_SYMBOL_VISIBILITY)
        set(CMAKE_CXX_VISIBILITY_PRESET hidden)
        set(CMAKE_VISIBILITY_INLINES_HIDDEN)
    endif()
endif()