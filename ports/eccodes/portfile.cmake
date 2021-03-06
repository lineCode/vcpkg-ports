include(vcpkg_common_functions)

set(VERSION_MAJOR 2)
set(VERSION_MINOR 7)
set(VERSION_REVISION 3)
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_REVISION})
set(PACKAGE_NAME ${PORT}-${VERSION}-Source)
set(PACKAGE ${PACKAGE_NAME}.tar.gz)

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${PACKAGE_NAME})
vcpkg_download_distfile(ARCHIVE
    URLS "https://software.ecmwf.int/wiki/download/attachments/45757960/${PACKAGE}"
    FILENAME "${PACKAGE}"
    SHA512 a6ac6dae5a785a14e2b69ecc698e72f4173c96655c8944f6e6f1c530e72a078036c2fd76d77473e17b33be606ec36f8236a0efa22afc8b4d7760d88a053902f4
)

vcpkg_extract_source_archive(${ARCHIVE})

if("png" IN_LIST FEATURES)
    set(PNG_OPT ON)
else()
    set(PNG_OPT OFF)
endif()

if("jpeg" IN_LIST FEATURES)
    set(JPEG_OPT ON)
else()
    set(JPEG_OPT OFF)
endif()

if("netcdf" IN_LIST FEATURES)
    set(NETCDF_OPT ON)
else()
    set(NETCDF_OPT OFF)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DENABLE_EXAMPLES=OFF
        -DENABLE_NETCDF=${NETCDF_OPT}
        -DENABLE_PYTHON=OFF
        -DENABLE_FORTRAN=OFF
        -DENABLE_MEMFS=OFF
        -DENABLE_TESTS=OFF
        -DENABLE_PNG=${PNG_OPT}
        -DENABLE_JPG=${JPEG_OPT}
        -DENABLE_INSTALL_ECCODES_SAMPLES=OFF
        -DBUILD_SHARED_LIBS=OFF
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_cmake_targets(CONFIG_PATH "share/${PORT}/cmake")

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)

if("tool" IN_LIST FEATURES)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/tools)
else ()
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
endif()

vcpkg_fixup_pkgconfig_file()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
