# rails-project-66

[![Actions Status](https://github.com/Houssse/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Houssse/rails-project-66/actions)
[![Lint](https://github.com/Houssse/rails-project-65/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/Houssse/rails-project-65/actions/workflows/lint.yml)
[![Test](https://github.com/Houssse/rails-project-65/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/Houssse/rails-project-65/actions/workflows/test.yml)

## О проекте

**rails-project-66** — это веб-приложение, позволяющее пользователям добавлять репозитории с GitHub и выполнять автоматическую проверку кода с помощью линтеров (Rubocop и ESLint). Проверки привязываются к конкретным коммитам, а результаты отправляются пользователю по email.

## Демонстрация

Проект развернут на Render и доступен по адресу:
[https://rails-project-66-l2x8.onrender.com/](https://rails-project-66-l2x8.onrender.com/)

## Основной функционал

- Авторизация через GitHub (OmniAuth).
- Добавление репозиториев для анализа.
- Автоматическая установка вебхуков для отслеживания коммитов.
- Проверка кода с помощью Rubocop и ESLint.
- Отправка отчетов о проверках пользователям по email.

## Установка и запуск

1. **Клонируйте репозиторий:**
   ```sh
   git clone https://github.com/Houssse/rails-project-66.git
   cd rails-project-66
   ```
2. **Установите зависимости:**
   ```sh
   bundle install
   yarn install
   ```
3. **Настройте переменные окружения:**
   Создайте файл `.env` и укажите в нем:
   ```env
   GITHUB_CLIENT_ID=your_client_id
   GITHUB_CLIENT_SECRET=your_client_secret

   MAILTRAP_USERNAME=your_mailtrap_username
   MAILTRAP_PASSWORD=your_mailtrap_password
   ```
4. **Запустите сервер:**
   ```sh
   rails s
   ```

## Запуск тестов

Для проверки работоспособности проекта выполните:
```sh
make test
```


