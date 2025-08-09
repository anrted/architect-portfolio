# 🚀 Развертывание на Ubuntu сервер 94.156.112.187

## 🎯 Обзор

Этот документ содержит подробные инструкции по развертыванию проекта Architect Portfolio на Ubuntu сервер.

## 📋 Требования к серверу

### Системные требования
- **Ubuntu** 18.04+ или 20.04+
- **PHP** 7.4+ или 8.0+
- **MySQL** 5.7+ или MariaDB 10.2+
- **Apache** или **Nginx**
- **Git** (для загрузки кода)

### Расширения PHP
```bash
sudo apt update
sudo apt install php8.1 php8.1-fpm php8.1-mysql php8.1-json php8.1-mbstring php8.1-xml php8.1-curl php8.1-zip
```

## 🔧 Подготовка сервера

### 1. Подключение к серверу
```bash
ssh root@94.156.112.187
# или
ssh username@94.156.112.187
```

### 2. Обновление системы
```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Установка необходимых пакетов
```bash
# Установка Apache, PHP, MySQL
sudo apt install apache2 php8.1 php8.1-fpm php8.1-mysql php8.1-json php8.1-mbstring php8.1-xml php8.1-curl php8.1-zip mysql-server git unzip -y

# Установка mod_rewrite для Apache
sudo a2enmod rewrite
sudo systemctl restart apache2
```

### 4. Настройка MySQL
```bash
# Безопасная установка MySQL
sudo mysql_secure_installation

# Создание базы данных
sudo mysql -u root -p
```

```sql
CREATE DATABASE architect_portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'architect_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON architect_portfolio.* TO 'architect_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## 📁 Загрузка проекта

### 1. Создание директории для проекта
```bash
# Переходим в директорию веб-сервера
cd /var/www/html

# Создаем директорию для проекта
sudo mkdir architect-portfolio
sudo chown $USER:$USER architect-portfolio
cd architect-portfolio
```

### 2. Клонирование репозитория
```bash
# Клонируем репозиторий
git clone https://github.com/anrted/architect-portfolio.git .

# Или если репозиторий приватный
git clone https://username:token@github.com/anrted/architect-portfolio.git .
```

### 3. Настройка прав доступа
```bash
# Устанавливаем правильные права
sudo chown -R www-data:www-data /var/www/html/architect-portfolio
sudo chmod -R 755 /var/www/html/architect-portfolio
sudo chmod -R 644 /var/www/html/architect-portfolio/*.php
```

## 🗄️ Настройка базы данных

### 1. Импорт структуры БД
```bash
# Импортируем структуру из резервной копии
mysql -u architect_user -p architect_portfolio < backups/backup_architect_portfolio_2025-08-09_13-18-45.sql
```

### 2. Настройка подключения к БД
```bash
# Редактируем файл подключения к БД
sudo nano api/db.php
```

```php
<?php
$host = 'localhost';
$dbname = 'architect_portfolio';
$username = 'architect_user';
$password = 'your_secure_password';
?>
```

## 🌐 Настройка веб-сервера

### Вариант 1: Apache

#### 1. Создание виртуального хоста
```bash
sudo nano /etc/apache2/sites-available/architect-portfolio.conf
```

```apache
<VirtualHost *:80>
    ServerName 94.156.112.187
    ServerAlias www.94.156.112.187
    DocumentRoot /var/www/html/architect-portfolio
    
    <Directory /var/www/html/architect-portfolio>
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/architect-portfolio_error.log
    CustomLog ${APACHE_LOG_DIR}/architect-portfolio_access.log combined
</VirtualHost>
```

#### 2. Активация сайта
```bash
sudo a2ensite architect-portfolio.conf
sudo systemctl reload apache2
```

### Вариант 2: Nginx

#### 1. Установка Nginx
```bash
sudo apt install nginx -y
```

#### 2. Создание конфигурации
```bash
sudo nano /etc/nginx/sites-available/architect-portfolio
```

```nginx
server {
    listen 80;
    server_name 94.156.112.187;
    root /var/www/html/architect-portfolio;
    index index.html index.php;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

#### 3. Активация сайта
```bash
sudo ln -s /etc/nginx/sites-available/architect-portfolio /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 🔒 Настройка безопасности

