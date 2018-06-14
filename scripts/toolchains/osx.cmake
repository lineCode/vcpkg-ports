if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    set(CMAKE_CROSSCOMPILING OFF CACHE BOOL "")
endif()

get_property( _CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )
if(NOT _CMAKE_IN_TRY_COMPILE)
    set(CMAKE_CXX_FLAGS "${VCPKG_CXX_FLAGS}" CACHE STRING "")
    set(CMAKE_C_FLAGS "${VCPKG_C_FLAGS}" CACHE STRING "")

    set(CMAKE_CXX_FLAGS_DEBUG "${VCPKG_CXX_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_C_FLAGS_DEBUG "${VCPKG_C_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_RELEASE "${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")
    set(CMAKE_C_FLAGS_RELEASE "${VCPKG_C_FLAGS_RELEASE}" CACHE STRING "")

    set(CMAKE_SHARED_LINKER_FLAGS "${VCPKG_LINKER_FLAGS}" CACHE STRING "")
    set(CMAKE_EXE_LINKER_FLAGS "${VCPKG_LINKER_FLAGS}" CACHE STRING "")

    if (VCPKG_HIDDEN_SYMBOL_VISIBILITY)
        set(CMAKE_CXX_VISIBILITY_PRESET hidden)
        set(CMAKE_VISIBILITY_INLINES_HIDDEN)
    endif()

    if (VCPKG_C_COMPILER)
        set(CMAKE_C_COMPILER ${VCPKG_C_COMPILER})
    else ()
        set(CMAKE_C_COMPILER clang)
    endif ()
    
    if (VCPKG_CXX_COMPILER)
        set(CMAKE_CXX_COMPILER ${VCPKG_CXX_COMPILER})
    else ()
        set(CMAKE_CXX_COMPILER clang++)
    endif ()
    
    if (VCPKG_ASM_COMPILER)    
        set(VCPKG_ASM_COMPILER ${VCPKG_ASM_COMPILER})
    else ()
        set(CMAKE_ASM_COMPILER clang)
    endif ()
endif()