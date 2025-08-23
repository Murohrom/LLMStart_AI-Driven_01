# 🐳 Docker контейнеризация sarcastic-bot

## Быстрый старт

### 1. Установка Docker
- **Windows**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- **Linux**: `sudo apt install docker.io docker-compose`
- **macOS**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### 2. Подготовка конфигурации
```cmd
# Создайте .env файл из примера
copy env.example .env

# Отредактируйте .env файл с вашими токенами:
# - TELEGRAM_BOT_TOKEN
# - OPENROUTER_API_KEY
```

### 3. Запуск бота

#### Простой способ (Windows)
```cmd
# Сборка и запуск одной командой
run.cmd
```

#### Через Docker Compose (разработка)
```cmd
docker-compose up -d
```

#### Ручной запуск
```cmd
# Сборка образа
build.cmd
# или
docker build -t sarcastic-bot .

# Запуск контейнера
docker run -d --name sarcastic-bot --env-file .env -v "%cd%\logs:/app/logs" sarcastic-bot
```

## Управление контейнером

### Мониторинг
```cmd
# Просмотр статуса
docker ps

# Просмотр логов
docker logs sarcastic-bot-container

# Логи в реальном времени
docker logs -f sarcastic-bot-container
```

### Управление
```cmd
# Остановка
docker stop sarcastic-bot-container

# Перезапуск
docker restart sarcastic-bot-container

# Удаление
docker rm sarcastic-bot-container
```

## Структура образа

### Характеристики
- **Базовый образ**: `python:3.11-slim`
- **Менеджер пакетов**: `uv` (быстрая установка зависимостей)
- **Рабочая директория**: `/app`
- **Пользователь**: `botuser` (без привилегий)
- **Порты**: не экспонированы (бот работает через Telegram API)

### Переменные окружения
См. файл `env.example` для полного списка настроек.

### Монтируемые тома
- `./logs:/app/logs` - логи бота
- (для разработки) `./src:/app/src` - горячая перезагрузка кода

## Деплой в продакшн

### Автоматический деплой
```cmd
deploy.cmd
```

### Ручной деплой
```cmd
# 1. Остановка старых контейнеров
docker stop sarcastic-bot-prod
docker rm sarcastic-bot-prod

# 2. Сборка образа
docker build -t sarcastic-bot:latest .

# 3. Запуск в продакшене
docker run -d \
    --name sarcastic-bot-prod \
    --env-file .env \
    --restart unless-stopped \
    -v "./logs:/app/logs" \
    sarcastic-bot:latest
```

## Развитие и CI/CD

### Профили Docker Compose
```cmd
# Разработка (с горячей перезагрузкой)
docker-compose up

# Тестирование
docker-compose --profile test up bot-test
```

### Интеграция с CI/CD
Файлы готовы для интеграции с:
- **GitHub Actions** (используйте `docker build` и `docker push`)
- **Railway** (автоматическое определение Dockerfile)
- **Heroku** (через heroku.yml)

### Мониторинг в продакшене
- Логи доступны в папке `logs/`
- Статус контейнера: `docker ps`
- Перезапуск при сбое: `--restart unless-stopped`

## Устранение проблем

### Проблема: "Cannot connect to Docker daemon"
**Решение**: Запустите Docker Desktop и убедитесь что он полностью загрузился.

### Проблема: "Permission denied"
**Решение**: На Linux добавьте пользователя в группу docker:
```bash
sudo usermod -aG docker $USER
```

### Проблема: Бот не отвечает
**Решение**: 
1. Проверьте логи: `docker logs sarcastic-bot-container`
2. Убедитесь что токены в .env корректны
3. Проверьте что контейнер запущен: `docker ps`

### Проблема: Файлы логов не создаются
**Решение**: Убедитесь что папка `logs/` существует и доступна для записи.
