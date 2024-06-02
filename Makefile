server: server-dev

server-dev:
	#rm tmp/pids/server.pid 2>/dev/null || true
	RAILS_ENV=development bundle exec rails s -b 0.0.0.0

server-development: server-dev

server-test:
	RAILS_ENV=test bundle exec rails s -b 0.0.0.0

server-prod:
	RAILS_ENV=production bundle exec rails s -b 0.0.0.0

server-production: server-prod

install: install-gems install-db

build: install
compile: install

install-gems:
	bundle install --path 'vendor/bundle'

install-db:
	bundle exec rails db:reset

test:
	RAILS_ENV=test bundle exec rspec

.PHONY: test