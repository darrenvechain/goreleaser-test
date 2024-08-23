PACKAGE = github.com/darrenvechain/goreleaser-test

GIT_COMMIT = $(shell git --no-pager log --pretty="%h" -n 1)
GIT_TAG = $(shell git tag -l --points-at HEAD | head -n 1)

MAJOR = $(shell go version | cut -d' ' -f3 | cut -b 3- | cut -d. -f1)
MINOR = $(shell go version | cut -d' ' -f3 | cut -b 3- | cut -d. -f2)

.DEFAULT_GOAL := goreaser-test

goreaser-test:| go_version_check #@ Build the `goreaser-test` executable
	@echo "building $@..."
	@go build -v -o $(CURDIR)/bin/$@ -ldflags "-X main.gitCommit=$(GIT_COMMIT) -X main.gitTag=$(GIT_TAG)" .
	@echo "done. executable created at 'bin/$@'"

go_version_check:
	@if test $(MAJOR) -lt 1; then \
		echo "Go 1.22 or higher required"; \
		exit 1; \
	else \
		if test $(MAJOR) -eq 1 -a $(MINOR) -lt 19; then \
			echo "Go 1.22 or higher required"; \
			exit 1; \
		fi \
	fi
