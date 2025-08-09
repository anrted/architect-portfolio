@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Скрипт для автоматического развертывания Architect Portfolio на Ubuntu сервер
:: Использование: deploy-to-ubuntu.bat [IP_ADDRESS] [USERNAME]

:: Цвета для вывода
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

:: Параметры
set "SERVER_IP=%1"
if "%SERVER_IP%"=="" set "SERVER_IP=94.156.112.187"

set "USERNAME=%2"
if "%USERNAME%"=="" set "USERNAME=root"

set "PROJECT_NAME=architect-portfolio"
set "REPO_URL=https://github.com/anrted/architect-portfolio.git"

echo %BLUE%🚀 Начинаем развертывание Architect Portfolio на Ubuntu сервер%NC%
echo %YELLOW%Сервер: %SERVER_IP%%NC%
echo %YELLOW%Пользователь: %USERNAME%%NC%
echo.

:: Проверяем наличие необходимых инструментов
echo %BLUE%🔍 Проверяем наличие необходимых инструментов...%NC%

:: Проверяем наличие SSH
where ssh >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%❌ SSH не найден. Установите OpenSSH или Git Bash%NC%
    echo %YELLOW%Скачайте Git для Windows: https://git-scm.com/download/win%NC%
    pause
    exit /b 1
)

:: Проверяем наличие Git
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%❌ Git не найден. Установите Git для Windows%NC%
    echo %YELLOW%Скачайте Git для Windows: https://git-scm.com/download/win%NC%
    pause
    exit /b 1
)

echo %GREEN%✅ Необходимые инструменты найдены%NC%

:: Проверяем подключение к серверу
echo %BLUE%📡 Проверяем подключение к серверу...%NC%
ssh -o ConnectTimeout=10 -o BatchMode=yes %USERNAME%@%SERVER_IP% exit 2>nul
if %errorlevel% neq 0 (
    echo %RED%❌ Не удалось подключиться к серверу %SERVER_IP%%NC%
    echo %YELLOW%Убедитесь, что:%NC%
    echo   - Сервер доступен по адресу %SERVER_IP%
    echo   - SSH ключи настроены или пароль введен
    echo   - Пользователь %USERNAME% имеет права sudo
    echo.
    echo %YELLOW%Попробуйте подключиться вручную:%NC%
    echo   ssh %USERNAME%@%SERVER_IP%
    pause
    exit /b 1
)
echo %GREEN%✅ Подключение к серверу успешно%NC%

:: Обновляем систему
echo %BLUE%🔄 Обновляем систему...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo apt update && sudo apt upgrade -y"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при обновлении системы%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Система обновлена%NC%

:: Устанавливаем необходимые пакеты
echo %BLUE%📦 Устанавливаем необходимые пакеты...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo apt install -y apache2 php8.1 php8.1-fpm php8.1-mysql php8.1-json php8.1-mbstring php8.1-xml php8.1-curl php8.1-zip mysql-server git unzip"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при установке пакетов%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Пакеты установлены%NC%

:: Настраиваем Apache
echo %BLUE%🌐 Настраиваем Apache...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo a2enmod rewrite && sudo systemctl restart apache2"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при настройке Apache%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Apache настроен%NC%

:: Создаем директорию для проекта
echo %BLUE%📁 Создаем директорию для проекта...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo mkdir -p /var/www/html/%PROJECT_NAME% && sudo chown %USERNAME%:%USERNAME% /var/www/html/%PROJECT_NAME%"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при создании директории%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Директория создана%NC%

:: Клонируем репозиторий
echo %BLUE%📋 Клонируем репозиторий...%NC%
ssh %USERNAME%@%SERVER_IP% "cd /var/www/html/%PROJECT_NAME% && git clone %REPO_URL% ."
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при клонировании репозитория%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Репозиторий клонирован%NC%

:: Настраиваем права доступа
echo %BLUE%🔒 Настраиваем права доступа...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo chown -R www-data:www-data /var/www/html/%PROJECT_NAME% && sudo chmod -R 755 /var/www/html/%PROJECT_NAME%"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при настройке прав доступа%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Права доступа настроены%NC%

:: Создаем базу данных
echo %BLUE%🗄️ Создаем базу данных...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo mysql -e \"CREATE DATABASE IF NOT EXISTS architect_portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;\""
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при создании базы данных%NC%
    pause
    exit /b 1
)

ssh %USERNAME%@%SERVER_IP% "sudo mysql -e \"CREATE USER IF NOT EXISTS 'architect_user'@'localhost' IDENTIFIED BY 'architect_password_2024';\""
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при создании пользователя БД%NC%
    pause
    exit /b 1
)

ssh %USERNAME%@%SERVER_IP% "sudo mysql -e \"GRANT ALL PRIVILEGES ON architect_portfolio.* TO 'architect_user'@'localhost';\""
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при назначении прав%NC%
    pause
    exit /b 1
)

ssh %USERNAME%@%SERVER_IP% "sudo mysql -e \"FLUSH PRIVILEGES;\""
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при обновлении привилегий%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ База данных создана%NC%

:: Импортируем структуру БД
echo %BLUE%📊 Импортируем структуру базы данных...%NC%
ssh %USERNAME%@%SERVER_IP% "cd /var/www/html/%PROJECT_NAME% && mysql -u architect_user -parchitect_password_2024 architect_portfolio < backups/backup_architect_portfolio_2025-08-09_13-18-45.sql"
if %errorlevel% neq 0 (
    echo %YELLOW%⚠️ Предупреждение: Не удалось импортировать структуру БД%NC%
    echo %YELLOW%Это может быть нормально, если файл резервной копии не существует%NC%
) else (
    echo %GREEN%✅ Структура БД импортирована%NC%
)

