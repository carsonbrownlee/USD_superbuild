##
## OCIO
##

set(OCIO_ARGS ""
    "-DCMAKE_CXX_FLAGS:STRING=-fPIC -w"
    -DOCIO_BUILD_TRUELIGHT=OFF
    -DOCIO_BUILD_APPS=OFF
    -DOCIO_BUILD_NUKE=OFF
    -DOCIO_BUILD_DOCS=OFF
    -DOCIO_BUILD_TESTS=OFF
    -DOCIO_BUILD_PYGLUE=OFF
    -DOCIO_BUILD_JNIGLUE=OFF
    -DOCIO_STATIC_JNIGLUE=OFF
    -DOCIO_BUILD_STATIC=OFF
    -DOCIO_BUILD_SHARED=ON
    -DYAML_CPP_OBJECT_LIB_EMBEDDED=ON
    -DTINYXML_OBJECT_LIB_EMBEDDED=OFF
)

set(OCIO_DEPENDENCIES "")


if(BUILD_OPENEXR)
    set(OCIO_ARGS
        ${OCIO_ARGS}
        #-DILMBASE_PATH=${CMAKE_INSTALL_PREFIX}
    )
    set(OCIO_DEPENDENCIES
        ${OCIO_DEPENDENCIES}
        OpenEXR
    )
endif()

if(BUILD_OPENIMAGEIO)
    set(OCIO_ARGS
        ${OCIO_ARGS}
        #-DOIIO_PATH=${CMAKE_INSTALL_PREFIX}
    )
    set(OCIO_DEPENDENCIES
        ${OCIO_DEPENDENCIES}
        OIIO
    )
endif()

build_component(
 NAME OCIO
 VERSION "v1.1.1"
 URL "https://github.com/AcademySoftwareFoundation/OpenColorIO"
 BUILD_ARGS ${OCIO_ARGS}
 DEPENDS_ON ${OCIO_DEPENDENCIES}
)