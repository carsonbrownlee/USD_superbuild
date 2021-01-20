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
  message(STATUS "CMAKE_INSTALL_PREFIX is not set using ${CMAKE_BINARY_DIR}/install")
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

option(USE_PYTHON "enable python support" TRUE)
option(USE_PYTHON2 "if USE_PYTHON enabled, use python2 instead of python3" FALSE)
option(BUILD_GLEW "build glew" FALSE)
option(BUILD_TBB "build TBB" FALSE)

###############################################################################
###############################################################################
###############################################################################

## order defined below is crucial for setting up the cmake environment correctly
#include(get_tbb)
if (BUILD_TBB)
  include(TBB)
endif()
#Boost should have a TBB dependency (check that)
include(Boost)
include(Glew)
include(OpenEXR)
include(OpenImageIO)
include(OpenColorIO)

include(Ptex)
include(OpenSubdiv)



##
## USD
##

set(USD_DEPENDENCIES 
  boost OpenEXR OIIO OCIO Ptex OpenSubdiv
)

set(USD_ARGS
    -DTBB_ROOT=${CMAKE_INSTALL_PREFIX}
    -DBOOST_ROOT=${CMAKE_INSTALL_PREFIX}
    -DBoost_NO_SYSTEM_PATHS=ON
    -DBoost_NO_BOOST_CMAKE=ON
    -DPXR_BUILD_USD_IMAGING=ON
    -DPXR_BUILD_OPENIMAGEIO_PLUGIN=ON
    -DOIIO_LOCATION=${CMAKE_INSTALL_PREFIX}
    -DOPENEXR_LOCATION=${CMAKE_INSTALL_PREFIX}
    -DPXR_BUILD_OPENCOLORIO_PLUGIN=ON
    -DOCIO_LOCATION=${CMAKE_INSTALL_PREFIX}
    #-DPXR_ENABLE_OPENVDB_SUPPORT=ON
    -DPXR_ENABLE_PYTHON_SUPPORT= ON
    -DPXR_BUILD_USDVIEW=ON
)

if (BUILD_TBB)
  set(USD_ARGS
    ${USD_ARGS}
    -DTBB_ROOT=${CMAKE_INSTALL_PREFIX}
  )
  set(USD_DEPENDENCIES
    ${USD_DEPENDENCIES}
    tbb
  )
endif()



if (USE_PYTHON)
    set(USD_ARGS ${USD_ARGS} -DPXR_ENABLE_PYTHON_SUPPORT=ON " ")
    if (USE_PYTHON2)
      #set(USD_ARGS ${USD_ARGS} -DPXR_PYTHON_SHEBANG=${Python2_EXECUTABLE} " ")
      #set(USD_ARGS ${USD_ARGS} -DPYTHON_EXECUTABLE=${Python2_EXECUTABLE} " ")
      set(USD_ARGS ${USD_ARGS} -DPXR_USE_PYTHON_3=OFF " ")
      #set(PYTHON_EXECUTABLE ${Python2_EXECUTABLE})
    else()
      #set(USD_ARGS ${USD_ARGS} -DPXR_PYTHON_SHEBANG=${Python3_EXECUTABLE} " ")
      set(USD_ARGS ${USD_ARGS} -DPXR_USE_PYTHON_3=ON " ")
      #set(PYTHON_EXECUTABLE ${Python3_EXECUTABLE})
    endif()

    #set(PYSIDE_BIN_DIRECTORY /usr/bin/)
    #find_package(PySide REQUIRED)
    #set(USD_ARGS ${USD_ARGS} -DPYSIDEUICBINARY=/usr/bin/python2-pyside-uic " ")
else()
    set(USD_ARGS ${USD_ARGS} -DPXR_ENABLE_PYTHON_SUPPORT=OFF " ")
endif()

build_component(
  NAME USD
  VERSION "v20.05"
  URL "https://github.com/PixarAnimationStudios/USD"
  BUILD_ARGS ${USD_ARGS}
  DEPENDS_ON ${USD_DEPENDENCIES}
  INSTALL_BINARIES
)
