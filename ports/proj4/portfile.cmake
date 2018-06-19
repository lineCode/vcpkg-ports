include(vcpkg_common_functions)
set(MAJOR 5)
set(MINOR 1)
set(REVISION 0)
set(VERSION ${MAJOR}.${MINOR}.${REVISION})
set(PACKAGE proj-${VERSION}.tar.gz)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/proj-${VERSION})
vcpkg_download_distfile(ARCHIVE
    URLS "http://download.osgeo.org/proj/${PACKAGE}"
    FILENAME "${PACKAGE}"
    SHA512 6e851485c03ca0b3b82e1dcff88a024990551919e203083c46ce6d14f824daed89fa774a2edf1ec543370a3f9792d6502f3037992496984912d8fa4ba7a37859
)
vcpkg_extract_source_archive(${ARCHIVE})

if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    list(APPEND CMAKE_OPTIONS "-DBUILD_LIBPROJ_SHARED=YES")
else()
    list(APPEND CMAKE_OPTIONS "-DBUILD_LIBPROJ_SHARED=NO")
endif()

if (NOT VCPKG_CMAKE_SYSTEM_NAME OR VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Windows" OR VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    vcpkg_replace_string(${SOURCE_PATH}/src/lib_proj.cmake "if(WIN32)" "if(MSVC)")
    vcpkg_replace_string(${SOURCE_PATH}/cmake/ProjInstallPath.cmake "set(DEFAULT_LIB_SUBDIR local/lib)" "set(DEFAULT_LIB_SUBDIR lib)")
    vcpkg_replace_string(${SOURCE_PATH}/cmake/ProjInstallPath.cmake "set(DEFAULT_INCLUDE_SUBDIR local/include)" "set(DEFAULT_INCLUDE_SUBDIR include)")
    vcpkg_replace_string(${SOURCE_PATH}/cmake/ProjInstallPath.cmake "set(DEFAULT_CMAKE_SUBDIR local/lib/cmake/" "set(DEFAULT_CMAKE_SUBDIR lib/cmake/")
endif ()

vcpkg_replace_string(${SOURCE_PATH}/src/lib_proj.cmake
    "-DPROJ_LIB=\"\${CMAKE_INSTALL_PREFIX}/\${DATADIR}\""
    "-DPROJ_LIB=\"\${VCPKG_INSTALL_PREFIX}/\${DATADIR}\""
)

# disable for emscripten
set (THREAD_SUPPORT ON)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${CMAKE_OPTIONS}
        -DPROJ4_TESTS=OFF
        -DBUILD_NAD2BIN=OFF
        -DBUILD_PROJ=OFF
        -DBUILD_GEOD=OFF
        -DBUILD_CS2CS=OFF
        -DBUILD_CCT=OFF
        -DBUILD_GIE=OFF
        -DUSE_THREAD=${THREAD_SUPPORT}
        -DVCPKG_INSTALL_PREFIX=${CURRENT_INSTALLED_DIR}
    OPTIONS_DEBUG
        -DCMAKECONFIGDIR=${CURRENT_PACKAGES_DIR}/debug/share/${PORT}
    OPTIONS_RELEASE
        -DCMAKECONFIGDIR=${CURRENT_PACKAGES_DIR}/share/${PORT}
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

# Remove duplicate headers installed from debug build
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
# Remove data installed from debug build
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(RENAME ${CURRENT_PACKAGES_DIR}/share/${PORT}/COPYING ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright)
