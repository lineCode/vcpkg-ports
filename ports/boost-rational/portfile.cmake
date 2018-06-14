# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/rational
    REF boost-1.67.0
    SHA512 27fece61a7de96bf783a5f5d5b290934f76741848466fbe256c5517fb5671105d68e3126fd4b135c73a0290cbd81cff9849b599d14cdd948897d1ecc573ab016
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})