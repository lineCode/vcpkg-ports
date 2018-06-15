include(vcpkg_common_functions)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO HowardHinnant/date
  REF v2.4.1
  SHA512 ce7d1c4518558d3690b3a33cd3da1066b43a5f641282c331c60be73e9b010227d4998bca5f34694215ae52f6514a2f5eccd6b0a5ee3dcf8cef2f2d1644c8beee
  HEAD_REF master
)

set(USE_TZ_DB ON)
if("remote-api" IN_LIST FEATURES)
  set(USE_TZ_DB OFF)
endif()

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS -DUSE_SYSTEM_TZ_DB=${USE_TZ_DB} -DENABLE_DATE_TESTING=OFF
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/date TARGET_PATH share/date)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/date RENAME copyright)
