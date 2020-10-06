## ======================================================================== ##
## Copyright 2009-2020 Intel Corporation                                    ##
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

set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install )

##
## Boost
##

set(BOOST_ARGS ./b2 install --prefix=${INSTALL_DIR} --build-dir=${CMAKE_CURRENT_BINARY_DIR}/build -j${BUILD_JOBS} address-model=64 link=shared runtime-link=shared threading=multi variant=release --with-atomic --with-program_options --with-regex --with-date_time --with-system --with-thread --with-filesystem)
set(BOOST_URL https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.gz)
if (USE_PYTHON)
  if (USE_PYTHON2)
    find_package(Python2 REQUIRED)
    message("python: " ${Python2_EXECUTABLE})
    message("writing file: " ${CMAKE_CURRENT_BINARY_DIR}/source/boost/src/boost/python-config.jam)
    file(
      WRITE ${CMAKE_CURRENT_BINARY_DIR}/source/boost/src/boost/python-config.jam
      "using python : ${Python2_VERSION_MAJOR}.${Python2_VERSION_MINOR} : \"${Python2_EXECUTABLE}\" ;"
    )
    set(BOOST_URL https://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.gz)
  else()
    find_package(Python3 REQUIRED)
    message("python: " ${Python3_EXECUTABLE})
    file(
      WRITE ${CMAKE_CURRENT_BINARY_DIR}/source/boost/src/boost/python-config.jam
      "using python : ${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR} : \"${Python3_EXECUTABLE}\" ;"
    )
    set(BOOST_URL https://downloads.sourceforge.net/project/boost/boost/1.70.0/boost_1_70_0.tar.gz)
  endif()
  set(BOOST_ARGS ${BOOST_ARGS} --with-python --user-config=python-config.jam )
endif()

ExternalProject_Add(boost
  PREFIX ${CMAKE_CURRENT_BINARY_DIR}/source/boost
  URL ${BOOST_URL}
  CONFIGURE_COMMAND ./bootstrap.sh --prefix=${INSTALL_DIR}
  BUILD_COMMAND ${BOOST_ARGS}
  BUILD_IN_SOURCE 1
  INSTALL_COMMAND ""
  INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install
)

##
## OpenEXR
##

build_component(
  NAME OpenEXR
  VERSION "v2.4.0"
  URL "https://github.com/AcademySoftwareFoundation/openexr"
  BUILD_ARGS ""
)

##
## OIIO
##

build_component(
 NAME OIIO
 VERSION "Release-1.8.17"
 URL "https://github.com/OpenImageIO/oiio"
 BUILD_ARGS
  -DBoost_INCLUDE_DIR=${INSTALL_DIR}/include " "
  -DBoost_LIBRARY_DIR_RELEASE=${INSTALL_DIR}/lib/ " "
  -DOIIO_BUILD_TOOLS=OFF
  -DOIIO_BUILD_TESTS=OFF
  -DUSE_PYTHON=OFF
  -DSTOP_ON_WARNING=OFF
  -DOPENEXR_HOME=${INSTALL_DIR}
  -DUSE_PTEX=OFF
  -DBoost_NO_BOOST_CMAKE=On
  -DBoost_NO_SYSTEM_PATHS=True
 DEPENDS_ON OpenEXR
)

##
## OpenSubdiv
##

build_component(
  NAME OpenSubdiv
  VERSION "v3_4_3"
  URL https://github.com/PixarAnimationStudios/OpenSubdiv
  BUILD_ARGS ""
  DEPENDS_ON
)

##
## GLEW
##

#build_component(
  #NAME GLEW
  #VERSION "glew-2.0.0"
  #URL https://github.com/nigels-com/glew
  #BUILD_ARGS ""
  #DEPENDS_ON
#)

##
## Ptex
##

build_component(
  NAME Ptex
  VERSION "v2.1.28"
  URL https://github.com/wdas/ptex
  BUILD_ARGS ""
  DEPENDS_ON
)

##
## USD
##

set(USD_ARGS
    -DTBB_ROOT=${TBB_PATH} " "
    -DBoost_INCLUDE_DIR=${INSTALL_DIR}/include " "
    -DBoost_LIBRARY_DIR_RELEASE=${INSTALL_DIR}/lib/ " "
    -DBoost_PROGRAM_OPTIONS_LIBRARY_RELEASE=${INSTALL_DIR}/lib/libboost_program_options.so " "
    -DPXR_BUILD_USD_IMAGING=OFF " "
    -DOPENSUBDIV_INCLUDE_DIR=${INSTALL_DIR}/include
    -DOPENSUBDIV_OSDCPU_LIBRARY=${INSTALL_DIR}/lib/libosdCPU.so
    -DOPENSUBDIV_OSDGPU_LIBRARY=${INSTALL_DIR}/lib/libosdGPU.so
    -DOIIO_BASE_DIR=${INSTALL_DIR}
)

if (USE_PYTHON)
    set(USD_ARGS ${USD_ARGS} -DPXR_ENABLE_PYTHON_SUPPORT=ON " ")
    if (USE_PYTHON2)
      set(USD_ARGS ${USD_ARGS} -DPXR_PYTHON_SHEBANG=${Python2_EXECUTABLE} " ")
      set(USD_ARGS ${USD_ARGS} -DPYTHON_EXECUTABLE=${Python2_EXECUTABLE} " ")
      set(USD_ARGS ${USD_ARGS} -DPXR_USE_PYTHON_3=OFF " ")
    else()
      set(USD_ARGS ${USD_ARGS} -DPXR_PYTHON_SHEBANG=${Python3_EXECUTABLE} " ")
      set(USD_ARGS ${USD_ARGS} -DPXR_USE_PYTHON_3=ON " ")
    endif()
else()
    set(USD_ARGS ${USD_ARGS} -DPXR_ENABLE_PYTHON_SUPPORT=OFF " ")
endif()

build_component(
  NAME USD
  VERSION "v20.05"
  URL "https://github.com/PixarAnimationStudios/USD"
  BUILD_ARGS ${USD_ARGS}
  DEPENDS_ON tbb boost OpenEXR OIIO Ptex OpenSubdiv
)

