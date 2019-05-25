export ROOT_DIR=$(CURDIR)
export DOCKER_REPO=maxheld83

## MODULES=$(dir $(wildcard */Makefile))
## automatically running all modules would be nicer, but would disregard dependencies of "FROM"s
MODULES=base install-deps

.PHONY: clean
clean: ## Call the 'clean' target on all sub-modules
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: lint
lint: ## Call the 'lint' target on all sub-modules
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: build
build: ## Call the 'build' target on all sub-modules
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: test
test: ## Call the 'test' target on all sub-modules
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: publish
publish: ## Call the 'publish' target on all sub-modules
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: dev-all
dev-all: lint build test

include help.mk
