# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/units
    REF boost-1.67.0
    SHA512 33ce1386e67982d4b6f45fa78ce787332c7a753463650762a66da1064741fc6f9909fe1929416ec7918060300cedda93642fd6adb4a2d5f4c689f4d48b2a720f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})