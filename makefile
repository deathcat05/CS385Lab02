all: network minibank mariadb run-targets

SRCDIR=src/minibank/

network:
	docker network create minibanknet

minibank: bin/minibank
	docker build -t minibank .

mariadb: 
	docker build -t mariadb ./mariadb/


run-targets: minibank mariadb
	docker run  -d --name mariadb -e MYSQL_ROOT_PASSWORD=blackdiamond -v `pwd`/mariadb:/docker-entrypoint-initdb.d:ro --net minibanknet --link minibank mariadb
	docker run  -d  --name minibank -p 80:8080  --net minibanknet minibank 
	

bin/minibank: $(shell find $(SRCDIR) -name '*.go')
	docker run -it -v `pwd`:/usr/app \
        -w /usr/app \
        -e GOPATH=/usr/app \
        -e CGO_ENABLED=0 \
        -e GOOS=linux \
        golang:1.9 sh -c 'go get minibank && go build -ldflags "-extldflags -static" -o $@ minibank'

clean:
	@echo "Cleaning"
	sudo rm -rf bin pkg ./src/github.com ./src/golang.org
	docker stop mariadb
	docker rm mariadb
	docker rm minibank
	docker network rm minibanknet
	
