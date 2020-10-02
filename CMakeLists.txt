## ======================================================================== ##
## Copyright 2009-2019 Intel Corporation                                    ##
##                                                                          ##
## Licensed under the Apache License, Version 2.0 (the "License");          ##
## you may not use this file except in compliance with the License.         ##
## You may obtain a copy of the License at                                  ##
##                                                                          ##
##     http://www.apache.org/licenses/LICENSE-2.0                           ##
##                                                                          ##
## Unless required by applicable law or agreed to in writing, software      ##
## distributed under the License is distributed on an "AS IS" BASIS,        ##
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. ##
## See the License for the specific language governing permissions and      ##
## limitations under the License.                                           ##
## ======================================================================== ##

## Global CMake settings ##

cmake_minimum_required(VERSION 3.5)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

if(NOT CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX
      "${CMAKE_BINARY_DIR}/install"
      CACHE STRING "Final install location." FORCE)
endif()

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

## Establish project ##

project(USD_superbuild)

include(ExternalProject)
include(GNUInstallDirs)
include(ProcessorCount)
include(macros_and_options)

option(USE_PYTHON "enable python support" FALSE)
option(USE_PYTHON2 "if USE_PYTHON enabled, use python2 instead of python3" FALSE)

###############################################################################
###############################################################################
###############################################################################

## order defined below is crucial for setting up the cmake environment correctly
include(get_tbb)

set(BOOST_ARGS ./b2 install --prefix=${CMAKE_CURRENT_BINARY_DIR}/install --build-dir=${CMAKE_CURRENT_BINARY_DIR}/build -j${BUILD_JOBS} address-model=64 link=shared runtime-link=shared threading=multi variant=release --with-atomic --with-program_options --with-regex --with-date_time --with-system --with-thread --with-filesystem)
set(BOOST_URL https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.gz)
if (USE_PYTHON)
  if (USE_PYTHON2)
    find_package(Python2 REQUIRED)
    message("python: " ${Python2_EXECUTABLE})
    message("writing file: " ${CMAKE_CURRENT_BINARY_DIR}/source/boost/src/boost/python-config.jam)
    file(
      WRITE ${CMAKE_CURRENT_BINARY_DIR}/source/boost/src/boost/python-config.jam
      "using python : 2.7 : \"/usr/bin/python2\" : \"/usr/include/python2.7\" ;"
    )
    set(BOOST_URL https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.gz)
  else()
    find_package(Python3 REQUIRED)
    set(BOOST_URL https://downloads.sourceforge.net/project/boost/boost/1.70.0/boost_1_70_0.tar.gz)
  endif()
  set(BOOST_ARGS ${BOOST_ARGS} --with-python --user-config=python-config.jam )
endif()

ExternalProject_Add(boost
  PREFIX ${CMAKE_CURRENT_BINARY_DIR}/source/boost
  URL ${BOOST_URL}
  CONFIGURE_COMMAND ./bootstrap.sh --prefix=${CMAKE_CURRENT_BINARY_DIR}/install/
  BUILD_COMMAND ${BOOST_ARGS}
  #BUILD_COMMAND ./b2 install --prefix=${CMAKE_CURRENT_BINARY_DIR}/install --build-dir=${CMAKE_CURRENT_BINARY_DIR}/build -j${BUILD_JOBS} address-model=64 link=shared runtime-link=shared threading=multi variant=release --with-atomic --with-program_options --with-regex --with-date_time --with-system --with-thread --with-filesystem install
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND ""
  INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install
)

build_component(
  NAME USD
  VERSION "v20.05"
  URL "https://github.com/PixarAnimationStudios/USD"
  UILD_ARGS
    -DTBB_ROOT=${TBB_PATH}
    -DBoost_INCLUDE_DIR=${CMAKE_CURRENT_BINARY_DIR}/install/include
    -DBoost_LIBRARY_DIR_RELEASE=${CMAKE_CURRENT_BINARY_DIR}/install/lib/
    -DBoost_PROGRAM_OPTIONS_LIBRARY_RELEASE=${CMAKE_CURRENT_BINARY_DIR}/install/lib/libboost_program_options.so
    -DPXR_ENABLE_PYTHON_SUPPORT=OFF
    -DPXR_BUILD_USD_IMAGING=OFF
  DEPENDS_ON tbb boost
  OMIT_FROM_INSTALL
)
