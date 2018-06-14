# vcpkg portfile.cmake for GDAL
#
# NOTE: update the version and checksum for new GDAL release
set(GDAL_VERSION_STR "2.3.0")
set(GDAL_VERSION_PKG "230")
set(GDAL_VERSION_LIB "203")
set(GDAL_PACKAGE_SUM "f3f790b7ecb28916d6d0628b15ddc6b396a25a8f1f374589ea5e95b5a50addc99e05e363113f907b6c96faa69870b5dc9fdf3d771f9c8937b4aa8819bd78b190")

if (TRIPLET_SYSTEM_ARCH MATCHES "arm")
    message(FATAL_ERROR "ARM is currently not supported.")
endif()

include(vcpkg_common_functions)

vcpkg_download_distfile(ARCHIVE
    URLS "http://download.osgeo.org/gdal/${GDAL_VERSION_STR}/gdal${GDAL_VERSION_PKG}.zip"
    FILENAME "gdal${GDAL_VERSION_PKG}.zip"
    SHA512 ${GDAL_PACKAGE_SUM}
    )

# Extract source into architecture specific directory, because GDALs' build currently does not
# support out of source builds.
set(SOURCE_PATH_DEBUG   ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-debug/gdal-${GDAL_VERSION_STR})
set(SOURCE_PATH_RELEASE ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-release/gdal-${GDAL_VERSION_STR})
set(PREFIX_PATH ${CURRENT_INSTALLED_DIR})

foreach(BUILD_TYPE debug release)
    file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-${BUILD_TYPE})
    vcpkg_extract_source_archive(${ARCHIVE} ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-${BUILD_TYPE})
    vcpkg_apply_patches(
        SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-${BUILD_TYPE}/gdal-${GDAL_VERSION_STR}
        PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/0001-Fix-debug-crt-flags.patch
        ${CMAKE_CURRENT_LIST_DIR}/no-my-bool.patch
    )
endforeach()

find_program(NMAKE nmake REQUIRED)

if (UNIX)
    #--with-gif=${PREFIX_PATH}

    get_cmake_property(_variableNames VARIABLES)
    list (SORT _variableNames)
    vcpkg_configure_autoconf(
        IN_SOURCE
        SOURCE_PATH_DEBUG ${SOURCE_PATH_DEBUG}
        SOURCE_PATH_RELEASE ${SOURCE_PATH_RELEASE}
        OPTIONS
            --without-ld-shared
            --disable-shared
            --with-sysroot=${PREFIX_PATH}
            --with-threads
            --with-cpp14
            --without-libtool
            --with-static-proj4=${PREFIX_PATH}
            --with-libz=${PREFIX_PATH}
            --with-libtiff=${PREFIX_PATH}
            --with-expat=${PREFIX_PATH}
            --with-png=${PREFIX_PATH}
            --with-geotiff=internal
            --with-liblzma=yes
            --with-libjson-c=internal
            --with-geos=${PREFIX_PATH}/bin/geos-config
            --without-pg
            --without-grass
            --without-libgrass
            --without-cfitsio
            --without-pcraster
            --without-netcdf
            --without-jpeg
            --without-ogdi
            --without-fme
            --without-freexl
            --without-hdf4
            --without-hdf5
            --without-jasper
            --without-ecw
            --without-kakadu
            --without-mrsid
            --without-jp2mrsid
            --without-bsb
            --without-grib
            --without-mysql
            --without-ingres
            --without-xerces
            --without-xml2
            --without-mrf
            --without-odbc
            --without-curl
            --without-sqlite3
            --without-idb
            --without-sde
            --without-perl
            --without-pcre
            --without-php
            --without-python
            --without-webp
        )

    if(APPLE)
        vcpkg_build_autotools(IN_SOURCE DISABLE_PARALLEL)
    else()
        vcpkg_build_autotools(IN_SOURCE DISABLE_PARALLEL)
    endif()
    vcpkg_install_autotools(IN_SOURCE)

    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

    if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
        file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
    endif()
else ()
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}" NATIVE_PACKAGES_DIR)
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}/share/gdal" NATIVE_DATA_DIR)
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}/share/gdal/html" NATIVE_HTML_DIR)

# Setup proj4 libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" PROJ_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/proj_5_0.lib" PROJ_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/proj_5_0d.lib" PROJ_LIBRARY_DBG)

# Setup libpng libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" PNG_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libpng16.lib" PNG_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libpng16d.lib" PNG_LIBRARY_DBG)