:: Настраиваем подключение к БД
echo %BLUE%🔧 Настраиваем подключение к базе данных...%NC%
ssh %USERNAME%@%SERVER_IP% "cd /var/www/html/%PROJECT_NAME%/api && sudo cp db.php db.php.backup"
ssh %USERNAME%@%SERVER_IP% "cd /var/www/html/%PROJECT_NAME%/api && sudo sed -i 's/localhost/localhost/g; s/your_database_name/architect_portfolio/g; s/your_username/architect_user/g; s/your_password/architect_password_2024/g' db.php"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при настройке подключения к БД%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Подключение к БД настроено%NC%

:: Создаем виртуальный хост Apache
echo %BLUE%🌐 Создаем виртуальный хост Apache...%NC%

:: Создаем временный файл конфигурации
echo ^<VirtualHost *:80^> > temp_apache.conf
echo     ServerName %SERVER_IP% >> temp_apache.conf
echo     ServerAlias www.%SERVER_IP% >> temp_apache.conf
echo     DocumentRoot /var/www/html/%PROJECT_NAME% >> temp_apache.conf
echo. >> temp_apache.conf
echo     ^<Directory /var/www/html/%PROJECT_NAME%^> >> temp_apache.conf
echo         AllowOverride All >> temp_apache.conf
echo         Require all granted >> temp_apache.conf
echo     ^</Directory^> >> temp_apache.conf
echo. >> temp_apache.conf
echo     ErrorLog ${APACHE_LOG_DIR}/%PROJECT_NAME%_error.log >> temp_apache.conf
echo     CustomLog ${APACHE_LOG_DIR}/%PROJECT_NAME%_access.log combined >> temp_apache.conf
echo ^</VirtualHost^> >> temp_apache.conf

:: Копируем конфигурацию на сервер
scp temp_apache.conf %USERNAME%@%SERVER_IP%:/tmp/
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при копировании конфигурации Apache%NC%
    del temp_apache.conf
    pause
    exit /b 1
)

:: Активируем сайт
ssh %USERNAME%@%SERVER_IP% "sudo mv /tmp/temp_apache.conf /etc/apache2/sites-available/%PROJECT_NAME%.conf && sudo a2ensite %PROJECT_NAME%.conf && sudo systemctl reload apache2"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при активации виртуального хоста%NC%
    del temp_apache.conf
    pause
    exit /b 1
)

:: Удаляем временный файл
del temp_apache.conf
echo %GREEN%✅ Виртуальный хост создан%NC%

:: Настраиваем файрвол
echo %BLUE%🔥 Настраиваем файрвол...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo ufw allow ssh && sudo ufw allow 80 && sudo ufw allow 443 && sudo ufw --force enable"
if %errorlevel% neq 0 (
    echo %YELLOW%⚠️ Предупреждение: Не удалось настроить файрвол%NC%
) else (
    echo %GREEN%✅ Файрвол настроен%NC%
)

:: Создаем скрипт обновления
echo %BLUE%📝 Создаем скрипт обновления...%NC%

:: Создаем временный файл скрипта обновления
echo #!/bin/bash > temp_update.sh
echo cd /var/www/html/%PROJECT_NAME% >> temp_update.sh
echo git pull origin main >> temp_update.sh
echo sudo chown -R www-data:www-data /var/www/html/%PROJECT_NAME% >> temp_update.sh
echo sudo chmod -R 755 /var/www/html/%PROJECT_NAME% >> temp_update.sh
echo echo "Проект обновлен!" >> temp_update.sh

:: Копируем скрипт на сервер
scp temp_update.sh %USERNAME%@%SERVER_IP%:/var/www/html/%PROJECT_NAME%/update.sh
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при копировании скрипта обновления%NC%
    del temp_update.sh
    pause
    exit /b 1
)

:: Настраиваем права на скрипт
ssh %USERNAME%@%SERVER_IP% "sudo chmod +x /var/www/html/%PROJECT_NAME%/update.sh"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при настройке прав на скрипт%NC%
    del temp_update.sh
    pause
    exit /b 1
)

:: Удаляем временный файл
del temp_update.sh
echo %GREEN%✅ Скрипт обновления создан%NC%

:: Проверяем статус сервисов
echo %BLUE%🔍 Проверяем статус сервисов...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo systemctl status apache2 --no-pager -l"
ssh %USERNAME%@%SERVER_IP% "sudo systemctl status mysql --no-pager -l"

echo.
echo %GREEN%🎉 Развертывание завершено успешно!%NC%
echo.
echo %BLUE%📋 Информация о развертывании:%NC%
echo   🌐 Сайт: http://%SERVER_IP%
echo   🔧 Админ-панель: http://%SERVER_IP%/admin
echo   👤 Логин: admin
echo   🔑 Пароль: admin123
echo.
echo %BLUE%🗄️ База данных:%NC%
echo   📊 База данных: architect_portfolio
echo   👤 Пользователь: architect_user
echo   🔑 Пароль: architect_password_2024
echo.
echo %BLUE%🔄 Обновление проекта:%NC%
echo   💻 SSH на сервер: ssh %USERNAME%@%SERVER_IP%
echo   📝 Запуск обновления: cd /var/www/html/%PROJECT_NAME% ^&^& ./update.sh
echo.
echo %YELLOW%⚠️ Не забудьте изменить пароли по умолчанию!%NC%
echo.
echo %GREEN%🚀 Удачной работы с Architect Portfolio!%NC%
echo.
pause
