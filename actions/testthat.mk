IMAGE_NAME=$(shell basename $(CURDIR))
# TODO would be nice to reuse this here
R_LIBS_ACTION=/usr/lib/R/dev-helpers-library
# place where the source is stored; awkward hack necessary below
SOURCE_PATH=/ghactions-source/actions
# always the wd inside the target container
TEST_PATH=$(SOURCE_PATH)/$(IMAGE_NAME)

# are we inside docker right now?
ifneq ("$(wildcard /.dockerenv)","")
	IN_DOCKER=true
else
	IN_DOCKER=false
endif

# weirdly cannot bind mound source:GITHUB_WORKSPACE to anywhere
# but for local use, we can mount for easier make use
ifeq ("$(IN_DOCKER)","false")
	MOUNT_ARG=--mount type=bind,source=$(CURDIR),destination=$(TEST_PATH)
endif

.PHONY: test-that
test-that:
	docker run \
	--env="R_LIBS=$(R_LIBS_ACTION)" \
	--entrypoint /usr/bin/Rscript \
	$(MOUNT_ARG) \
	--workdir $(TEST_PATH) \
	--tty \
	$(IMAGE_NAME) \
	-e "library(testthat); \
      library(checkmate); \
      source('/ghactions-source/tests/testthat/helpers.R'); \
      testthat::test_dir(path = '.', stop_on_failure = TRUE)"
