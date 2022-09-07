## Copyright 2022 Intel Corporation
## SPDX-License-Identifier: Apache-2.0

#
# TBB
#

set(COMPONENT_NAME tbb)
#set(TBB_VERSION 2017_U6)
#set(TBB_ROOT_DIR tbb2017_20170412oss)
#set(TBB_VERSION 2019_U8)
#set(TBB_ROOT_DIR tbb2019_20190605oss)
set(TBB_LIB_SUBDIR "intel64/gcc4.7")
set(TBB_VERSION "2018_U6" CACHE STRING "usd version")
set(TBB_ROOT_DIR "tbb2018_20180822oss" CACHE STRING "tbb version expanded.  ie tbb2018_20180822oss")
##hardcode url for houdini version as the 0605 breaks naming convention
#set(TBB_URL https://github.com/oneapi-src/oneTBB/releases/download/2019_U8/tbb2019_20190605oss)
if (APPLE)
  set(TBB_VERSION 2018_U1)
endif()

set(COMPONENT_PATH ${CMAKE_BINARY_DIR}/${COMPONENT_NAME})

if (APPLE)
  set(TBB_URL https://github.com/intel/tbb/releases/download/${TBB_VERSION}/${TBB_ROOT_DIR}_mac.tgz)
elseif(WIN32)
  set(TBB_URL https://github.com/intel/tbb/releases/download/${TBB_VERSION}/${TBB_ROOT_DIR}_win.zip)
else()
  set(TBB_URL https://github.com/intel/tbb/releases/download/${TBB_VERSION}/${TBB_ROOT_DIR}_lin.tgz)
endif()


set(INSTALL_COMMAND
    COMMAND "${CMAKE_COMMAND}" -E copy_directory ${COMPONENT_PATH}/src/${TBB_ROOT_DIR}/include ${CMAKE_INSTALL_PREFIX}/include
    COMMAND "${CMAKE_COMMAND}" -E copy_directory ${COMPONENT_PATH}/src/${TBB_ROOT_DIR}/bin ${CMAKE_INSTALL_PREFIX}/bin
    COMMAND "${CMAKE_COMMAND}" -E copy_directory ${COMPONENT_PATH}/src/${TBB_ROOT_DIR}/lib/${TBB_LIB_SUBDIR} ${CMAKE_INSTALL_PREFIX}/lib
)

ExternalProject_Add(tbb
  PREFIX ${COMPONENT_NAME}
  STAMP_DIR ${COMPONENT_NAME}/stamp
  SOURCE_DIR ${COMPONENT_NAME}/src
  BINARY_DIR ${COMPONENT_NAME}
  URL ${TBB_URL}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ${INSTALL_COMMAND}
  BUILD_ALWAYS OFF
)

#
# OSPRay version of TBB script.  Seems designed for 2019+ versions of tbb with cmake
#
#set(COMPONENT_NAME tbb)
#set(TBB_VERSION 2018_U6)
##hardcode url for houdini version as the 0605 breaks naming convention
#set(TBB_URL https://github.com/oneapi-src/oneTBB/releases/download/2019_U8/tbb2019_20190605oss)
#if (APPLE)
#  set(TBB_VERSION 2018_U1)
#  set(TBB_URL https://github.com/oneapi-src/oneTBB/releases/download/2018_U6/tbb2018_20180822oss)
#set(COMPONENT_PATH ${INSTALL_DIR_ABSOLUTE})
#if (INSTALL_IN_SEPARATE_DIRECTORIES)
#  set(COMPONENT_PATH ${INSTALL_DIR_ABSOLUTE}/${COMPONENT_NAME})
#endif()
#
#if (TBB_HASH)
#  set(TBB_URL_HASH URL_HASH SHA256=${TBB_HASH})
#endif()
#
#if (BUILD_TBB_FROM_SOURCE)
#  string(REGEX REPLACE "(^[0-9]+\.[0-9]+\.[0-9]+$)" "v\\1" TBB_ARCHIVE ${TBB_VERSION})
#  ExternalProject_Add(${COMPONENT_NAME}
#    PREFIX ${COMPONENT_NAME}
#    DOWNLOAD_DIR ${COMPONENT_NAME}
#    STAMP_DIR ${COMPONENT_NAME}/stamp
#    SOURCE_DIR ${COMPONENT_NAME}/src
#    BINARY_DIR ${COMPONENT_NAME}/build
#    LIST_SEPARATOR | # Use the alternate list separator
#    URL "https://github.com/oneapi-src/oneTBB/archive/refs/tags/${TBB_ARCHIVE}.zip"
#    ${TBB_URL_HASH}
#    CMAKE_ARGS
#      -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
#      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
#      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
#      -DCMAKE_INSTALL_PREFIX:PATH=${COMPONENT_PATH}
#      -DCMAKE_INSTALL_INCLUDEDIR=${CMAKE_INSTALL_INCLUDEDIR}
#      -DCMAKE_INSTALL_LIBDIR=${CMAKE_INSTALL_LIBDIR}
#      -DCMAKE_INSTALL_DOCDIR=${CMAKE_INSTALL_DOCDIR}
#      -DCMAKE_INSTALL_BINDIR=${CMAKE_INSTALL_BINDIR}
#      -DCMAKE_BUILD_TYPE=${DEPENDENCIES_BUILD_TYPE}
#      -DTBB_TEST=OFF
#      -DTBB_STRICT=OFF
#      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
#      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}
#    BUILD_COMMAND ${DEFAULT_BUILD_COMMAND}
#    BUILD_ALWAYS ${ALWAYS_REBUILD}
#  )
#else()
#  if (TBB_VERSION VERSION_LESS 2021)
#    set(TBB_FOLDER "tbb")
#  else()
#    set(TBB_PREFIX "oneapi-")
#  endif()
#
#  if (APPLE)
#    set(TBB_OSSUFFIX "mac.tgz")
#  elseif (WIN32)
#    set(TBB_OSSUFFIX "win.zip")
#  else()
#    set(TBB_OSSUFFIX "lin.tgz")
#  endif()
#
#  if (TBB_URL)
#    set(TBB_URL ${TBB_URL}_${TBB_OSSUFFIX})
#    set(TBB_FOLDER tbb2019_20190605oss)
#    if (APPLE)
#	set(TBB_FOLDER tbb2018_20180822oss)
#    endif()
#  else()
#    set(TBB_URL "https://github.com/oneapi-src/oneTBB/releases/download/v${TBB_VERSION}/${TBB_PREFIX}tbb-${TBB_VERSION}-${TBB_OSSUFFIX}")
#  endif()
#
#  ExternalProject_Add(${COMPONENT_NAME}
#    PREFIX ${COMPONENT_NAME}
#    DOWNLOAD_DIR ${COMPONENT_NAME}
#    STAMP_DIR ${COMPONENT_NAME}/stamp
#    SOURCE_DIR ${COMPONENT_NAME}/src
#    BINARY_DIR ${COMPONENT_NAME}
#    URL ${TBB_URL}
#    ${TBB_URL_HASH}
#    CONFIGURE_COMMAND ""
#    BUILD_COMMAND ""
#    INSTALL_COMMAND "${CMAKE_COMMAND}" -E copy_directory
#      <SOURCE_DIR>/${TBB_FOLDER}
#      ${COMPONENT_PATH}
#    BUILD_ALWAYS OFF
#  )
#endif()
#
#set(TBB_PATH "${COMPONENT_PATH}")
#list(APPEND CMAKE_PREFIX_PATH ${COMPONENT_PATH})
#string(REPLACE ";" "|" CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}")
