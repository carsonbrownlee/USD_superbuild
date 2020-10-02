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

set(COMPONENT_NAME tbb)
set(TBB_VERSION 2019_U8)
set(TBB_ROOT_DIR tbb2019_20190605oss)

set(COMPONENT_PATH ${CMAKE_BINARY_DIR}/${COMPONENT_NAME})

if (APPLE)
  set(TBB_URL https://github.com/intel/tbb/releases/download/${TBB_VERSION}/${TBB_ROOT_DIR}_mac.tgz)
elseif(WIN32)
  set(TBB_URL https://github.com/intel/tbb/releases/download/${TBB_VERSION}/${TBB_ROOT_DIR}_win.zip)
else()
  set(TBB_URL https://github.com/intel/tbb/releases/download/${TBB_VERSION}/${TBB_ROOT_DIR}_lin.tgz)
endif()

ExternalProject_Add(tbb
  PREFIX ${COMPONENT_NAME}
  STAMP_DIR ${COMPONENT_NAME}/stamp
  SOURCE_DIR ${COMPONENT_NAME}/src
  BINARY_DIR ${COMPONENT_NAME}
  URL ${TBB_URL}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
  BUILD_ALWAYS OFF
)

set(TBB_PATH "${COMPONENT_PATH}/src/${TBB_ROOT_DIR}")
