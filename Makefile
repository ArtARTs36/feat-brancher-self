.PHONY: init install build run shell migrate

init:
	git clone git@github.com:ArtARTs36/feat-brancher.git app
	cp app/config/discovery.php config/app/discovery.php
	cp app/.env.example	.env
	echo "\nDOCKER_WEB_HTTP_PORT=8082" >> .env
	@printf "setup discovery parameters in config/discovery.php\n"
	@printf "setup environment parameters in .env"

install:
	make build
	docker-compose run feat-brancher-web bash -c "php artisan key:generate"
	make migrate

install-wd:
	make build
	docker-compose run feat-brancher-web bash -c "php artisan key:generate"
	make migrate-wd

build:
	docker-compose build

run:
	docker-compose up feat-brancher-web feat-brancher-cron feat-brancher-queue-task-fill

cache:
	docker-compose run feat-brancher-web sh -c "php artisan config:cache && php artisan route:cache"

shell:
	docker-compose run feat-brancher-web bash

migrate:
	docker-compose run feat-brancher-web sh -c "php artisan migrate --force"

migrate-wd:
	docker-compose up -d feat-brancher-db
	docker-compose run feat-brancher-web sh -c "php artisan migrate --force"
	docker-compose stop feat-brancher-db

copy-ssh:
	cp -r ~/.ssh/* ./config/.ssh/

clean-logs:
	rm -rf storage/logs/*.log
