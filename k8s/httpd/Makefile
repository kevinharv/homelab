CR := docker
VERSION := 1
NAME := kevinharv/httpd
TAG := $(NAME):$(VERSION)

run: build
	$(CR) compose up -d
	make logs

logs:
	$(CR) compose logs -f

build:
	$(CR) compose build

stop:
	$(CR) compose down -v

restart: stop run

clean:
	$(CR) system prune -a --filter "until=24h"