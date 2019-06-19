IMAGE_NAME=$(shell basename $(CURDIR))
# place *inside* the action container where to conduct tests
GITHUB_WORKSPACE=/github/workspace
# TODO would be nice to reuse this here
R_LIBS_ACTION=/usr/lib/R/dev-helpers-library

.PHONY: test-that
test-that:
	echo $(CURDIR)
	ls -a $(CURDIR)
	docker run \
	--env="R_LIBS=$(R_LIBS_ACTION)" \
	--entrypoint /usr/bin/Rscript \
	--mount type=bind,source=$(CURDIR),destination=$(GITHUB_WORKSPACE) \
	--workdir $(GITHUB_WORKSPACE) \
	--tty \
	$(IMAGE_NAME) \
	-e "library(testthat); \
      library(checkmate); \
      source('/ghactions-source/tests/testthat/helpers.R'); \
      getwd(); \
      fs::dir_ls(path = getwd()); \
      testthat::test_dir(path = '.', stop_on_failure = TRUE)"
