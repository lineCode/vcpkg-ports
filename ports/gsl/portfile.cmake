#header-only library
include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Microsoft/GSL
    REF v1.0.0
    SHA512 cde55df9540fd08ca8d29a74b2cff360686aa75b01ee1c48bd9782a2d70d1b6eae712a51eaf9b60453f859e466df00345b0a2893137d16490cea8ee54362f7da
    HEAD_REF master
)

file(INSTALL ${SOURCE_PATH}/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
