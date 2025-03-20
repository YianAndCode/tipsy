.PHONY: all api test clean fmt tidy

BIN_DIR = ./bin
API_SRC = ./cmd/api/
API_TGT = api

# Go build flags
GO_BUILD_FLAGS = -trimpath

# Go test flags
GO_TEST_FLAGS = -v -race

all: tidy fmt test api wire

api:
	go build $(GO_BUILD_FLAGS) -o ${BIN_DIR}/${API_TGT} ${API_SRC}

test:
	go test $(GO_TEST_FLAGS) ./...

fmt:
	go fmt ./...

tidy:
	go mod tidy

wire:
	cd cmd/api && wire

clean:
	rm -f ${BIN_DIR}/${API_TGT}