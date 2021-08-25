##
## OpenSubdiv
##

set(OPENSUBDIV_ARGS
    -DNO_DOC=ON
    -DNO_OMP=ON
    -DNO_EXAMPLES=ON
    -DNO_CUDA=ON
    -DTBB_LOCATION=${CMAKE_INSTALL_PREFIX}
)

set(OPENSUBDIV_DEPENDENCIES Ptex)

if(BUILD_TBB)
    set(OPENSUBDIV_ARGS
        ${OPENSUBDIV_ARGS}
        -DTBB_LOCATION=${CMAKE_INSTALL_PREFIX}
    )
    set(OPENSUBDIV_DEPENDENCIES
        ${PENSUBDIV_DEPENDENCIES}
        tbb
    )
endif()

build_component(
  NAME OpenSubdiv
  VERSION "v3_4_3"
  URL https://github.com/PixarAnimationStudios/OpenSubdiv
  BUILD_ARGS ${OPENSUBDIV_ARGS}
  DEPENDS_ON ${OPENSUBDIV_DEPENDENCIES}
)
