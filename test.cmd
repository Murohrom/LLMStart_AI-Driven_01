@echo off
chcp 65001 >nul
rem Команда для запуска тестов саркастического бота
rem Использует uv для управления зависимостями

echo.
echo ==========================================
echo   🧪 ЗАПУСК ТЕСТОВ САРКАСТИЧЕСКОГО БОТА
echo ==========================================
echo.

rem Проверка что uv установлен
where uv >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Ошибка: uv не найден в системе
    echo Установите uv: https://docs.astral.sh/uv/getting-started/installation/
    echo.
    pause
    exit /b 1
)

rem Проверка что виртуальное окружение активировано
echo 📦 Устанавливаем dev зависимости...
uv sync
if %errorlevel% neq 0 (
    echo ❌ Ошибка установки зависимостей
    pause
    exit /b 1
)

echo ✅ Зависимости установлены
echo.

rem Запуск линтеров
echo 🔍 Проверка качества кода...
echo.

echo 📋 Flake8 (проверка стиля кода):
uv run flake8 src tests --count --select=E9,F63,F7,F82 --show-source --statistics
if %errorlevel% neq 0 (
    echo ❌ Обнаружены критические ошибки в коде
    pause
    exit /b 1
)

echo 🔍 MyPy (проверка типов):
uv run mypy src --ignore-missing-imports
if %errorlevel% neq 0 (
    echo ⚠️ Обнаружены проблемы с типизацией
    rem Не останавливаемся на ошибках mypy для MVP
)

echo ✅ Проверка качества кода завершена
echo.

rem Запуск тестов
echo 🧪 Запуск unit тестов...
echo.

uv run pytest tests/ -v --tb=short
set TEST_EXIT_CODE=%errorlevel%

echo.
if %TEST_EXIT_CODE% equ 0 (
    echo ✅ ВСЕ ТЕСТЫ ПРОШЛИ УСПЕШНО!
    echo.
    echo 📊 Генерация отчета о покрытии...
    uv run pytest tests/ --cov=src --cov-report=term-missing --cov-report=html
    echo.
    echo 📈 HTML отчет сохранен в htmlcov/index.html
) else (
    echo ❌ НЕКОТОРЫЕ ТЕСТЫ НЕ ПРОШЛИ
    echo Проверьте вывод выше для деталей
)

echo.
echo ==========================================
echo   🎯 ТЕСТИРОВАНИЕ ЗАВЕРШЕНО  
echo ==========================================
echo.

pause
exit /b %TEST_EXIT_CODE%
