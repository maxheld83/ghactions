.PHONY: test-that
test-that:
	Rscript -e \
	"library(testthat); \
	 library(checkmate); \
	 testthat::test_dir(path = '.', stop_on_failure = TRUE)"
