#
# TBB
#

# build_component(
#  NAME tbb
#  VERSION "v2021.1.1"
#  URL https://github.com/oneapi-src/oneTBB
#  BUILD_ARGS
#     "-DCMAKE_CXX_FLAGS:STRING=-Wno-deprecated-copy"
# )

#https://github.com/oneapi-src/oneTBB/releases/download/2017_U6/tbb2017_20170412oss_lin.tgz

set(COMPONENT_NAME tbb)
set(TBB_VERSION 2017_U6)
set(TBB_ROOT_DIR tbb2017_20170412oss)

#set(TBB_VERSION 2019_U8)
#set(TBB_ROOT_DIR tbb2019_20190605oss)

set(COMPONENT_PATH ${CMAKE_BINARY_DIR}/${COMPONENT_NAME})

if (APPLE)
  set(TBB_URL https://github.com/intel/tbb/releases/download/${TBB_VERSION}/${TBB_ROOT_DIR}_mac.tgz)
elseif(WIN32)
  set(TBB_URL https://github.com/intel/tbb/releases/download/${TBB_VERSION}/${TBB_ROOT_DIR}_win.zip)
else()
  set(TBB_URL https://github.com/intel/tbb/releases/download/${TBB_VERSION}/${TBB_ROOT_DIR}_lin.tgz)
endif()


set(INSTALL_COMMAND
    COMMAND cp -r ${COMPONENT_PATH}/src/include ${CMAKE_INSTALL_PREFIX}
    COMMAND cp -r ${COMPONENT_PATH}/src/bin ${CMAKE_INSTALL_PREFIX}
    COMMAND cp -r ${COMPONENT_PATH}/src/lib ${CMAKE_INSTALL_PREFIX}
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

#set(TBB_PATH "${COMPONENT_PATH}/src/${TBB_ROOT_DIR}")



# ProcessorCount(PROCESSOR_COUNT)

# if(NOT PROCESSOR_COUNT EQUAL 0)
#   set(BUILD_JOBS ${PROCESSOR_COUNT} CACHE STRING "Number of build jobs '-j <n>'")
# else()
#   set(BUILD_JOBS 4 CACHE STRING "Number of build jobs '-j <n>'")
# endif()

# if(${CMAKE_VERSION} VERSION_GREATER 3.11.4)
#   set(PARALLEL_JOBS_OPTS -j ${BUILD_JOBS})
# endif()

# set (EP_TBB "tbb")

# set(BUILD_COMMAND make ${PARALLEL_JOBS_OPTS})

# #set(INSTALL_COMMAND
# #	COMMAND make install
# #)

# set(COMPONENT_FULL_NAME ${EP_TBB})
# set(COMPONENT_DOWNLOAD_PATH ${COMPONENT_FULL_NAME})
# set(COMPONENT_SOURCE_PATH ${COMPONENT_FULL_NAME}/source)
# set(COMPONENT_STAMP_PATH ${COMPONENT_FULL_NAME}/stamp)
# set(COMPONENT_BUILD_PATH ${COMPONENT_FULL_NAME}/build)


# #set(CONFIGURE_COMMAND
# #	COMMAND ${CMAKE_BINARY_DIR}/${COMPONENT_SOURCE_PATH}/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-pic --enable-static --disable-shared
# #)

# ExternalProject_Add (
# 	${EP_TBB}
	
# 	PREFIX         ${EP_TBB}
# 	#DOWNLOAD_DIR ${COMPONENT_DOWNLOAD_PATH}
# 	STAMP_DIR ${COMPONENT_STAMP_PATH}
# 	#SOURCE_DIR ${COMPONENT_SOURCE_PATH}
#     #BINARY_DIR ${COMPONENT_BUILD_PATH}
#     BUILD_IN_SOURCE 1
# 	#GIT_REPOSITORY https://github.com/lz4/lz4
# 	#GIT_TAG        v1.9.3
# 	#GIT_SHALLOW    ON
	
# 	URL https://github.com/oneapi-src/oneTBB/archive/2020_U3.zip
	
# 	BUILD_ALWAYS   OFF
# 	#INSTALL_DIR    ${INSTALL_DIR}
	
# 	LIST_SEPARATOR | # Use the alternate list separator

# 	CONFIGURE_COMMAND ""
# 	BUILD_COMMAND ${BUILD_COMMAND}
# 	#INSTALL_COMMAND ${INSTALL_COMMAND}
# 	BUILD_ALWAYS OFF
# )

# include(cmake/tbb/TBBGet.cmake)
# include(cmake/tbb/TBBBuild.cmake)
# tbb_get(TBB_ROOT tbb_root SOURCE_CODE)
# tbb_build(TBB_ROOT ${tbb_root} CONFIG_DIR TBB_DIR)