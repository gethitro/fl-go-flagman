# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gfl android ios gfl-cross swarm evm all test clean
.PHONY: gfl-linux gfl-linux-386 gfl-linux-amd64 gfl-linux-mips64 gfl-linux-mips64le
.PHONY: gfl-linux-arm gfl-linux-arm-5 gfl-linux-arm-6 gfl-linux-arm-7 gfl-linux-arm64
.PHONY: gfl-darwin gfl-darwin-386 gfl-darwin-amd64
.PHONY: gfl-windows gfl-windows-386 gfl-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gfl:
	build/env.sh go run build/ci.go install ./cmd/gfl
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gfl\" to launch gfl."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gfl.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gfl.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

gfl-cross: gfl-linux gfl-darwin gfl-windows gfl-android gfl-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gfl-*

gfl-linux: gfl-linux-386 gfl-linux-amd64 gfl-linux-arm gfl-linux-mips64 gfl-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-*

gfl-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gfl
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep 386

gfl-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gfl
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep amd64

gfl-linux-arm: gfl-linux-arm-5 gfl-linux-arm-6 gfl-linux-arm-7 gfl-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep arm

gfl-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gfl
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep arm-5

gfl-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gfl
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep arm-6

gfl-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gfl
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep arm-7

gfl-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gfl
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep arm64

gfl-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gfl
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep mips

gfl-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gfl
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep mipsle

gfl-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gfl
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep mips64

gfl-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gfl
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gfl-linux-* | grep mips64le

gfl-darwin: gfl-darwin-386 gfl-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gfl-darwin-*

gfl-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gfl
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-darwin-* | grep 386

gfl-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gfl
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-darwin-* | grep amd64

gfl-windows: gfl-windows-386 gfl-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gfl-windows-*

gfl-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gfl
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-windows-* | grep 386

gfl-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gfl
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gfl-windows-* | grep amd64
