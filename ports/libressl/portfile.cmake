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
    SHA512 1cd82a1bff4f655251b5feb0c850f4164e0fd548e4b404407370f74dcc75c205f42efc7787a157eecac84cbbe46af48cb63f46b3fef75f4a0a9ea19a5863a691
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
