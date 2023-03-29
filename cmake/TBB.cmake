## Copyright 2022 Intel Corporation
## SPDX-License-Identifier: Apache-2.0

#
# TBB
#
set(COMPONENT_NAME tbb)
set(TBB_URL "https://github.com/oneapi-src/oneTBB/archive/refs/tags/2019_U6.tar.gz")
set(COMPONENT_PATH ${CMAKE_BINARY_DIR}/${COMPONENT_NAME})

if (APPLE)
  set(TBB_OS Darwin)
elseif(WIN32)
  set(TBB_OS Windows)
else()
  set(TBB_OS Linux)
endif()

file(WRITE ${COMPONENT_PATH}/tbb_install.sh
  "cp ${COMPONENT_PATH}/src/build/\*_release/\*.so\* ${CMAKE_INSTALL_PREFIX}/lib/;"
  )
file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/include/tbb)

set(INSTALL_COMMAND
  COMMAND "${CMAKE_COMMAND}" -E copy_directory ${COMPONENT_PATH}/src/include/tbb ${CMAKE_INSTALL_PREFIX}/include/tbb
  COMMAND "${CMAKE_COMMAND}" -DTBB_ROOT=${CMAKE_INSTALL_PREFIX} -DTBB_OS=${TBB_OS} -DSAVE_TO=${CMAKE_INSTALL_PREFIX}/lib/cmake/tbb -P cmake/tbb_config_generator.cmake
  COMMAND sh ${COMPONENT_PATH}/tbb_install.sh
)

ExternalProject_Add(tbb
  PREFIX ${COMPONENT_NAME}
  STAMP_DIR ${COMPONENT_NAME}/stamp
  SOURCE_DIR ${COMPONENT_NAME}/src
  BINARY_DIR ${COMPONENT_NAME}/src
  URL ${TBB_URL}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND make -j8
  INSTALL_COMMAND ${INSTALL_COMMAND}
  BUILD_ALWAYS OFF
)
