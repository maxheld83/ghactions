include ../docker.mk
include ../help.mk
include ../shell.mk

# this cannot use the standard testthat.mk, because install-deps cannot depend on the base container for ghactions, but only on r-ci
# testing is therefore a bit more bare-bones
IMAGE_NAME=$(shell basename $(CURDIR))
# TODO would be nice to reuse this here
R_LIBS_ACTION=/usr/lib/R/dev-helpers-library

# are we inside docker right now?
ifneq ("$(wildcard /.dockerenv)","")
	IN_DOCKER=true
else
	IN_DOCKER=false
endif

TEST_PATH=/test/

# weirdly cannot bind mound source:GITHUB_WORKSPACE to anywhere
# but for local use, we can mount for easier make use
ifeq ("$(IN_DOCKER)","false")
	MOUNT_ARG=--mount type=bind,source=$(CURDIR),destination=$(TEST_PATH)
endif

.PHONY: clean
clean: ## Clean up after the build process.

.PHONY: lint
lint: docker-lint

.PHONY: build
build: docker-build ## Build this Action.

.PHONY: test
test: 
	docker run \
	--env="R_LIBS=$(R_LIBS_ACTION)" \
	--entrypoint /usr/bin/Rscript \
	$(MOUNT_ARG) \
	--workdir $(TEST_PATH) \
	--tty \
	$(IMAGE_NAME) \
	-e "library(testthat); \
      testthat::test_dir(path = '.', stop_on_failure = TRUE)"

.PHONY: publish
publish: docker-publish ## Publish this Action.
