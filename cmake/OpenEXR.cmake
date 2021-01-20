##
## OpenEXR
##

build_component(
  NAME OpenEXR
  VERSION "v2.4.0"
  URL "https://github.com/AcademySoftwareFoundation/openexr"
  BUILD_ARGS
    -DPYILMBASE_ENABLE=OFF
    -DBOOST_ROOT=${CMAKE_INSTALL_PREFIX}  #only needed if python libs are build
  DEPENDS_ON ${EP_BOOST}
)