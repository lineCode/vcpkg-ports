# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/endian
    REF boost-1.67.0
    SHA512 198cb5eb9b9f9a4ca6bd069c79f9222e748248d7f7f8231ab9b288334f3f77c37b398abc5d097463a4ce69b4f0de209f247d5f15b1ccdd0fcbf036009ddd73ad
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})