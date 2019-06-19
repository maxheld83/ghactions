include ../docker.mk
include ../help.mk
include ../shell.mk
include ../testthat.mk

.PHONY: clean
clean: ## Clean up after the build process.

.PHONY: lint
lint: docker-lint

.PHONY: build
build: docker-build ## Build this Action.

.PHONY: test
test: test-that  ## run testthat

.PHONY: publish
publish: docker-publish ## Publish this Action.
