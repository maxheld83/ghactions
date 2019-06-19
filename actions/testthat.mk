IMAGE_NAME=$(shell basename $(CURDIR))

.PHONY: test-that
test-that:
	# TODO would be nice to use env here
	docker run \
	--env="R_LIBS=/usr/lib/R/dev-helpers-library" \
	--entrypoint /usr/bin/Rscript \
	$(IMAGE_NAME) \
	-e "library(testthat); \
	    library(checkmate); \
	    testthat::test_dir(path = '.', stop_on_failure = TRUE)"
