##
##  hdf5
##

set (EP_HDF5 "hdf5")

set(HDF5_ARGS -DBUILD_TESTING=OFF
  -DHDF5_BUILD_TOOLS=OFF
  -DHDF5_BUILD_EXAMPLES=OFF)

set(HDF5_DEPENDENCIES "")

ExternalProject_Add (
  ${EP_HDF5}
  PREFIX ${EP_HDF5}
  BINARY_DIR ${EP_HDF5}/build
  SOURCE_DIR ${EP_HDF5}/source
  URL "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0-patch1/src/hdf5-1.10.0-patch1.zip"
  BUILD_ALWAYS OFF
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ${HDF5_ARGS}
)


