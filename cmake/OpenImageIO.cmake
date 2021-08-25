##
## OIIO
##

set(OIIO_ARGS
-DOIIO_BUILD_TOOLS=OFF
-DOIIO_BUILD_TESTS=OFF
-DUSE_QT=OFF
-DUSE_OPENGL=OFF
-DUSE_PYTHON=OFF
-DSTOP_ON_WARNING=OFF
#-DOPENEXR_ROOT_DIR=${CMAKE_INSTALL_PREFIX}  # for OIIO > 1.8
-DCMAKE_DISABLE_FIND_PACKAGE_PkgConfig=On
-DUSE_PTEX=OFF
)

set(OIIO_DEPENDENCIES "")

if (BUILD_BOOST)
    set(OIIO_DEPENDENCIES ${OIIO_DEPENDENCIES}
        boost
    )
    set(OIIO_ARGS ${OIIO_ARGS}
        -DBOOST_ROOT=${CMAKE_INSTALL_PREFIX} 
        -DBoost_NO_SYSTEM_PATHS=ON 
        -DBoost_NO_BOOST_CMAKE=ON 
    )
endif()

if (BUILD_OPENEXR)
    set(OIIO_DEPENDENCIES ${OIIO_DEPENDENCIES}
        OpenEXR
    )
    set(OIIO_ARGS ${OIIO_ARGS}
        -DOPENEXR_HOME=${CMAKE_INSTALL_PREFIX}
    )
endif()

build_component(
 NAME OIIO
 VERSION "Release-1.8.17"
 URL "https://github.com/OpenImageIO/oiio"
 BUILD_ARGS ${OIIO_ARGS}

 DEPENDS_ON OpenEXR ${OIIO_DEPENDENCIES}
)
