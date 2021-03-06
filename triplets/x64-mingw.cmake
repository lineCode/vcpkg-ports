set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)
set(CMAKE_SYSTEM_NAME Windows)
set(VCPKG_CMAKE_SYSTEM_NAME Windows)

set(VCPKG_LINKER_FLAGS "-static" CACHE STRING "")

set(HOST x86_64-w64-mingw32)
set(CROSS ${HOST}-)
set(VCPKG_C_COMPILER ${CROSS}gcc)
set(VCPKG_CXX_COMPILER ${CROSS}g++)
set(VCPKG_ASM_COMPILER ${CROSS}as)
set(VCPKG_RC_COMPILER ${CROSS}windres CACHE STRING "")
set(VCPKG_AR ${CROSS}ar)
set(VCPKG_RANLIB ${CROSS}ranlib)
set(VCPKG_Fortran_COMPILER ${CROSS}gfortran CACHE STRING "")
set(LINKER_EXECUTABLE ${CROSS}ld CACHE FILEPATH "")

if (UNIX)
    set(VCPKG_SYSROOT /tools/toolchains/x86_64-w64-mingw32/x86_64-w64-mingw32/sysroot)
elseif (APPLE)
    set(VCPKG_SYSROOT /usr/local/opt/mingw-w64/toolchain-x86_64/x86_64-w64-mingw32)
endif ()