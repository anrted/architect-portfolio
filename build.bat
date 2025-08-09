@echo off
chcp 65001 >nul

echo 🏗️  Начинаем сборку проекта Architect Portfolio...

REM Проверяем наличие Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js не установлен. Пожалуйста, установите Node.js
    pause
    exit /b 1
)

REM Проверяем наличие npm
npm --version >nul 2>&1
if errorlevel 1 (
    echo ❌ npm не установлен. Пожалуйста, установите npm
    pause
    exit /b 1
)

REM Создаем папку для сборки
echo 📁 Создаем папку для сборки...
if exist build rmdir /s /q build
mkdir build

REM Устанавливаем зависимости
echo 📦 Устанавливаем зависимости...
npm install

REM Собираем фронтенд
echo 🔨 Собираем фронтенд (Vue.js)...
npm run build

REM Копируем собранный фронтенд
echo 📋 Копируем собранный фронтенд...
xcopy /e /i /y dist\* build\

REM Копируем PHP файлы
echo 📋 Копируем PHP файлы...
xcopy /e /i /y public\* build\

REM Копируем README и документацию
echo 📋 Копируем документацию...
if exist README.md copy README.md build\
if exist COMPONENTS_MANAGEMENT.md copy COMPONENTS_MANAGEMENT.md build\
if exist ADMIN_README.md copy ADMIN_README.md build\
if exist USERS_MANAGEMENT.md copy USERS_MANAGEMENT.md build\
if exist COLOR_PALETTE_FEATURE.md copy COLOR_PALETTE_FEATURE.md build\
if exist SETTINGS_API_README.md copy SETTINGS_API_README.md build\

REM Создаем .htaccess для Apache
echo 📋 Создаем .htaccess...
(
echo RewriteEngine On
echo.
echo # Handle Angular and Vue Router
echo RewriteCond %%{REQUEST_FILENAME} !-f
echo RewriteCond %%{REQUEST_FILENAME} !-d
echo RewriteRule ^(.*^)$ /index.html [QSA,L]
echo.
echo # Security headers
echo Header always set X-Content-Type-Options nosniff
echo Header always set X-Frame-Options DENY
echo Header always set X-XSS-Protection "1; mode=block"
echo.
echo # Cache static assets
echo ^<IfModule mod_expires.c^>
echo     ExpiresActive on
echo     ExpiresByType text/css "access plus 1 year"
echo     ExpiresByType application/javascript "access plus 1 year"
echo     ExpiresByType image/png "access plus 1 year"
echo     ExpiresByType image/jpg "access plus 1 year"
echo     ExpiresByType image/jpeg "access plus 1 year"
echo     ExpiresByType image/gif "access plus 1 year"
echo     ExpiresByType image/svg+xml "access plus 1 year"
echo ^</IfModule^>
echo.
echo # Compress files
echo ^<IfModule mod_deflate.c^>
echo     AddOutputFilterByType DEFLATE text/plain
echo     AddOutputFilterByType DEFLATE text/html
echo     AddOutputFilterByType DEFLATE text/xml
echo     AddOutputFilterByType DEFLATE text/css
echo     AddOutputFilterByType DEFLATE application/xml
echo     AddOutputFilterByType DEFLATE application/xhtml+xml
echo     AddOutputFilterByType DEFLATE application/rss+xml
echo     AddOutputFilterByType DEFLATE application/javascript
echo     AddOutputFilterByType DEFLATE application/x-javascript
echo ^</IfModule^>
) > build\.htaccess

