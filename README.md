[![Test](https://github.com/frizus/ruby-test-work1/actions/workflows/main.yml/badge.svg)](https://github.com/frizus/ruby-test-work1/actions)

## О репозитории

Тестовое задание сделать админку для учета отпусков и отгулов в компании. Интерфейс `rails_admin`, аутентификация/авторизация `devise`, `cancancan`, линтер `rubocop`, тестирование `rspec`, `simplecov`

Не совсем удобный вход в админку, `rails_admin` ограничен в интерфейсе, делал тем, что он дает.
На локализацию почти не тратил времени.
После входа под админом или сотрудником выбрать `Approvals`. У записей в столбце `Status` будут кнопки перевода в другой статус.

Админ может одобрить, отклонить и рассматривать заявку (`Approve`, `Deny`, `Consider`)

Сотрудник может только создавать `заявки` (`Approvals`), бросать их в корзину (`Trash`) и восстанавливать из корзины (`Restore`)

Отправляется письмо при смене статуса (в `development`-среде письмо хранится в `tmp/mails/`) 

## Системные требования

* Ruby = 2.2.10
* Node.js >= 20.12.1
* SQLite3

# Установка

Если нет своей рабочей среды с `ruby-2.2.10`, можно установить конфигурацию `Docker` для `WSL2` отсюда https://github.com/frizus/ruby_2_docker/tree/for-ruby-test-work1
```sh
git clone -b for-ruby-test-work1 https://github.com/frizus/ruby_2_docker.git ruby-test-work1/
```
Дальше смотреть [README.md](https://github.com/frizus/ruby_2_docker/blob/for-ruby-test-work1/README.md) оттуда

ИЛИ

Если есть своя среда:
```sh
make install
make test # запускает тесты
make run # запускает сервер на http://localhost:3000
```

# Заняло времени
1. Установка ruby 2.2 на Docker, установка rails 5.0 (и там, и там были проблемы с зависимостями) - 5 часов
2. Установка админки, аутентификации, ролей - 9 часов (читал по гемам rails_admin, devise, cancancan)
3. Настройка заявок - 12.9 часов (разбирался в rails_admin, aasm)
4. Письма после смены статуса заявки - 4.7 часов (читал про ActionMailer)
5. Тесты, линтер, полировка, разворачивание проекта на рабочем компьютере - 6.5 часа