# Setup geos libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" GEOS_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libgeos_c.lib" GEOS_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libgeos_cd.lib" GEOS_LIBRARY_DBG)

# Setup expat libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" EXPAT_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/expat.lib" EXPAT_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/expat.lib" EXPAT_LIBRARY_DBG)

# Setup curl libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" CURL_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libcurl.lib" CURL_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libcurl.lib" CURL_LIBRARY_DBG)

# Setup sqlite3 libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" SQLITE_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/sqlite3.lib" SQLITE_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/sqlite3.lib" SQLITE_LIBRARY_DBG)

# Setup MySQL libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include/mysql" MYSQL_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libmysql.lib" MYSQL_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libmysql.lib" MYSQL_LIBRARY_DBG)

# Setup PostgreSQL libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" PGSQL_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libpq.lib" PGSQL_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libpqd.lib" PGSQL_LIBRARY_DBG)

# Setup OpenJPEG libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" OPENJPEG_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/openjp2.lib" OPENJPEG_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/openjp2.lib" OPENJPEG_LIBRARY_DBG)

# Setup WebP libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" WEBP_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/webp.lib" WEBP_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/webpd.lib" WEBP_LIBRARY_DBG)

# Setup libxml2 libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" XML2_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libxml2.lib" XML2_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libxml2.lib" XML2_LIBRARY_DBG)

# Setup liblzma libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" LZMA_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/lzma.lib" LZMA_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/lzma.lib" LZMA_LIBRARY_DBG)

set(NMAKE_OPTIONS
    GDAL_HOME=${NATIVE_PACKAGES_DIR}
    DATADIR=${NATIVE_DATA_DIR}
    HTMLDIR=${NATIVE_HTML_DIR}
    PROJ_INCLUDE=-I${PROJ_INCLUDE_DIR}
    EXPAT_DIR=${EXPAT_INCLUDE_DIR}
    EXPAT_INCLUDE=-I${EXPAT_INCLUDE_DIR}
    #CURL_INC=-I${CURL_INCLUDE_DIR}
    #MYSQL_INC_DIR=${MYSQL_INCLUDE_DIR}
    #PG_INC_DIR=${PGSQL_INCLUDE_DIR}
    #WEBP_ENABLED=YES
    #WEBP_CFLAGS=-I${WEBP_INCLUDE_DIR}
    #LIBXML2_INC=-I${XML2_INCLUDE_DIR}
    PNG_EXTERNAL_LIB=1
    PNGDIR=${PNG_INCLUDE_DIR}
    MSVC_VER=1900
)

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    list(APPEND NMAKE_OPTIONS WIN64=YES)
endif()

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    list(APPEND NMAKE_OPTIONS PROJ_FLAGS=-DPROJ_STATIC)
else()
    # Enables PDBs for release and debug builds
    list(APPEND NMAKE_OPTIONS WITH_PDB=1)
endif()

if (VCPKG_CRT_LINKAGE STREQUAL static)
    set(LINKAGE_FLAGS "/MT")
else()
    set(LINKAGE_FLAGS "/MD")
endif()

set(NMAKE_OPTIONS_REL
    "${NMAKE_OPTIONS}"
    CXX_CRT_FLAGS=${LINKAGE_FLAGS}
    PROJ_LIBRARY=${PROJ_LIBRARY_REL}
    PNG_LIB=${PNG_LIBRARY_REL}
    EXPAT_LIB=${EXPAT_LIBRARY_REL}
    #"CURL_LIB=${CURL_LIBRARY_REL} wsock32.lib wldap32.lib winmm.lib"
    #MYSQL_LIB=${MYSQL_LIBRARY_REL}
    #PG_LIB=${PGSQL_LIBRARY_REL}
    #WEBP_LIBS=${WEBP_LIBRARY_REL}
    #LIBXML2_LIB=${XML2_LIBRARY_REL}
)

set(NMAKE_OPTIONS_DBG
    "${NMAKE_OPTIONS}"
    CXX_CRT_FLAGS="${LINKAGE_FLAGS}d"
    PROJ_LIBRARY=${PROJ_LIBRARY_DBG}
    PNG_LIB=${PNG_LIBRARY_DBG}
    EXPAT_LIB=${EXPAT_LIBRARY_DBG}
    #"CURL_LIB=${CURL_LIBRARY_DBG} wsock32.lib wldap32.lib winmm.lib"
    #MYSQL_LIB=${MYSQL_LIBRARY_DBG}
    #PG_LIB=${PGSQL_LIBRARY_DBG}
    #WEBP_LIBS=${WEBP_LIBRARY_DBG}
    #LIBXML2_LIB=${XML2_LIBRARY_DBG}
    DEBUG=1
)

