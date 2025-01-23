.PHONY: build test clean docker-build docker-run

BINARY_NAME=tipsy
DOCKER_IMAGE=tipsy
DOCKER_TAG=latest

build:
	go build -o bin/$(BINARY_NAME) ./cmd/tipsy

test:
	go test ./...

clean:
	rm -f bin/$(BINARY_NAME)

docker-build:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker-run:
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG)