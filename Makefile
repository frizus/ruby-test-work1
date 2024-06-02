run: server-dev

server-dev:
	RAILS_ENV=development bundle exec rails s -b 0.0.0.0

server-test:
	RAILS_ENV=test bundle exec rails s -b 0.0.0.0

server-prod:
	RAILS_ENV=production bundle exec rails s -b 0.0.0.0

install-gems:
	bundle install --path 'vendor/bundle'

update-gems:
	bundle update

install-db:
	bin/rails db:drop
	bin/rails db:create
	bin/rails db:schema:load
	bin/rails db:migrate

test:
	RAILS_ENV=test bundle exec rspec

lint:
	bundle exec rubocop

install: install-gems install-db

setup: install

build: install

compile: install

server-development: server-dev

server-production: server-prod

server: server-dev

linter: lint

syntax: lint

.PHONY: test