REM Создаем инструкцию по установке
echo 📋 Создаем инструкцию по установке...
(
echo # Инструкция по установке Architect Portfolio
echo.
echo ## 🎯 Обзор проекта
echo.
echo Architect Portfolio - это полнофункциональный сайт-портфолио архитектора с админ-панелью для управления контентом.
echo.
echo ### Основные возможности:
echo - ✅ Современный дизайн с адаптивной версткой
echo - ✅ Админ-панель для управления контентом
echo - ✅ Управление проектами и галереей
echo - ✅ Управление компонентами главной страницы
echo - ✅ Система пользователей с правами доступа
echo - ✅ Цветовая палитра и настройки темы
echo - ✅ Резервное копирование базы данных
echo - ✅ Drag-and-drop интерфейс для компонентов
echo.
echo ## 🚀 Быстрая установка
echo.
echo ### 1. Требования
echo - PHP 7.4+ или 8.0+
echo - MySQL 5.7+ или MariaDB 10.2+
echo - Apache/Nginx
echo - Composer (опционально)
echo.
echo ### 2. Настройка базы данных
echo 1. Создайте новую базу данных
echo 2. Импортируйте структуру из файла `backups/backup_architect_portfolio_*.sql`
echo 3. Настройте подключение в `api/db.php`
echo.
echo ### 3. Настройка веб-сервера
echo 1. Скопируйте все файлы в корневую папку сайта
echo 2. Убедитесь, что mod_rewrite включен (для Apache)
echo 3. Настройте права доступа: `chmod 755` для папок, `chmod 644` для файлов
echo.
echo ### 4. Настройка PHP
echo 1. Убедитесь, что расширения PHP включены:
echo    - pdo_mysql
echo    - json
echo    - mbstring
echo    - fileinfo
echo.
echo ### 5. Первоначальная настройка
echo 1. Откройте сайт в браузере
echo 2. Перейдите в админ-панель: `/admin`
echo 3. Войдите с данными по умолчанию:
echo    - Логин: `admin`
echo    - Пароль: `admin123`
echo.
echo ## 🔧 Детальная настройка
echo.
echo ### Настройка базы данных
echo Отредактируйте файл `api/db.php`:
echo ```php
echo ^<?php
echo $host = 'localhost';
echo $dbname = 'your_database_name';
echo $username = 'your_username';
echo $password = 'your_password';
echo ?^>
echo ```
echo.
echo ### Настройка API
echo Все API endpoints находятся в папке `api/`:
echo - `api/admin_*.php` - админские API (требуют авторизации)
echo - `api/*.php` - публичные API
echo.
echo ### Настройка CORS
echo Если сайт размещен на другом домене, настройте CORS в заголовках PHP файлов.
echo.
echo ## 🎨 Кастомизация
echo.
echo ### Изменение дизайна
echo - Цветовая палитра: `/admin/colors`
echo - Компоненты главной страницы: `/admin/components`
echo - Контент: `/admin/about`, `/admin/header`, `/admin/contacts`
echo.
echo ### Добавление новых компонентов
echo 1. Создайте Vue компонент в `src/components/`
echo 2. Добавьте в `componentMap` в `Home.vue`
echo 3. Обновите API в `api/admin_components.php`
echo.
echo ## 🔒 Безопасность
echo.
echo ### Рекомендации по безопасности:
echo 1. Измените пароли по умолчанию
echo 2. Настройте HTTPS
echo 3. Регулярно обновляйте резервные копии
echo 4. Мониторьте логи ошибок
echo.
echo ### Права доступа
echo Система поддерживает роли пользователей:
echo - `admin` - полные права
echo - `editor` - ограниченные права
echo.
echo ## 📞 Поддержка
echo.
echo При возникновении проблем:
echo 1. Проверьте логи ошибок PHP
echo 2. Убедитесь в правильности настроек БД
echo 3. Проверьте права доступа к файлам
echo 4. Обратитесь к документации в папке проекта
echo.
echo ## 📄 Лицензия
echo.
echo Проект разработан для демонстрации возможностей современной веб-разработки.
) > build\INSTALL.md

REM Создаем файл с информацией о версии
echo 📋 Создаем файл версии...
(
echo # Architect Portfolio - Версия 1.0.0
echo.
echo ## 📅 Дата сборки
echo %date% %time%
echo.
echo ## 🎯 Основные функции
echo - ✅ Современный дизайн с адаптивной версткой
echo - ✅ Админ-панель для управления контентом
echo - ✅ Управление проектами и галереей
echo - ✅ Управление компонентами главной страницы
echo - ✅ Система пользователей с правами доступа
echo - ✅ Цветовая палитра и настройки темы
echo - ✅ Резервное копирование базы данных
echo - ✅ Drag-and-drop интерфейс для компонентов
echo.
echo ## 🔧 Технологии
echo - Frontend: Vue.js 3 + Vite + Tailwind CSS
echo - Backend: PHP 7.4+ + MySQL
echo - Drag-and-drop: vuedraggable@next
echo - HTTP клиент: Axios
echo.
echo ## 📁 Структура проекта
echo ```
echo architect-portfolio/
echo ├── api/                    # PHP API endpoints
echo ├── assets/                 # Собранные ресурсы
echo ├── src/                    # Исходный код Vue.js
echo ├── admin/                  # Админ-панель
echo ├── components/             # Vue компоненты
echo ├── stores/                 # Vuex stores
echo └── docs/                   # Документация
echo ```
echo.
echo ## 🚀 Быстрый старт
echo 1. Настройте базу данных
echo 2. Скопируйте файлы на сервер
echo 3. Настройте права доступа
echo 4. Откройте сайт в браузере
echo 5. Войдите в админ-панель: /admin
echo.
echo ## 📞 Поддержка
echo См. файл INSTALL.md для подробной инструкции по установке.
) > build\VERSION.md

echo ✅ Сборка завершена!
echo 📁 Файлы проекта находятся в папке: build/
echo.
echo 🚀 Для установки:
echo 1. Скопируйте содержимое папки build на сервер
echo 2. Настройте базу данных
echo 3. Откройте сайт в браузере
echo 4. Войдите в админ-панель: /admin
echo.
pause
