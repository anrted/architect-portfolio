#!/bin/bash

# Скрипт для полной сборки проекта Architect Portfolio
# Включает фронтенд (Vue.js) и backend (PHP)

echo "🏗️  Начинаем сборку проекта Architect Portfolio..."

# Проверяем наличие Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js не установлен. Пожалуйста, установите Node.js"
    exit 1
fi

# Проверяем наличие npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm не установлен. Пожалуйста, установите npm"
    exit 1
fi

# Создаем папку для сборки
echo "📁 Создаем папку для сборки..."
rm -rf build
mkdir -p build

# Устанавливаем зависимости
echo "📦 Устанавливаем зависимости..."
npm install

# Собираем фронтенд
echo "🔨 Собираем фронтенд (Vue.js)..."
npm run build

# Копируем собранный фронтенд
echo "📋 Копируем собранный фронтенд..."
cp -r dist/* build/

# Копируем PHP файлы
echo "📋 Копируем PHP файлы..."
cp -r public/* build/

# Копируем README и документацию
echo "📋 Копируем документацию..."
cp README.md build/
cp COMPONENTS_MANAGEMENT.md build/
cp ADMIN_README.md build/
cp USERS_MANAGEMENT.md build/
cp COLOR_PALETTE_FEATURE.md build/
cp SETTINGS_API_README.md build/

# Создаем .htaccess для Apache
echo "📋 Создаем .htaccess..."
cat > build/.htaccess << 'EOF'
RewriteEngine On

# Handle Angular and Vue Router
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /index.html [QSA,L]

# Security headers
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"

# Cache static assets
<IfModule mod_expires.c>
    ExpiresActive on
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>

# Compress files
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>
EOF

# Создаем инструкцию по установке
echo "📋 Создаем инструкцию по установке..."
cat > build/INSTALL.md << 'EOF'
# Инструкция по установке Architect Portfolio

## 🎯 Обзор проекта

Architect Portfolio - это полнофункциональный сайт-портфолио архитектора с админ-панелью для управления контентом.

### Основные возможности:
- ✅ Современный дизайн с адаптивной версткой
- ✅ Админ-панель для управления контентом
- ✅ Управление проектами и галереей
- ✅ Управление компонентами главной страницы
- ✅ Система пользователей с правами доступа
- ✅ Цветовая палитра и настройки темы
- ✅ Резервное копирование базы данных
- ✅ Drag-and-drop интерфейс для компонентов

## 🚀 Быстрая установка

### 1. Требования
- PHP 7.4+ или 8.0+
- MySQL 5.7+ или MariaDB 10.2+
- Apache/Nginx
- Composer (опционально)

### 2. Настройка базы данных
1. Создайте новую базу данных
2. Импортируйте структуру из файла `backups/backup_architect_portfolio_*.sql`
3. Настройте подключение в `api/db.php`

### 3. Настройка веб-сервера
1. Скопируйте все файлы в корневую папку сайта
2. Убедитесь, что mod_rewrite включен (для Apache)
3. Настройте права доступа: `chmod 755` для папок, `chmod 644` для файлов

### 4. Настройка PHP
1. Убедитесь, что расширения PHP включены:
   - pdo_mysql
   - json
   - mbstring
   - fileinfo

### 5. Первоначальная настройка
1. Откройте сайт в браузере
2. Перейдите в админ-панель: `/admin`
3. Войдите с данными по умолчанию:
   - Логин: `admin`
   - Пароль: `admin123`

## 🔧 Детальная настройка

### Настройка базы данных
Отредактируйте файл `api/db.php`:
```php
<?php
$host = 'localhost';
$dbname = 'your_database_name';
$username = 'your_username';
$password = 'your_password';
?>
```

### Настройка API
Все API endpoints находятся в папке `api/`:
- `api/admin_*.php` - админские API (требуют авторизации)
- `api/*.php` - публичные API

### Настройка CORS
Если сайт размещен на другом домене, настройте CORS в заголовках PHP файлов.

## 🎨 Кастомизация

### Изменение дизайна
- Цветовая палитра: `/admin/colors`
- Компоненты главной страницы: `/admin/components`
- Контент: `/admin/about`, `/admin/header`, `/admin/contacts`

### Добавление новых компонентов
1. Создайте Vue компонент в `src/components/`
2. Добавьте в `componentMap` в `Home.vue`
3. Обновите API в `api/admin_components.php`

## 🔒 Безопасность

### Рекомендации по безопасности:
1. Измените пароли по умолчанию
2. Настройте HTTPS
3. Регулярно обновляйте резервные копии
4. Мониторьте логи ошибок

### Права доступа
Система поддерживает роли пользователей:
- `admin` - полные права
- `editor` - ограниченные права

## 📞 Поддержка

При возникновении проблем:
1. Проверьте логи ошибок PHP
2. Убедитесь в правильности настроек БД
3. Проверьте права доступа к файлам
4. Обратитесь к документации в папке проекта

## 📄 Лицензия

Проект разработан для демонстрации возможностей современной веб-разработки.
EOF

# Создаем файл с информацией о версии
echo "📋 Создаем файл версии..."
cat > build/VERSION.md << 'EOF'
# Architect Portfolio - Версия 1.0.0

## 📅 Дата сборки
$(date)

## 🎯 Основные функции
- ✅ Современный дизайн с адаптивной версткой
- ✅ Админ-панель для управления контентом
- ✅ Управление проектами и галереей
- ✅ Управление компонентами главной страницы
- ✅ Система пользователей с правами доступа
- ✅ Цветовая палитра и настройки темы
- ✅ Резервное копирование базы данных
- ✅ Drag-and-drop интерфейс для компонентов

## 🔧 Технологии
- Frontend: Vue.js 3 + Vite + Tailwind CSS
- Backend: PHP 7.4+ + MySQL
- Drag-and-drop: vuedraggable@next
- HTTP клиент: Axios

## 📁 Структура проекта
```
architect-portfolio/
├── api/                    # PHP API endpoints
├── assets/                 # Собранные ресурсы
├── src/                    # Исходный код Vue.js
├── admin/                  # Админ-панель
├── components/             # Vue компоненты
├── stores/                 # Vuex stores
└── docs/                   # Документация
```

## 🚀 Быстрый старт
1. Настройте базу данных
2. Скопируйте файлы на сервер
3. Настройте права доступа
4. Откройте сайт в браузере
5. Войдите в админ-панель: /admin

## 📞 Поддержка
См. файл INSTALL.md для подробной инструкции по установке.
EOF

# Создаем архив
echo "📦 Создаем архив проекта..."
cd build
tar -czf ../architect-portfolio-v1.0.0.tar.gz .
cd ..

echo "✅ Сборка завершена!"
echo "📁 Файлы проекта находятся в папке: build/"
echo "📦 Архив проекта: architect-portfolio-v1.0.0.tar.gz"
echo ""
echo "🚀 Для установки:"
echo "1. Распакуйте архив на сервер"
echo "2. Настройте базу данных"
echo "3. Откройте сайт в браузере"
echo "4. Войдите в админ-панель: /admin"