### 1. Настройка файрвола
```bash
# Установка UFW
sudo apt install ufw -y

# Настройка правил
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

### 2. Настройка SSL (опционально)
```bash
# Установка Certbot
sudo apt install certbot python3-certbot-apache -y

# Получение SSL сертификата
sudo certbot --apache -d your-domain.com
```

### 3. Настройка прав доступа
```bash
# Ограничение доступа к конфигурационным файлам
sudo chmod 600 /var/www/html/architect-portfolio/api/db.php
sudo chown www-data:www-data /var/www/html/architect-portfolio/api/db.php
```

## 🎯 Тестирование

### 1. Проверка веб-сервера
```bash
# Проверка статуса Apache
sudo systemctl status apache2

# Проверка статуса Nginx
sudo systemctl status nginx
```

### 2. Проверка PHP
```bash
# Создание тестового файла
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/architect-portfolio/test.php

# Проверка в браузере: http://94.156.112.187/test.php
```

### 3. Проверка базы данных
```bash
# Тест подключения к БД
php -r "
\$pdo = new PDO('mysql:host=localhost;dbname=architect_portfolio', 'architect_user', 'your_secure_password');
echo 'Подключение к БД успешно!';
"
```

## 🚀 Запуск проекта

### 1. Проверка доступности
- Откройте в браузере: `http://94.156.112.187`
- Должна загрузиться главная страница

### 2. Проверка админ-панели
- Перейдите по адресу: `http://94.156.112.187/admin`
- Войдите с данными по умолчанию:
  - **Логин**: `admin`
  - **Пароль**: `admin123`

### 3. Настройка компонентов
1. Войдите в админ-панель
2. Перейдите в раздел "Компоненты"
3. Настройте видимость и порядок компонентов
4. Сохраните изменения

## 🔄 Обновление проекта

### 1. Автоматическое обновление
```bash
# Создание скрипта обновления
sudo nano /var/www/html/architect-portfolio/update.sh
```

```bash
#!/bin/bash
cd /var/www/html/architect-portfolio
git pull origin main
sudo chown -R www-data:www-data /var/www/html/architect-portfolio
sudo chmod -R 755 /var/www/html/architect-portfolio
echo "Проект обновлен!"
```

### 2. Настройка прав на скрипт
```bash
sudo chmod +x /var/www/html/architect-portfolio/update.sh
```

## 📊 Мониторинг

### 1. Логи Apache
```bash
# Просмотр логов ошибок
sudo tail -f /var/log/apache2/architect-portfolio_error.log

# Просмотр логов доступа
sudo tail -f /var/log/apache2/architect-portfolio_access.log
```

### 2. Логи Nginx
```bash
# Просмотр логов ошибок
sudo tail -f /var/log/nginx/error.log

# Просмотр логов доступа
sudo tail -f /var/log/nginx/access.log
```

## 🆘 Решение проблем

### 1. Ошибка 500
```bash
# Проверка логов PHP
sudo tail -f /var/log/apache2/error.log

# Проверка прав доступа
sudo chown -R www-data:www-data /var/www/html/architect-portfolio
```

### 2. Ошибка подключения к БД
```bash
# Проверка статуса MySQL
sudo systemctl status mysql

# Проверка подключения
mysql -u architect_user -p -e "USE architect_portfolio; SHOW TABLES;"
```

### 3. Ошибка 404
```bash
# Проверка конфигурации Apache
sudo apache2ctl configtest

# Проверка mod_rewrite
sudo a2enmod rewrite
sudo systemctl restart apache2
```

## 🎉 Готово!

После выполнения всех шагов ваш проект Architect Portfolio будет доступен по адресу:

**🌐 http://94.156.112.187**

### Основные возможности:
- ✅ Современный адаптивный дизайн
- ✅ Полнофункциональная админ-панель
- ✅ Управление компонентами с drag-and-drop
- ✅ Система пользователей с правами доступа
- ✅ Резервное копирование базы данных
- ✅ Цветовая палитра и настройки темы

**Удачной работы с Architect Portfolio!** 🚀
