##
## OpenEXR
##

set(OpenEXR_ARGS ""
  -DPYILMBASE_ENABLE=OFF
  -DOPENEXR_VIEWERS_ENABLE=OFF
  #-DBOOST_ROOT=${CMAKE_INSTALL_PREFIX}  #only needed if python libs are build
)

set(OpenEXR_DEPENDENCIES ""
#  boost #only needed if python libs are build
)

build_component(
  NAME OpenEXR
  VERSION "v2.4.0"
  URL "https://github.com/AcademySoftwareFoundation/openexr"
  BUILD_ARGS ${OpenEXR_ARGS}
  DEPENDS_ON ${OpenEXR_DEPENDENCIES}
)
