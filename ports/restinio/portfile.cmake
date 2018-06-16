include(vcpkg_common_functions)

set(VERSION_MAJOR 0)
set(VERSION_MINOR 4)
set(VERSION_REVISION 5.1)

set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_REVISION})
set(PACKAGE ${PORT}-${VERSION}-full.tar.bz2)

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${PORT}-${VERSION}-full)
vcpkg_download_distfile(ARCHIVE
    URLS "https://bitbucket.org/sobjectizerteam/${PORT}-${VERSION_MAJOR}.${VERSION_MINOR}/downloads/${PACKAGE}"
    FILENAME "${PACKAGE}"
    SHA512 053cb9f0d32f4dce73ec863f9222feaf0ebf43a5f92e87e9582b772f77c574fe0304cd1060d90220949b5265337186152e7e13ce50b6558e11e8c6148cb1f0b1
)

vcpkg_extract_source_archive(${ARCHIVE})
vcpkg_replace_string(${SOURCE_PATH}/dev/CMakeLists.txt "add_subdirectory(so_5)" "")
vcpkg_replace_string(${SOURCE_PATH}/dev/restinio/CMakeLists.txt "fmt::fmt-header-only" "fmt::fmt")

if("boost" IN_LIST FEATURES)
    set(ASIO_OPT -DRESTINIO_USE_BOOST_ASIO=static)
elseif("asio" IN_LIST FEATURES)
    set(ASIO_OPT -DRESTINIO_USE_BOOST_ASIO=none)
else()
    message(FATAL_ERROR "boost or asio must be active as a feature")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/dev
    PREFER_NINJA
    OPTIONS
        -DRESTINIO_INSTALL=ON
        -DRESTINIO_TEST=OFF
        -DRESTINIO_SAMPLE=OFF
        -DRESTINIO_BENCH=OFF
        -DRESTINIO_FIND_DEPS=ON
        ${ASIO_OPT}
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/restinio")

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib ${CURRENT_PACKAGES_DIR}/debug)

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/restinio/copyright)

