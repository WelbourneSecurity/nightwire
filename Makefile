SHELL := /usr/bin/env bash

.PHONY: lint test check

lint:
	shellcheck install.sh lib/*.sh bin/nightwire debuggers/install-debuggers.sh
	shfmt -i 2 -ci -d install.sh lib/*.sh bin/nightwire debuggers/install-debuggers.sh tests/*.bats

test:
	bats tests

check: lint test
