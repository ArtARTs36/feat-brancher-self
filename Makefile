.PHONY: init install build run shell migrate

init:
	git clone https://github.com/ArtARTs36/feat-brancher app
	cp app/config/discovery.php config/app/discovery.php
	cp app/.env.example	.env
	touch ./storage/database.sqlite
	echo "\nDOCKER_WEB_HTTP_PORT=8082" >> .env
	@printf "setup discovery parameters in config/discovery.php\n"
	@printf "setup environment parameters in .env"

install:
	make build
	docker-compose run feat-brancher-web bash -c "php artisan key:generate && php artisan migrate --force"

build:
	docker-compose build

run:
	docker-compose up feat-brancher-web feat-brancher-cron feat-brancher-queue-task-fill

cache:
	docker-compose run feat-brancher-web sh -c "php artisan config:cache && php artisan route:cache"

shell:
	docker-compose run feat-brancher-web bash

migrate:
	docker-compose run feat-brancher-web sh -c "php artisan migrate"

copy-ssh:
	cp ~/.ssh ./config/.ssh/
