VERSION ?= v0.2.2
OPERATOR_IMAGE ?= virtualenvironment/virtual-env-operator
ADMISSION_IMAGE ?= virtualenvironment/virtual-env-admission-webhook

.DEFAULT_GOAL := help
.PHONY: help
help:
	@echo 'use "make build-operator" or "make build-admission" to build images'

.PHONY: build-operator
build-operator:
	operator-sdk build --go-build-args "-o build/_output/operator/virtual-env-operator" $(OPERATOR_IMAGE):$(VERSION)

.PHONY: build-admission
build-admission: $(shell find cmd/webhook -name '*.go')
	CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o "build/_output/admission/webhook-server" ./cmd/webhook
	docker build -t $(ADMISSION_IMAGE):$(VERSION) -f build/Dockerfile_webhook build/_output/admission/
