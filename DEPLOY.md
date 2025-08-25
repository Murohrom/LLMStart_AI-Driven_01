# 🚀 Развертывание в облаке (Railway)

> Инструкция по развертыванию Саркастического Telegram-бота на Railway

## 📋 Предварительные требования

- GitHub аккаунт с репозиторием проекта
- Railway аккаунт (бесплатный план)
- Telegram Bot Token (от @BotFather)
- OpenRouter API Key

## 🎯 Варианты облачных сервисов

### 1. Railway (РЕКОМЕНДУЕМЫЙ)
- **Цена**: $5/месяц (бесплатный план)
- **Плюсы**: Простота, автоматический деплой, HTTPS, домен
- **Минусы**: Ограниченный бесплатный план

### 2. Render
- **Цена**: Бесплатно (с ограничениями)
- **Плюсы**: Полностью бесплатный план
- **Минусы**: Может "засыпать" при неактивности

### 3. Fly.io
- **Цена**: Бесплатно (3 VM)
- **Плюсы**: Глобальное распределение, высокая производительность
- **Минусы**: Сложная настройка

## 🚀 Развертывание на Railway

### Шаг 1: Подготовка репозитория

1. Убедитесь, что проект находится в GitHub репозитории
2. Проверьте наличие файлов:
   - `Dockerfile`
   - `.github/workflows/deploy.yml`
   - `pyproject.toml`
   - `env.example`

### Шаг 2: Создание аккаунта Railway

1. Перейдите на [railway.app](https://railway.app)
2. Зарегистрируйтесь через GitHub
3. Подтвердите email (если требуется)

### Шаг 3: Создание проекта

1. Нажмите "New Project"
2. Выберите "Deploy from GitHub repo"
3. Выберите ваш репозиторий
4. Railway автоматически определит Dockerfile

### Шаг 4: Настройка переменных окружения

В Railway Dashboard → Variables добавьте:

```bash
TELEGRAM_BOT_TOKEN=your_telegram_bot_token
OPENROUTER_API_KEY=your_openrouter_api_key
LOG_LEVEL=INFO
```

### Шаг 5: Настройка GitHub Secrets

В GitHub репозитории → Settings → Secrets and variables → Actions добавьте:

- `RAILWAY_TOKEN` - токен из Railway Dashboard → Account → Tokens

### Шаг 6: Первый деплой

1. Сделайте push в main ветку
2. GitHub Actions автоматически запустит деплой
3. Проверьте логи в Railway Dashboard

## 🔧 Альтернативное развертывание на Render

### Шаг 1: Создание аккаунта
1. Перейдите на [render.com](https://render.com)
2. Зарегистрируйтесь через GitHub

### Шаг 2: Создание Web Service
1. "New" → "Web Service"
2. Подключите GitHub репозиторий
3. Настройки:
   - **Name**: sarcastic-bot
   - **Environment**: Docker
   - **Branch**: main
   - **Root Directory**: (оставить пустым)

### Шаг 3: Переменные окружения
Добавьте те же переменные, что и для Railway.

## 🐳 Docker конфигурация

Убедитесь, что `Dockerfile` настроен правильно:

```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY pyproject.toml .
COPY . .

RUN pip install uv
RUN uv sync --frozen

EXPOSE 8000
CMD ["uv", "run", "python", "src/main.py"]
```

## 🔍 Мониторинг и логи

### Railway
- **Логи**: Dashboard → Service → Logs
- **Метрики**: Dashboard → Service → Metrics
- **Переменные**: Dashboard → Service → Variables

### Render
- **Логи**: Dashboard → Service → Logs
- **Метрики**: Dashboard → Service → Metrics
- **Переменные**: Dashboard → Service → Environment

## 🚨 Устранение неполадок

### Проблема: Бот не отвечает
1. Проверьте логи в облачном сервисе
2. Убедитесь, что переменные окружения настроены
3. Проверьте статус Telegram Bot API

### Проблема: Ошибки деплоя
1. Проверьте GitHub Actions логи
2. Убедитесь, что тесты проходят локально
3. Проверьте Dockerfile на ошибки

### Проблема: Высокое потребление ресурсов
1. Проверьте логи на утечки памяти
2. Оптимизируйте код при необходимости
3. Рассмотрите upgrade плана

## 📊 Стоимость и лимиты

### Railway
- **Бесплатный план**: $5/месяц кредитов
- **Лимиты**: 500 часов/месяц, 512MB RAM
- **Домен**: `your-app.railway.app`

### Render
- **Бесплатный план**: 750 часов/месяц
- **Лимиты**: 512MB RAM, "сон" при неактивности
- **Домен**: `your-app.onrender.com`

## 🔄 Автоматическое обновление

При push в main ветку:
1. GitHub Actions запускает тесты
2. При успешных тестах - деплой в облако
3. Бот автоматически обновляется

## 📝 Полезные команды

```bash
# Локальная проверка Docker
docker build -t sarcastic-bot .
docker run --env-file .env sarcastic-bot

# Проверка переменных окружения
railway variables list

# Просмотр логов
railway logs

# Ручной деплой
railway up
```

## 🎉 Готово!

После успешного деплоя ваш бот будет доступен 24/7 в облаке с автоматическими обновлениями при каждом push в main ветку.
