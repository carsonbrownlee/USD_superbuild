##
## libtiff
##

set (EP_JPEG "jpeg")

set(JPEG_ARGS ""
)

set(JPEG_URL "https://www.ijg.org/files/jpegsrc.v9b.tar.gz")
if (WIN32)
   set(JPEG_URL "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/1.5.1.zip")
endif()


set(JPEG_DEPENDENCIES ""
#  boost #only needed if python libs are build
)

ExternalProject_Add (
	${EP_JPEG}
	PREFIX ${EP_JPEG}
	BINARY_DIR ${EP_JPEG}/build
	SOURCE_DIR ${EP_JPEG}/source
  URL "https://download.osgeo.org/libtiff/tiff-4.0.7.zip"
  BUILD_ALWAYS OFF
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  #INSTALL_COMMAND ""
)


