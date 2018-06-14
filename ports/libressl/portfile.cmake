include(vcpkg_common_functions)
set(MAJOR 2)
set(MINOR 7)
set(REVISION 4)
set(VERSION ${MAJOR}.${MINOR}.${REVISION})
set(PACKAGE ${PORT}-${VERSION}.tar.gz)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${PORT}-${VERSION})
vcpkg_download_distfile(ARCHIVE_FILE
    URLS "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${PACKAGE}"
    FILENAME "${PACKAGE}"
    SHA512 5fafff32bc4effa98c00278206f0aeca92652c6a8101b2c5da3904a5a3deead2d1e3ce979c644b8dc6060ec216eb878a5069324a0396c0b1d7b6f8169d509e9b
)
vcpkg_extract_source_archive(${ARCHIVE_FILE})

# if (MINGW AND CMAKE_CROSSCOMPILING)
#     # the assembly fails to compile on mingw linux
#     set(EXTRA_OPTS -DENABLE_ASM=OFF)
# endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DLIBRESSL_TESTS=OFF
        -DLIBRESSL_APPS=OFF
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_copy_pdbs()

file(COPY ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
