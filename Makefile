IMAGE ?= kaigara/piwik
TAG   ?= $(shell git describe --tags --abbrev=0 2>/dev/null || echo "1.0.0")

.PHONY: build

build:
	@echo "Building $(IMAGE):$(TAG)"
	@docker build -t "$(IMAGE):$(TAG)" .
start: build
	@docker run -d --env="MYSQL_ROOT_PASSWORD=111111" --name="piwik-db" mysql
	@docker run -d -p 80:80 --link piwik-db:db kaigara/piwik:latest
