# 🏗️ Инструкция по сборке проекта Architect Portfolio

## 🎯 Обзор

Этот документ содержит подробные инструкции по сборке полного проекта Architect Portfolio, включающего фронтенд (Vue.js) и backend (PHP).

## 📋 Требования

### Системные требования
- **Node.js** 16+ и npm
- **PHP** 7.4+ или 8.0+
- **MySQL** 5.7+ или MariaDB 10.2+
- **Apache/Nginx** веб-сервер

### Расширения PHP
- pdo_mysql
- json
- mbstring
- fileinfo

## 🚀 Способы сборки

### 1. Автоматическая сборка (рекомендуется)

#### Для Linux/Mac:
```bash
# Сделайте скрипт исполняемым
chmod +x build.sh

# Запустите сборку
./build.sh
```

#### Для Windows:
```bash
# Запустите batch файл
build.bat
```

### 2. Ручная сборка

#### Шаг 1: Установка зависимостей
```bash
# Установите зависимости Node.js
npm install
```

#### Шаг 2: Сборка фронтенда
```bash
# Соберите Vue.js приложение
npm run build
```

#### Шаг 3: Создание папки сборки
```bash
# Создайте папку для сборки
mkdir -p build

# Скопируйте собранный фронтенд
cp -r dist/* build/

# Скопируйте PHP файлы
cp -r public/* build/
```

#### Шаг 4: Копирование документации
```bash
# Скопируйте документацию
cp README.md build/
cp COMPONENTS_MANAGEMENT.md build/
cp ADMIN_README.md build/
cp USERS_MANAGEMENT.md build/
cp COLOR_PALETTE_FEATURE.md build/
cp SETTINGS_API_README.md build/
```

## 📁 Структура собранного проекта

После сборки в папке `build/` будет следующая структура:

```
build/
├── index.html                 # Главная страница
├── assets/                    # Собранные ресурсы (CSS, JS, изображения)
├── api/                       # PHP API endpoints
│   ├── admin_components.php   # Управление компонентами
│   ├── admin_projects.php     # Управление проектами
│   ├── admin_users.php        # Управление пользователями
│   ├── admin_about.php        # Редактирование главной страницы
│   ├── admin_header.php       # Редактирование шапки
│   ├── admin_contacts.php     # Редактирование контактов
│   ├── admin_backup.php       # Резервное копирование
│   ├── components.php         # Публичный API компонентов
│   ├── projects.php           # Публичный API проектов
│   ├── about.php              # Публичный API о себе
│   ├── contacts.php           # Публичный API контактов
│   ├── settings.php           # API настроек
│   ├── auth.php               # API авторизации
│   └── db.php                 # Подключение к БД
├── backups/                   # Резервные копии БД
├── .htaccess                  # Конфигурация Apache
├── INSTALL.md                 # Инструкция по установке
├── VERSION.md                 # Информация о версии
└── README.md                  # Общая документация
```

## 🔧 Настройка после сборки

### 1. Настройка базы данных

#### Создание базы данных:
```sql
CREATE DATABASE architect_portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### Импорт структуры:
```bash
# Импортируйте структуру из резервной копии
mysql -u username -p architect_portfolio < backups/backup_architect_portfolio_*.sql
```

#### Настройка подключения:
Отредактируйте файл `build/api/db.php`:
```php
<?php
$host = 'localhost';
$dbname = 'your_database_name';
$username = 'your_username';
$password = 'your_password';
?>
```

### 2. Настройка веб-сервера

#### Apache:
1. Скопируйте содержимое папки `build/` в корневую папку сайта
2. Убедитесь, что mod_rewrite включен
3. Настройте права доступа:
```bash
chmod 755 -R /path/to/your/site
chmod 644 /path/to/your/site/.htaccess
```

#### Nginx:
Добавьте в конфигурацию:
```nginx
location / {
    try_files $uri $uri/ /index.html;
}

location /api {
    try_files $uri $uri/ =404;
}
```

### 3. Настройка PHP

Убедитесь, что в `php.ini` включены расширения:
```ini
extension=pdo_mysql
extension=json
extension=mbstring
extension=fileinfo
```

## 🎯 Первоначальная настройка

### 1. Доступ к сайту
- Откройте сайт в браузере
- Убедитесь, что главная страница загружается

### 2. Доступ к админ-панели
- Перейдите по адресу: `http://your-domain.com/admin`
- Войдите с данными по умолчанию:
  - **Логин**: `admin`
  - **Пароль**: `admin123`

### 3. Первоначальная настройка
1. **Измените пароль администратора**
2. **Настройте компоненты главной страницы** (`/admin/components`)
3. **Настройте цветовую палитру** (`/admin/colors`)
4. **Добавьте контент** (`/admin/about`, `/admin/header`, `/admin/contacts`)

## 🔒 Безопасность

### Рекомендации по безопасности:
1. **Измените пароли по умолчанию**
2. **Настройте HTTPS**
3. **Регулярно обновляйте резервные копии**
4. **Мониторьте логи ошибок**
5. **Настройте права доступа к файлам**

### Права доступа:
```bash
# Папки
chmod 755 /path/to/your/site
chmod 755 /path/to/your/site/api
chmod 755 /path/to/your/site/backups

# Файлы
chmod 644 /path/to/your/site/*.php
chmod 644 /path/to/your/site/.htaccess
```

## 🐛 Решение проблем

### Частые проблемы:

#### 1. Ошибка подключения к БД
- Проверьте настройки в `api/db.php`
- Убедитесь, что база данных создана
- Проверьте права пользователя БД

#### 2. Ошибка 404 для API
- Убедитесь, что mod_rewrite включен
- Проверьте конфигурацию .htaccess
- Проверьте права доступа к файлам

#### 3. Ошибки JavaScript
- Проверьте консоль браузера
- Убедитесь, что все файлы загружаются
- Проверьте пути к API

#### 4. Проблемы с авторизацией
- Проверьте настройки сессий PHP
- Убедитесь, что cookies работают
- Проверьте логи ошибок

## 📞 Поддержка

### Документация:
- [Общий README](README.md)
- [Инструкция по установке](INSTALL.md)
- [Управление компонентами](COMPONENTS_MANAGEMENT.md)
- [Админ-панель](ADMIN_README.md)
- [Управление пользователями](USERS_MANAGEMENT.md)

### Логи ошибок:
- **PHP ошибки**: `/var/log/apache2/error.log` или `/var/log/nginx/error.log`
- **JavaScript ошибки**: Консоль браузера (F12)

## 🎉 Готово!

После выполнения всех шагов у вас будет полностью функциональный сайт-портфолио архитектора с:

- ✅ Современным адаптивным дизайном
- ✅ Полнофункциональной админ-панелью
- ✅ Управлением компонентами с drag-and-drop
- ✅ Системой пользователей с правами доступа
- ✅ Резервным копированием
- ✅ Цветовой палитрой и настройками темы

**Удачной работы с Architect Portfolio!** 🚀
