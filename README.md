# Саркастический Telegram-бот

Разработка ИИ-ассистента в виде Telegram-бота для консультаций с саркастическим оттенком.

## Быстрый старт

### 1. Настройка окружения
Создайте файл `.env` в корне проекта с необходимыми переменными:

```bash
# Telegram Bot Configuration
TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here

# OpenRouter LLM Configuration  
OPENROUTER_API_KEY=your_openrouter_api_key_here
OPENROUTER_MODEL=openai/gpt-4o-mini:free

# LLM Settings (опционально)
LLM_TIMEOUT=10
LLM_TEMPERATURE=0.8
LLM_RETRY_ATTEMPTS=3

# Logging Configuration (опционально)
LOG_LEVEL=INFO
LOG_FILE=logs/bot.log
DEBUG=false
```

### 2. Установка зависимостей
```bash
# Через install.cmd
install.cmd

# Или напрямую через uv (если установлен)
uv sync
```

### 3. Запуск бота
```bash
# Через dev.cmd
dev.cmd

# Или напрямую через uv
uv run python src/main.py
```

## Тестирование Итерации 2

✅ **Критерий готовности:** Бот отвечает через LLM на любые сообщения

🧪 **Тесты:**
1. Запустить `dev.cmd` → бот должен запуститься без ошибок
2. Написать боту `/start` → получить приветствие с упоминанием ИИ
3. Написать "Кто ты?" → получить ответ от LLM
4. Задать вопрос о работе → получить саркастический ответ от ИИ

## Структура проекта

```
src/
├── main.py                 # Точка входа
├── config/
│   └── settings.py         # Настройки и конфигурация
├── bot/
│   └── handlers.py         # Обработчики сообщений Telegram
├── llm/
│   └── client.py           # HTTP клиент для OpenRouter API
└── utils/
    └── logger.py           # Настройка логирования
prompts/
└── system.txt              # Системный промпт для ИИ
```

## Студент
**Фамилия Имя:** Тычина Руслан

**Статус выполнения:** Итерация 2 - ✅ Завершена
