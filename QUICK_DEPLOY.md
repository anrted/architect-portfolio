# 🚀 Быстрое развертывание на Ubuntu сервер 94.156.112.187

## 🎯 Быстрый способ (автоматический)

### 1. Запуск автоматического развертывания
```bash
# Сделайте скрипт исполняемым
chmod +x deploy-to-ubuntu.sh

# Запустите развертывание
./deploy-to-ubuntu.sh 94.156.112.187 root
```

### 2. Что делает скрипт
- ✅ Обновляет систему
- ✅ Устанавливает Apache, PHP, MySQL
- ✅ Клонирует репозиторий
- ✅ Создает базу данных
- ✅ Настраивает виртуальный хост
- ✅ Настраивает файрвол
- ✅ Создает скрипт обновления

## 🔧 Ручной способ

### 1. Подключение к серверу
```bash
ssh root@94.156.112.187
```

### 2. Установка пакетов
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y apache2 php8.1 php8.1-fpm php8.1-mysql php8.1-json php8.1-mbstring php8.1-xml php8.1-curl php8.1-zip mysql-server git unzip
sudo a2enmod rewrite
sudo systemctl restart apache2
```

### 3. Создание проекта
```bash
cd /var/www/html
sudo mkdir architect-portfolio
sudo chown $USER:$USER architect-portfolio
cd architect-portfolio
git clone https://github.com/anrted/architect-portfolio.git .
```

### 4. Настройка базы данных
```bash
sudo mysql -e "CREATE DATABASE architect_portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER 'architect_user'@'localhost' IDENTIFIED BY 'architect_password_2024';"
sudo mysql -e "GRANT ALL PRIVILEGES ON architect_portfolio.* TO 'architect_user'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
mysql -u architect_user -parchitect_password_2024 architect_portfolio < backups/backup_architect_portfolio_2025-08-09_13-18-45.sql
```

### 5. Настройка подключения к БД
```bash
cd api
sudo sed -i 's/localhost/localhost/g; s/your_database_name/architect_portfolio/g; s/your_username/architect_user/g; s/your_password/architect_password_2024/g' db.php
```

### 6. Настройка Apache
```bash
sudo nano /etc/apache2/sites-available/architect-portfolio.conf
```

Добавьте:
```apache
<VirtualHost *:80>
    ServerName 94.156.112.187
    DocumentRoot /var/www/html/architect-portfolio
    
    <Directory /var/www/html/architect-portfolio>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

```bash
sudo a2ensite architect-portfolio.conf
sudo systemctl reload apache2
```

### 7. Настройка прав доступа
```bash
sudo chown -R www-data:www-data /var/www/html/architect-portfolio
sudo chmod -R 755 /var/www/html/architect-portfolio
```

## 🎯 Результат

После развертывания ваш сайт будет доступен по адресу:

**🌐 http://94.156.112.187**

### Доступ к админ-панели:
- **URL**: http://94.156.112.187/admin
- **Логин**: `admin`
- **Пароль**: `admin123`

## 🔄 Обновление проекта

### Автоматическое обновление
```bash
ssh root@94.156.112.187
cd /var/www/html/architect-portfolio
./update.sh
```

### Ручное обновление
```bash
ssh root@94.156.112.187
cd /var/www/html/architect-portfolio
git pull origin main
sudo chown -R www-data:www-data /var/www/html/architect-portfolio
sudo chmod -R 755 /var/www/html/architect-portfolio
```

## 🆘 Решение проблем

### Ошибка 500
```bash
sudo tail -f /var/log/apache2/error.log
sudo chown -R www-data:www-data /var/www/html/architect-portfolio
```

### Ошибка подключения к БД
```bash
sudo systemctl status mysql
mysql -u architect_user -p -e "USE architect_portfolio; SHOW TABLES;"
```

### Ошибка 404
```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

## 🎉 Готово!

**Ваш проект Architect Portfolio успешно развернут на Ubuntu сервере!**

### Основные возможности:
- ✅ Современный адаптивный дизайн
- ✅ Полнофункциональная админ-панель
- ✅ Управление компонентами с drag-and-drop
- ✅ Система пользователей с правами доступа
- ✅ Резервное копирование базы данных
- ✅ Цветовая палитра и настройки темы

**🚀 Удачной работы с Architect Portfolio!**
