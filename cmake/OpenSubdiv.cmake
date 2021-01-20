##
## OpenSubdiv
##

build_component(
  NAME OpenSubdiv
  VERSION "v3_4_3"
  URL https://github.com/PixarAnimationStudios/OpenSubdiv
  BUILD_ARGS
    -DNO_DOC=ON
    -DTBB_LOCATION=${CMAKE_INSTALL_PREFIX}
#    -DPTEX_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include
#    -DPTEX_LIBRARY=${CMAKE_INSTALL_PREFIX}/lib/libPtex.so
  DEPENDS_ON Ptex
)