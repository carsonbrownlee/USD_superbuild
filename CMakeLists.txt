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

###############################################################################
###############################################################################
###############################################################################

## order defined below is crucial for setting up the cmake environment correctly
include(get_tbb)

ExternalProject_Add(boost
  PREFIX ${CMAKE_CURRENT_BINARY_DIR}/source/boost
  URL https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.gz
  #GIT_REPOSITORY https://github.com/boostorg/boost.git
  #GIT_TAG "boost-1.61.0"
  CONFIGURE_COMMAND ./bootstrap.sh --prefix=${CMAKE_CURRENT_BINARY_DIR}/install/
  # --with-python
  BUILD_COMMAND ./b2 install --prefix=${CMAKE_CURRENT_BINARY_DIR}/install --build-dir=${CMAKE_CURRENT_BINARY_DIR}/build -j${BUILD_JOBS} address-model=64 link=shared runtime-link=shared threading=multi variant=release --with-atomic --with-program_options --with-regex --with-date_time --with-system --with-thread --with-filesystem install
  #BUILD_COMMAND ./b2 -a install --prefix=${CMAKE_CURRENT_BINARY_DIR}/install --build-dir=${CMAKE_CURRENT_BINARY_DIR}/build -j64 address-model=64 link=shared runtime-link=shared threading=multi variant=release --without-python --without-mpi install
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND ""
  #\
  #  cp -r ${CMAKE_CURRENT_BINARY_DIR}/install/source/boost/src/boost/libs/assign/include/boost/assign ${CMAKE_CURRENT_BINARY_DIR}/install/include/boost/ ;\
  #  cp -r ${CMAKE_CURRENT_BINARY_DIR}/install/source/boost/src/boost/libs/assign/include/boost/assign.hpp ${CMAKE_CURRENT_BINARY_DIR}/install/include/boost/"
  INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install
)

build_component(
  NAME USD
  VERSION "v20.05"
  #VERSION "v20.08"
  URL "https://github.com/PixarAnimationStudios/USD"
  BUILD_ARGS
    -DTBB_ROOT=${TBB_PATH}
    -DBoost_INCLUDE_DIR=${CMAKE_CURRENT_BINARY_DIR}/install/include
    -DBoost_LIBRARY_DIR_RELEASE=${CMAKE_CURRENT_BINARY_DIR}/install/lib/
    -DBoost_PROGRAM_OPTIONS_LIBRARY_RELEASE=${CMAKE_CURRENT_BINARY_DIR}/install/lib/libboost_program_options.so
    -DPXR_ENABLE_PYTHON_SUPPORT=OFF
    -DPXR_BUILD_USD_IMAGING=OFF
  DEPENDS_ON tbb boost
  OMIT_FROM_INSTALL
)
