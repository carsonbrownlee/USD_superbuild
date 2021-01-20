#option(USE_PYTHON "enable python support" FALSE)
#option(USE_PYTHON2 "if USE_PYTHON enabled, use python2 instead of python3" FALSE)

set (EP_BOOST "boost")


set(BOOST_BUILD_COMMAND ./b2 install --layout=tagged --prefix=${INSTALL_DIR} --build-dir=${CMAKE_CURRENT_BINARY_DIR}/build -j${BUILD_JOBS} address-model=64 link=shared runtime-link=shared threading=multi variant=release --with-atomic --with-program_options --with-regex --with-date_time --with-system --with-thread --with-filesystem --with-serialization --with-wave --with-chrono)

set(BOOST_PYTHON_VERSIONS)

if (USE_PYTHON)
  message("writing file: " ${CMAKE_CURRENT_BINARY_DIR}/source/boost/python-config.jam)
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/source/boost/python-config.jam)
  if (USE_PYTHON2)
    find_package(Python2 REQUIRED)
    message("python: " ${Python2_EXECUTABLE})
    file(
      APPEND ${CMAKE_CURRENT_BINARY_DIR}/source/boost/python-config.jam
      "using python : ${Python2_VERSION_MAJOR}.${Python2_VERSION_MINOR} : \"${Python2_EXECUTABLE}\" ; \n"
    )
    list(APPEND BOOST_PYTHON_VERSIONS "${Python2_VERSION_MAJOR}.${Python2_VERSION_MINOR}")
  else ()
  find_package(Python3 REQUIRED)
    message("python: " ${Python3_EXECUTABLE})
    file(
      APPEND ${CMAKE_CURRENT_BINARY_DIR}/source/boost/python-config.jam
      "using python : ${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR} : \"${Python3_EXECUTABLE}\" ; \n"
    )
    list(APPEND BOOST_PYTHON_VERSIONS "${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}")
  endif()
  list(JOIN BOOST_PYTHON_VERSIONS "," BOOST_PYTHON_VERSIONS)

  set(BOOST_BUILD_COMMAND ${BOOST_BUILD_COMMAND}  --user-config=${CMAKE_CURRENT_BINARY_DIR}/source/boost/python-config.jam python=${BOOST_PYTHON_VERSIONS} --with-python)

endif()

ExternalProject_Add (
	${EP_BOOST}

	PREFIX         ${EP_BOOST}/source/boost
	BUILD_IN_SOURCE 1
	URL https://downloads.sourceforge.net/project/boost/boost/1.67.0/boost_1_67_0.tar.gz
	BUILD_ALWAYS   OFF

	LIST_SEPARATOR | # Use the alternate list separator

	CONFIGURE_COMMAND ./bootstrap.sh --prefix=${INSTALL_DIR}
	BUILD_COMMAND ${BOOST_BUILD_COMMAND}
	INSTALL_COMMAND ""
	INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
)

