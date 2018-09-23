all: minibank

minibank: bin/minibank

bin/minibank: $(shell find $(SRCDIR) -name '*.go')
	docker run -it -v 'pwd':/usr/src/minibank \
        -w /usr/src/minibank \
        -e GOPATH=/usr/bin/go \
        -e CGO_ENABLED=0 \
        -e GOOS=linux \
        golang:1.9 sh -c 'go get -v /usr/src/minibank && go build -ldflags "-extldflags -static" -o $@ minibank'
