all: network minibank

network:
	docker network create minibanknet 
minibank: bin/minibank

bin/minibank: $(shell find $(SRCDIR) -name '*.go')
	docker run -it -v `pwd`:/usr/app \
        -w /usr/app \
        -e GOPATH=/usr/app \
        -e CGO_ENABLED=0 \
        -e GOOS=linux \
        golang:1.9 sh -c 'go get minibank && go build -ldflags "-extldflags -static" -o $@ minibank'

clean:
	docker network rm minibanknet
