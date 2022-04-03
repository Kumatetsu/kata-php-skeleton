.PHONY: all
MAKEFLAGS += --silent

WORKSPACE:=$(shell pwd)
CURRENT_DIR=$(shell basename ${WORKSPACE})
DOCKER_IMAGE=php-kata-skeleton
TEST_COMMAND=./vendor/bin/phpunit --color=always

install:
	composer install

test:
	${TEST_COMMAND}

docker-build:
	docker build -t ${DOCKER_IMAGE} .

docker-ssh:
	docker exec -it ${DOCKER_IMAGE} bash

docker-run:
	docker run -it --rm -d --name ${DOCKER_IMAGE} \
	-v ${WORKSPACE}/kata:/src/kata/kata:rw \
	${DOCKER_IMAGE}
	docker cp ${DOCKER_IMAGE}:/src/kata/vendor ${WORKSPACE}/vendor

docker-stop:
	docker stop ${DOCKER_IMAGE}

docker-tests:
	docker exec -t -i ${DOCKER_IMAGE} ${TEST_COMMAND}

init-repository:
	git remote rm origin
	git remote add origin git@github.com:${GITHUB_USER}/${CURRENT_DIR}.git
	git branch -M main
	git push -u origin main
