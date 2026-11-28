# For people who cloned this repo. demo.py and test.py also run
# without make:  pypy3 demo.py ; pypy3 test.py
# The learner is generated next door in balsa-dev (see Hack in
# README.md); nothing here is touched by its `make package`.
SHELL := bash
.SILENT:

PY ?= $(shell command -v pypy3 || command -v python3)

help: ## show this help
	grep -E '^[a-z.]+:.*##' Makefile | sed 's/:.*## /\t/'

msg ?= saving

push: ## git add everything, commit (msg="..."), push
	git add . && { git commit -m "$(msg)" || true; } && git push

demo: ## grow a forest on data/diabetes.csv, print its auc
	$(PY) demo.py

test: ## does this install work? (4 checks, non-zero exit if not)
	[ -n "$(PY)" ] || { echo "no python: brew install pypy3"; exit 1; }
	$(PY) test.py

install: ## pip install this working copy (editable), then test
	$(PY) -m pip install -e . && cd /tmp && $(PY) -c 'import balsa' \
	  && echo "balsa installed"
