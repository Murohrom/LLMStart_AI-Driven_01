@echo off
echo 🚀 Развертывание Саркастического бота в облаке
echo.

echo 📋 Проверка предварительных требований...
echo.

REM Проверяем наличие Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker не установлен. Установите Docker Desktop.
    pause
    exit /b 1
)
echo ✅ Docker установлен

REM Проверяем наличие .env файла
if not exist .env (
    echo ❌ Файл .env не найден. Скопируйте env.example в .env и настройте переменные.
    pause
    exit /b 1
)
echo ✅ Файл .env найден

REM Проверяем тесты
echo.
echo 🧪 Запуск тестов...
uv run pytest tests/ -v --tb=short
if errorlevel 1 (
    echo ❌ Тесты не прошли. Исправьте ошибки перед деплоем.
    pause
    exit /b 1
)
echo ✅ Тесты прошли успешно

REM Сборка Docker образа
echo.
echo 🐳 Сборка Docker образа...
docker build -t sarcastic-bot .
if errorlevel 1 (
    echo ❌ Ошибка сборки Docker образа.
    pause
    exit /b 1
)
echo ✅ Docker образ собран

REM Тестирование образа
echo.
echo 🔍 Тестирование Docker образа...
docker run --env-file .env --rm sarcastic-bot --help >nul 2>&1
if errorlevel 1 (
    echo ❌ Ошибка тестирования Docker образа.
    pause
    exit /b 1
)
echo ✅ Docker образ работает корректно

echo.
echo 🎉 Готово к развертыванию!
echo.
echo 📝 Следующие шаги:
echo 1. Создайте аккаунт на Railway: https://railway.app
echo 2. Подключите GitHub репозиторий
echo 3. Настройте переменные окружения в Railway Dashboard
echo 4. Сделайте push в main ветку для автоматического деплоя
echo.
echo 📖 Подробная инструкция: DEPLOY.md
echo.
pause
