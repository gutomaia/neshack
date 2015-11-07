PLATFORM = $(shell uname)


ifeq "" "$(shell which luarocks)"
default:
	@echo "Please install luarocks"
	exit 1
else
default: build
endif

LUA_CHECK=.checkpoint

${LUA_CHECK}: lua_requirements
	cat lua_requirements | xargs -I [] luarocks install [] --local
	@touch $@
	${CHECK}

build: ${LUA_CHECK}

mm:
	fceux mm2.nes --loadlua mm2.lua


run: ${BOWER_INSTALLER_CHECK}
	@${NODE_BIN}/supervisor ./app.js

.PHONY: clean run report ghpages download_deps
