.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/getflagman/go-flagman/cmd/swarm
	go build -o bin/gfl      github.com/getflagman/go-flagman/cmd/gfl
	go build -o bin/bootnode github.com/getflagman/go-flagman/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/getflagman/go-flagman/swarm/...
