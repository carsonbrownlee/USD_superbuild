##
## GLEW
##

if (BUILD_GLEW)
  build_component(
    NAME GLEW
    VERSION "glew-2.0.0"
    URL https://github.com/nigels-com/glew
    BUILD_ARGS ""
    DEPENDS_ON
  )
endif()