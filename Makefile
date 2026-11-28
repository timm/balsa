# For people who cloned this repo; `luarocks install balsa` needs
# none of it. demo.lua and test.lua also run without make:
#     lua demo.lua ; lua test.lua
# The learner is generated next door in balsa-dev (see Hack in
# README.md); nothing here is touched by its `make package`.
SHELL := bash
.SILENT:

LUA ?= $(shell command -v luajit || command -v lua)

help: ## show this help
	grep -E '^[a-z.]+:.*##' Makefile | sed 's/:.*## /\t/'

msg ?= saving

push: ## git add everything, commit (msg="..."), push
	git add . && { git commit -m "$(msg)" || true; } && git push

demo: ## grow a forest on data/diabetes.csv, print its auc
	$(LUA) demo.lua

test: ## does this install work? (4 checks, non-zero exit if not)
	[ -n "$(LUA)" ] || { echo "no lua: brew install luajit"; exit 1; }
	$(LUA) test.lua

install: ## install this working copy as a local rock, then test
	luarocks make balsa-0.1-1.rockspec
	cd /tmp && $(LUA) -e 'require"balsa"' && echo "rock installed"
