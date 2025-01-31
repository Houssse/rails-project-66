setup:
	bin/setup
	yarn install

lint: 
	bundle exec rubocop
	bundle exec slim-lint app/views

prepare_test_db:
	bin/rails db:test:prepare

test: prepare_test_db
	# Запуск всех тестов через Minitest
	bin/rails test

test_integration:
	# Запуск интеграционных тестов
	bin/rails test test/integration