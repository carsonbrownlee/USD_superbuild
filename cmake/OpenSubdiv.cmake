##
## OpenSubdiv
##

build_component(
  NAME OpenSubdiv
  VERSION "v3_4_3"
  URL https://github.com/PixarAnimationStudios/OpenSubdiv
  BUILD_ARGS
    -DNO_DOC=ON
#    -DPTEX_INCLUDE_DIR=${INSTALL_DIR}/include
#    -DPTEX_LIBRARY=${INSTALL_DIR}/lib/libPtex.so
  DEPENDS_ON Ptex
)