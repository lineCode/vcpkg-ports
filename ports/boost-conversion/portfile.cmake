# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/conversion
    REF boost-1.67.0
    SHA512 6a8bdcec46a08b6b29a9288c24e6dd868c694ebd33ae8062c8ee9784be91d12031cda27841ea9f6212cdb8f0e9b9b21d68ccb96c3d38011cad5c93bfc62a568d
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})