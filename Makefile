PLATFORM = $(shell uname)

SUPERMARIOBROS_ROM=Super\ Mario\ Bros.nes
MEGAMAN2_ROM=Mega\ Man\ 2.nes

ifeq "" "$(shell which luarocks)"
default:
	@echo "Please install luarocks"
	exit 1
else
default: supermariobros
endif

LUA_CHECK=.checkpoint

${LUA_CHECK}: lua_requirements
	cat lua_requirements | xargs -I [] luarocks install [] --local
	@touch $@
	${CHECK}

build: ${LUA_CHECK}

supermariobros: build ${SUPERMARIOBROS_ROM}
	fceux ${SUPERMARIOBROS_ROM} --loadlua smb.lua

megaman2: build ${MEGAMAN2_ROM}
	fceux ${MEGAMAN2_ROM} --loadlua mm2.lua

.PHONY: clean run report ghpages download_deps
