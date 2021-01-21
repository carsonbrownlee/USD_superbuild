##
## Ptex
##

set(Ptex_ARGS "")

set(Ptex_DEPENDENCIES "")

build_component(
  NAME Ptex
  VERSION "v2.1.28"
  URL https://github.com/wdas/ptex
  BUILD_ARGS ${Ptex_ARGS}
  DEPENDS_ON ${Ptex_DEPENDENCIES}
)