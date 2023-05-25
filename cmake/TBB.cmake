## Copyright 2022 Intel Corporation
## SPDX-License-Identifier: Apache-2.0

#
# TBB
#
set(COMPONENT_NAME tbb)
option(TBB_FROM_SOURCE OFF)
set(TBB_URL "https://github.com/oneapi-src/oneTBB/archive/refs/tags/v2020.3.tar.gz" CACHE STRING "tbb source url")
if (Win32)
  set(TBB_URL "https://github.com/oneapi-src/oneTBB/releases/download/2017_U6/tbb2017_20170412oss_win.zip" CACHE STRING "tbb source url")
endif()
set(COMPONENT_PATH ${CMAKE_BINARY_DIR}/${COMPONENT_NAME})

if (APPLE)
  set(TBB_OS Darwin)
elseif(WIN32)
  set(TBB_OS Windows)
else()
  set(TBB_OS Linux)
endif()

if (Win32)
  # windows uses binaries only
  set(INSTALL_COMMAND
    COMMAND "${CMAKE_COMMAND}" -E copy_directory ${COMPONENT_PATH}\\bin\\intel64\\vc14 ${CMAKE_INSTALL_PREFIX}\\bin
    COMMAND "${CMAKE_COMMAND}" -E copy_directory ${COMPONENT_PATH}\\lib\\intel64\\vc14 ${CMAKE_INSTALL_PREFIX}\\lib
    COMMAND "${CMAKE_COMMAND}" -E copy_directory ${COMPONENT_PATH}\\include\\serial ${CMAKE_INSTALL_PREFIX}\\include\\serial
    COMMAND "${CMAKE_COMMAND}" -E copy_directory ${COMPONENT_PATH}\\include\\tbb ${CMAKE_INSTALL_PREFIX}\\include\\tbb
    COMMAND "${CMAKE_COMMAND}" -DTBB_ROOT=${CMAKE_INSTALL_PREFIX} -DTBB_OS=${TBB_OS} -DSAVE_TO=${CMAKE_INSTALL_PREFIX}/lib/cmake/tbb -P ../cmake/tbb_config_generator.cmake
    COMMAND sh ${COMPONENT_PATH}/tbb_install.sh
  )
  ExternalProject_Add(tbb
    PREFIX ${COMPONENT_NAME}
    #STAMP_DIR ${COMPONENT_NAME}/stamp
    SOURCE_DIR ${COMPONENT_NAME}/source
    BINARY_DIR ${COMPONENT_NAME}/build
    URL ${TBB_URL}
    BUILD_COMMAND ""
    INSTALL_COMMAND ${INSTALL_COMMAND}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_ALWAYS OFF
  )
else(Win32)
  # disjointed findTBB.cmake files look in different directories for libs
  # TODO: embree4 cmake appears to set TBB_DIR to TBB_ROOT/lib/cmake,
  # breaking tbbs generated cmake config file
  file(WRITE ${COMPONENT_PATH}/tbb_install.sh
    "mkdir -p ${CMAKE_INSTALL_PREFIX}/lib/intel64/gcc4.8;"
    "mkdir -p ${CMAKE_INSTALL_PREFIX}/lib/cmake/lib/intel64/;"
    "cp ${COMPONENT_PATH}/src/build/\*_debug/\*.so\* ${CMAKE_INSTALL_PREFIX}/lib/;"
    "cp ${COMPONENT_PATH}/src/build/\*_release/\*.so\* ${CMAKE_INSTALL_PREFIX}/lib/;"
    "ln -sf ${CMAKE_INSTALL_PREFIX}/lib ${CMAKE_INSTALL_PREFIX}/lib/intel64/gcc4.8;"
    "ln -sf ${CMAKE_INSTALL_PREFIX}/lib ${CMAKE_INSTALL_PREFIX}/lib/cmake/lib/intel64/gcc4.8;"
    "ln -sf ${CMAKE_INSTALL_PREFIX}/include ${CMAKE_INSTALL_PREFIX}/lib/cmake/include;"
    )
  file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/include/tbb)

  set(INSTALL_COMMAND
    COMMAND "${CMAKE_COMMAND}" -E copy_directory ${COMPONENT_PATH}/src/include/tbb ${CMAKE_INSTALL_PREFIX}/include/tbb
    COMMAND "${CMAKE_COMMAND}" -DTBB_ROOT=${CMAKE_INSTALL_PREFIX} -DTBB_OS=${TBB_OS} -DSAVE_TO=${CMAKE_INSTALL_PREFIX}/lib/cmake/tbb -P ../cmake/tbb_config_generator.cmake
    COMMAND sh ${COMPONENT_PATH}/tbb_install.sh
  )
  include(ProcessorCount)
  ProcessorCount(nprocs)

  ExternalProject_Add(tbb
    PREFIX ${COMPONENT_NAME}
    STAMP_DIR ${COMPONENT_NAME}/stamp
    SOURCE_DIR ${COMPONENT_NAME}/src
    BINARY_DIR ${COMPONENT_NAME}/src/src
    URL ${TBB_URL}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND make -j${nprocs} tbb tbbmalloc
    INSTALL_COMMAND ${INSTALL_COMMAND}
    BUILD_ALWAYS OFF
  )
endif(TBB_FROM_SOURCE)

