server:
	#rm tmp/pids/server.pid 2>/dev/null || true
	RAILS_ENV=development bundle exec rails s -b 0.0.0.0

install: install-gems install-db

build: install
compile: install

install-gems:
	bundle install --path 'vendor/bundle'

install-db:
	bundle exec rails db:reset