@echo off
chcp 65001 >nul

echo 🚀 Начинаем загрузку проекта на GitHub...

REM Проверяем наличие git
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git не установлен. Пожалуйста, установите Git
    pause
    exit /b 1
)

REM Проверяем наличие gh CLI (опционально)
gh --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  GitHub CLI не найден. Будем использовать ручную настройку
    set USE_GH_CLI=false
) else (
    echo ✅ GitHub CLI найден
    set USE_GH_CLI=true
)

REM Запрашиваем название репозитория
set /p REPO_NAME="Введите название репозитория (например: architect-portfolio): "

if "%REPO_NAME%"=="" (
    set REPO_NAME=architect-portfolio
)

REM Запрашиваем описание репозитория
set /p REPO_DESCRIPTION="Введите описание репозитория (опционально): "

if "%REPO_DESCRIPTION%"=="" (
    set REPO_DESCRIPTION=Современный сайт-портфолио архитектора с админ-панелью
)

echo 📋 Настройки репозитория:
echo    Название: %REPO_NAME%
echo    Описание: %REPO_DESCRIPTION%

REM Создаем .gitignore для продакшена
echo 📋 Обновляем .gitignore для продакшена...
(
echo # Logs
echo logs
echo *.log
echo npm-debug.log*
echo yarn-debug.log*
echo yarn-error.log*
echo pnpm-debug.log*
echo lerna-debug.log*
echo.
echo node_modules
echo # dist - включено для GitHub Pages
echo # dist-ssr
echo *.local
echo.
echo # Editor directories and files
echo .vscode/*
echo !.vscode/extensions.json
echo .idea
echo .DS_Store
echo *.suo
echo *.ntvs*
echo *.njsproj
echo *.sln
echo *.sw?
echo.
echo # Build files (исключаем только для разработки)
echo # dist/
echo.
echo # Environment variables
echo .env
echo .env.local
echo .env.development.local
echo .env.test.local
echo .env.production.local
) > .gitignore

REM Инициализируем git репозиторий (если еще не инициализирован)
if not exist ".git" (
    echo 🔧 Инициализируем Git репозиторий...
    git init
)

REM Добавляем все файлы
echo 📦 Добавляем файлы в Git...
git add .

REM Создаем первый коммит
echo 💾 Создаем первый коммит...
git commit -m "Initial commit: Architect Portfolio - современный сайт-портфолио архитектора

🎯 Основные возможности:
- ✅ Современный адаптивный дизайн
- ✅ Админ-панель для управления контентом
- ✅ Управление компонентами с drag-and-drop
- ✅ Система пользователей с правами доступа
- ✅ Резервное копирование базы данных
- ✅ Цветовая палитра и настройки темы

🔧 Технологии:
- Frontend: Vue.js 3 + Vite + Tailwind CSS
- Backend: PHP 7.4+ + MySQL
- Drag-and-drop: vuedraggable@next
- HTTP клиент: Axios"

REM Создаем репозиторий на GitHub
if "%USE_GH_CLI%"=="true" (
    echo 🌐 Создаем репозиторий на GitHub через CLI...
    gh repo create "%REPO_NAME%" --description "%REPO_DESCRIPTION%" --public --source=. --remote=origin --push
) else (
    echo 🌐 Создайте репозиторий на GitHub вручную:
    echo 1. Перейдите на https://github.com/new
    echo 2. Название репозитория: %REPO_NAME%
    echo 3. Описание: %REPO_DESCRIPTION%
    echo 4. Выберите 'Public'
    echo 5. НЕ инициализируйте с README, .gitignore или лицензией
    echo 6. Нажмите 'Create repository'
    echo.
    pause
    
    REM Добавляем remote origin
    echo 🔗 Добавляем remote origin...
    for /f "tokens=*" %%i in ('gh auth status --json 2^>nul ^| findstr /C:"login"') do (
        set USERNAME=%%i
    )
    if not defined USERNAME set USERNAME=YOUR_USERNAME
    git remote add origin "https://github.com/%USERNAME%/%REPO_NAME%.git"
)

REM Проверяем, добавлен ли remote
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Remote origin не найден. Добавьте его вручную:
    echo git remote add origin https://github.com/YOUR_USERNAME/%REPO_NAME%.git
    echo.
    pause
)

REM Пушим в main ветку
echo 📤 Пушим в GitHub...
git branch -M main
git push -u origin main

REM Создаем ветку для GitHub Pages
echo 🌐 Создаем ветку для GitHub Pages...
git checkout -b gh-pages

REM Копируем содержимое dist в корень для GitHub Pages
echo 📋 Копируем файлы для GitHub Pages...
if exist "dist" (
    REM Создаем временную папку
    mkdir temp_gh_pages 2>nul
    
    REM Копируем содержимое dist
    xcopy /e /i /y dist\* temp_gh_pages\
    
    REM Копируем важные файлы
    copy README.md temp_gh_pages\ 2>nul
    copy LICENSE temp_gh_pages\ 2>nul
    
    REM Удаляем старые файлы (кроме .git)
    for /d %%i in (*) do (
        if not "%%i"==".git" if not "%%i"=="temp_gh_pages" (
            rmdir /s /q "%%i"
        )
    )
    for %%i in (*) do (
        if not "%%i"==".git" if not "%%i"=="temp_gh_pages" (
            del "%%i"
        )
    )
    
    REM Перемещаем файлы из временной папки
    move temp_gh_pages\* .
    rmdir temp_gh_pages
    
    REM Добавляем все файлы
    git add .
    
    REM Коммитим изменения
    git commit -m "Deploy to GitHub Pages: Architect Portfolio

🚀 Развертывание на GitHub Pages
- ✅ Собранный фронтенд (Vue.js)
- ✅ PHP API endpoints
- ✅ Документация
- ✅ Готов к использованию

📁 Структура:
- index.html - главная страница
- assets/ - собранные ресурсы
- api/ - PHP API
- backups/ - резервные копии БД"
    
    REM Пушим gh-pages ветку
    git push -u origin gh-pages
    
    REM Возвращаемся на main ветку
    git checkout main
) else (
    echo ⚠️  Папка dist не найдена. Создайте сборку: npm run build
)

REM Создаем README для GitHub
echo 📋 Создаем README для GitHub...
(
echo # 🏗️ Architect Portfolio
echo.
echo Современный сайт-портфолио архитектора с полнофункциональной админ-панелью для управления контентом.
echo.
echo ## 🌐 Демо
echo.
echo **🌐 Живой сайт**: [https://YOUR_USERNAME.github.io/architect-portfolio](https://YOUR_USERNAME.github.io/architect-portfolio)
echo.
echo ## 🎯 Основные возможности
echo.
echo ### 🌐 Фронтенд (Vue.js 3)
echo - ✅ Современный адаптивный дизайн
echo - ✅ Динамическая загрузка компонентов
echo - ✅ Drag-and-drop управление компонентами
echo - ✅ Цветовая палитра и настройки темы
echo - ✅ Оптимизированная производительность
echo.
echo ### 🔧 Админ-панель
echo - ✅ Управление проектами и галереей
echo - ✅ Управление компонентами главной страницы
echo - ✅ Система пользователей с правами доступа
echo - ✅ Редактирование контента (о себе, контакты, шапка)
echo - ✅ Резервное копирование базы данных
echo - ✅ Цветовая палитра и настройки темы
echo.
echo ### 🎨 Дизайн и UX
echo - ✅ Современный минималистичный дизайн
echo - ✅ Адаптивная верстка для всех устройств
echo - ✅ Плавные анимации и переходы
echo - ✅ Интуитивный интерфейс
echo - ✅ Drag-and-drop функциональность
echo.
echo ## 🚀 Быстрый старт
echo.
echo ### Требования
echo - PHP 7.4+ или 8.0+
echo - MySQL 5.7+ или MariaDB 10.2+
echo - Node.js 16+ и npm
echo - Apache/Nginx
echo.
echo ### Установка
echo.
echo 1. **Клонируйте репозиторий**
echo ```bash
echo git clone https://github.com/YOUR_USERNAME/architect-portfolio.git
echo cd architect-portfolio
echo ```
echo.
echo 2. **Установите зависимости**
echo ```bash
echo npm install
echo ```
echo.
echo 3. **Настройте базу данных**
echo - Создайте новую базу данных
echo - Импортируйте структуру из `backups/backup_architect_portfolio_*.sql`
echo - Настройте подключение в `public/api/db.php`
echo.
echo 4. **Запустите в режиме разработки**
echo ```bash
echo npm run dev
echo ```
echo.
echo 5. **Соберите для продакшена**
echo ```bash
echo npm run build
echo ```
echo.
echo ## 📁 Структура проекта
echo.
echo ```
echo architect-portfolio/
echo ├── src/                        # Исходный код Vue.js
echo │   ├── components/             # Vue компоненты
echo │   │   ├── admin/             # Компоненты админ-панели
echo │   │   └── ...                # Публичные компоненты
echo │   ├── stores/                # Vuex stores
echo │   ├── router.js              # Маршрутизация
echo │   └── main.js                # Точка входа
echo ├── public/                    # Публичные файлы
echo │   ├── api/                   # PHP API endpoints
echo │   ├── backups/               # Резервные копии БД
echo │   └── index.html             # Главная страница
echo ├── dist/                      # Собранные файлы (после build)
echo └── docs/                      # Документация
echo ```
echo.
echo ## 🔧 API Endpoints
echo.
echo ### Админские API (требуют авторизации)
echo - `GET/POST /api/admin_components.php` - управление компонентами
echo - `GET/POST /api/admin_projects.php` - управление проектами
echo - `GET/POST /api/admin_users.php` - управление пользователями
echo - `GET/POST /api/admin_about.php` - редактирование главной страницы
echo - `GET/POST /api/admin_header.php` - редактирование шапки
echo - `GET/POST /api/admin_contacts.php` - редактирование контактов
echo - `GET/POST /api/admin_backup.php` - резервное копирование
echo.
echo ### Публичные API
echo - `GET /api/components.php` - получение настроек компонентов
echo - `GET /api/projects.php` - получение проектов
echo - `GET /api/about.php` - получение контента главной страницы
echo - `GET /api/contacts.php` - получение контактов
echo.
echo ## 🎨 Кастомизация
echo.
echo ### Управление компонентами
echo 1. Войдите в админ-панель: `/admin`
echo 2. Перейдите в раздел "Компоненты"
echo 3. Используйте drag-and-drop для изменения порядка
echo 4. Включайте/выключайте компоненты переключателями
echo.
echo ### Изменение дизайна
echo - **Цветовая палитра**: `/admin/colors`
echo - **Компоненты**: `/admin/components`
echo - **Контент**: `/admin/about`, `/admin/header`, `/admin/contacts`
echo.
echo ## 🔒 Безопасность
echo.
echo ### Рекомендации
echo 1. Измените пароли по умолчанию
echo 2. Настройте HTTPS
echo 3. Регулярно обновляйте резервные копии
echo 4. Мониторьте логи ошибок
echo.
echo ### Права доступа
echo - `admin` - полные права на все разделы
echo - `editor` - ограниченные права в зависимости от настроек
echo.
echo ## 📦 Сборка проекта
echo.
echo ### Автоматическая сборка
echo ```bash
echo # Linux/Mac
echo ./build.sh
echo.
echo # Windows
echo build.bat
echo ```
echo.
echo ### Ручная сборка
echo ```bash
echo # Установка зависимостей
echo npm install
echo.
echo # Сборка фронтенда
echo npm run build
echo.
echo # Копирование файлов
echo cp -r dist/* build/
echo cp -r public/* build/
echo ```
echo.
echo ## 🎯 Основные функции
echo.
echo ### Управление контентом
echo - ✅ Редактирование главной страницы
echo - ✅ Управление проектами и галереей
echo - ✅ Редактирование контактов
echo - ✅ Управление шапкой сайта
echo.
echo ### Система пользователей
echo - ✅ Регистрация и авторизация
echo - ✅ Роли и права доступа
echo - ✅ Управление пользователями
echo.
echo ### Дизайн и UX
echo - ✅ Адаптивная верстка
echo - ✅ Современный дизайн
echo - ✅ Drag-and-drop интерфейс
echo - ✅ Цветовая палитра
echo.
echo ### Технические возможности
echo - ✅ API-first архитектура
echo - ✅ Современный стек (Vue 3, PHP 8)
echo - ✅ Оптимизированная производительность
echo - ✅ Безопасность и валидация
echo.
echo ## 📞 Поддержка
echo.
echo ### Документация
echo - [Инструкция по установке](INSTALL.md)
echo - [Управление компонентами](COMPONENTS_MANAGEMENT.md)
echo - [Админ-панель](ADMIN_README.md)
echo - [Управление пользователями](USERS_MANAGEMENT.md)
echo - [Цветовая палитра](COLOR_PALETTE_FEATURE.md)
echo - [API настройки](SETTINGS_API_README.md)
echo.
echo ### Решение проблем
echo 1. Проверьте логи ошибок PHP
echo 2. Убедитесь в правильности настроек БД
echo 3. Проверьте права доступа к файлам
echo 4. Обратитесь к документации
echo.
echo ## 📄 Лицензия
echo.
echo Проект разработан для демонстрации возможностей современной веб-разработки.
echo.
echo ## 🚀 Разработка
echo.
echo ### Команды разработки
echo ```bash
echo # Запуск в режиме разработки
echo npm run dev
echo.
echo # Сборка для продакшена
echo npm run build
echo.
echo # Предварительный просмотр сборки
echo npm run preview
echo ```
echo.
echo ### Структура разработки
echo - **Frontend**: Vue.js 3 + Vite + Tailwind CSS
echo - **Backend**: PHP 7.4+ + MySQL
echo - **State Management**: Vuex/Pinia
echo - **HTTP Client**: Axios
echo - **Drag-and-drop**: vuedraggable@next
echo.
echo ---
echo.
echo **Architect Portfolio** - современное решение для создания профессиональных сайтов-портфолио архитекторов.
echo.
echo ## ⭐ Поддержка проекта
echo.
echo Если проект вам понравился, поставьте звездочку ⭐ на GitHub!
) > README.md

REM Обновляем README с правильным именем пользователя
if "%USE_GH_CLI%"=="true" (
    for /f "tokens=*" %%i in ('gh auth status --json 2^>nul ^| findstr /C:"login"') do (
        set USERNAME=%%i
    )
    if not defined USERNAME set USERNAME=YOUR_USERNAME
) else (
    set USERNAME=YOUR_USERNAME
)

REM Заменяем placeholder в README
powershell -Command "(Get-Content README.md) -replace 'YOUR_USERNAME', '%USERNAME%' | Set-Content README.md"

REM Коммитим обновленный README
git add README.md
git commit -m "docs: обновлен README для GitHub"
git push

echo.
echo 🎉 Проект успешно загружен на GitHub!
echo.
echo 📋 Следующие шаги:
echo 1. Перейдите на https://github.com/%USERNAME%/%REPO_NAME%
echo 2. В настройках репозитория включите GitHub Pages:
echo    - Settings ^> Pages
echo    - Source: Deploy from a branch
echo    - Branch: gh-pages
echo    - Folder: / (root)
echo 3. Подождите несколько минут для развертывания
echo 4. Ваш сайт будет доступен по адресу: https://%USERNAME%.github.io/%REPO_NAME%
echo.
echo 🔗 Полезные ссылки:
echo - Репозиторий: https://github.com/%USERNAME%/%REPO_NAME%
echo - GitHub Pages: https://%USERNAME%.github.io/%REPO_NAME%
echo - Issues: https://github.com/%USERNAME%/%REPO_NAME%/issues
echo.
echo 🚀 Удачной работы с Architect Portfolio!
pause
