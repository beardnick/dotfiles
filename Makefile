.PHONY: build push pub

APP := "dev-env"
DATE := $(shell date -u '+%Y-%m-%d')
COMMIT := $(shell git rev-parse --short HEAD)
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
DOCKERHUB := $(qianz)
TAG := $(DATE)-$(BRANCH)-$(COMMIT)

build:
	docker build -t $(APP):$(TAG) .

push:
	docker tag  $(DOCKERHUB)/$(APP):$(TAG)
	docker push  $(DOCKERHUB)/$(APP):$(TAG)

pub:build push

tstl:
	tstl -p vim/my.nvim/tsconfig.json --watch