if("geos" IN_LIST FEATURES)
    list(APPEND NMAKE_OPTIONS
        GEOS_DIR=${GEOS_INCLUDE_DIR}
        "GEOS_CFLAGS=-I${GEOS_INCLUDE_DIR} -DHAVE_GEOS"
    )

    list(APPEND NMAKE_OPTIONS_DBG GEOS_LIB=${GEOS_LIBRARY_DBG})
    list(APPEND NMAKE_OPTIONS_REL GEOS_LIB=${GEOS_LIBRARY_REL})
endif()

if("jpeg" IN_LIST FEATURES)
    list(APPEND NMAKE_OPTIONS
        OPENJPEG_ENABLED=YES
        OPENJPEG_CFLAGS=-I${OPENJPEG_INCLUDE_DIR}
        OPENJPEG_VERSION=20100
    )

    list(APPEND NMAKE_OPTIONS_DBG OPENJPEG_LIB=${OPENJPEG_LIBRARY_DBG})
    list(APPEND NMAKE_OPTIONS_REL OPENJPEG_LIB=${OPENJPEG_LIBRARY_REL})
endif()

if("sqlite" IN_LIST FEATURES)
    list(APPEND NMAKE_OPTIONS SQLITE_INC=-I${SQLITE_INCLUDE_DIR})
    list(APPEND NMAKE_OPTIONS_DBG SQLITE_LIB=${SQLITE_LIBRARY_DBG})
    list(APPEND NMAKE_OPTIONS_REL SQLITE_LIB=${SQLITE_LIBRARY_REL})
endif()

################
# Release build
################
message(STATUS "Building ${TARGET_TRIPLET}-rel")
vcpkg_execute_required_process(
    COMMAND ${NMAKE} -f makefile.vc
    "${NMAKE_OPTIONS_REL}"
    WORKING_DIRECTORY ${SOURCE_PATH_RELEASE}
    LOGNAME nmake-build-${TARGET_TRIPLET}-release
)
message(STATUS "Building ${TARGET_TRIPLET}-rel done")

################
# Debug build
################
message(STATUS "Building ${TARGET_TRIPLET}-dbg")
vcpkg_execute_required_process(
  COMMAND ${NMAKE} /G -f makefile.vc
  "${NMAKE_OPTIONS_DBG}"
  WORKING_DIRECTORY ${SOURCE_PATH_DEBUG}
  LOGNAME nmake-build-${TARGET_TRIPLET}-debug
)
message(STATUS "Building ${TARGET_TRIPLET}-dbg done")

message(STATUS "Packaging ${TARGET_TRIPLET}")
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/gdal/html)

vcpkg_execute_required_process(
  COMMAND ${NMAKE} -f makefile.vc
  "${NMAKE_OPTIONS_REL}"
  "install"
  "devinstall"
  WORKING_DIRECTORY ${SOURCE_PATH_RELEASE}
  LOGNAME nmake-install-${TARGET_TRIPLET}
)

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
  file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/gdal_i.lib)
  file(COPY ${SOURCE_PATH_DEBUG}/gdal.lib   DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
  file(COPY ${SOURCE_PATH_RELEASE}/gdal.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
  file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/gdal.lib ${CURRENT_PACKAGES_DIR}/debug/lib/gdald.lib)
else()
  file(GLOB EXE_FILES ${CURRENT_PACKAGES_DIR}/bin/*.exe)
  file(REMOVE ${EXE_FILES} ${CURRENT_PACKAGES_DIR}/lib/gdal.lib)
  file(COPY ${SOURCE_PATH_DEBUG}/gdal${GDAL_VERSION_LIB}.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
  file(COPY ${SOURCE_PATH_DEBUG}/gdal_i.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
  file(RENAME ${CURRENT_PACKAGES_DIR}/lib/gdal_i.lib ${CURRENT_PACKAGES_DIR}/lib/gdal.lib)
  file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/gdal_i.lib ${CURRENT_PACKAGES_DIR}/debug/lib/gdald.lib)
endif()

endif (UNIX)

# Copy over PDBs
vcpkg_copy_pdbs()

# Handle copyright
file(RENAME ${CURRENT_PACKAGES_DIR}/share/gdal/LICENSE.TXT ${CURRENT_PACKAGES_DIR}/share/gdal/copyright)

message(STATUS "Packaging ${TARGET_TRIPLET} done")