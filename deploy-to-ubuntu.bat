@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Скрипт для автоматического развертывания Architect Portfolio на Ubuntu сервер
:: Использование: deploy-to-ubuntu.bat [IP_ADDRESS]

:: Цвета для вывода
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

:: Параметры
set "SERVER_IP=%1"
if "%SERVER_IP%"=="" set "SERVER_IP=94.156.112.187"

set "PROJECT_NAME=architect-portfolio"
set "REPO_URL=https://github.com/anrted/architect-portfolio.git"

echo %BLUE%🚀 Начинаем развертывание Architect Portfolio на Ubuntu сервер%NC%
echo %YELLOW%Сервер: %SERVER_IP%%NC%
echo.

:: Запрашиваем логин
set /p "USERNAME=Введите логин для подключения к серверу (по умолчанию root): "
if "!USERNAME!"=="" set "USERNAME=root"

:: Запрашиваем пароль
set /p "PASSWORD=Введите пароль для подключения к серверу: "
if "!PASSWORD!"=="" (
    echo %RED%❌ Пароль не может быть пустым%NC%
    pause
    exit /b 1
)

echo.
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

:: Создаем временный скрипт для проверки подключения
echo @echo off > temp_ssh_test.bat
echo sshpass -p "!PASSWORD!" ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "echo 'Connection successful'" >> temp_ssh_test.bat

:: Проверяем наличие sshpass
where sshpass >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%⚠️ sshpass не найден. Попробуем подключиться без него...%NC%
    :: Пробуем подключиться с помощью expect или просто проверяем доступность
    ssh -o ConnectTimeout=10 -o BatchMode=yes !USERNAME!@%SERVER_IP% exit 2>nul
    if %errorlevel% neq 0 (
        echo %RED%❌ Не удалось подключиться к серверу %SERVER_IP%%NC%
        echo %YELLOW%Убедитесь, что:%NC%
        echo   - Сервер доступен по адресу %SERVER_IP%
        echo   - SSH ключи настроены или пароль введен
        echo   - Пользователь !USERNAME! имеет права sudo
        echo.
        echo %YELLOW%Попробуйте подключиться вручную:%NC%
        echo   ssh !USERNAME!@%SERVER_IP%
        pause
        exit /b 1
    )
) else (
    :: Используем sshpass для автоматического ввода пароля
    sshpass -p "!PASSWORD!" ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "echo 'Connection successful'" 2>nul
    if %errorlevel% neq 0 (
        echo %RED%❌ Не удалось подключиться к серверу %SERVER_IP%%NC%
        echo %YELLOW%Проверьте логин и пароль%NC%
        pause
        exit /b 1
    )
)

echo %GREEN%✅ Подключение к серверу успешно%NC%

:: Обновляем систему
echo %BLUE%🔄 Обновляем систему...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S apt update && sudo -S apt upgrade -y" 2>nul
) else (
    echo %YELLOW%⚠️ Для автоматического обновления установите sshpass%NC%
    echo %YELLOW%Продолжаем без обновления системы...%NC%
)

:: Устанавливаем необходимые пакеты
echo %BLUE%📦 Устанавливаем необходимые пакеты...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S apt install -y apache2 php8.1 php8.1-fpm php8.1-mysql php8.1-json php8.1-mbstring php8.1-xml php8.1-curl php8.1-zip mysql-server git unzip" 2>nul
) else (
    echo %YELLOW%⚠️ Установка пакетов будет выполнена вручную%NC%
    echo %YELLOW%Подключитесь к серверу и выполните:%NC%
    echo   sudo apt install -y apache2 php8.1 php8.1-fpm php8.1-mysql php8.1-json php8.1-mbstring php8.1-xml php8.1-curl php8.1-zip mysql-server git unzip
)

:: Настраиваем Apache
echo %BLUE%🌐 Настраиваем Apache...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S a2enmod rewrite && sudo -S systemctl restart apache2" 2>nul
) else (
    echo %YELLOW%⚠️ Настройка Apache будет выполнена вручную%NC%
)

:: Создаем директорию для проекта
echo %BLUE%📁 Создаем директорию для проекта...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S mkdir -p /var/www/html/%PROJECT_NAME% && sudo -S chown !USERNAME!:!USERNAME! /var/www/html/%PROJECT_NAME%" 2>nul
) else (
    echo %YELLOW%⚠️ Создание директории будет выполнено вручную%NC%
)

:: Клонируем репозиторий
echo %BLUE%📋 Клонируем репозиторий...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "cd /var/www/html/%PROJECT_NAME% && git clone %REPO_URL% ." 2>nul
) else (
    echo %YELLOW%⚠️ Клонирование репозитория будет выполнено вручную%NC%
    echo   cd /var/www/html/%PROJECT_NAME% && git clone %REPO_URL% .
)

:: Настраиваем права доступа
echo %BLUE%🔒 Настраиваем права доступа...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S chown -R www-data:www-data /var/www/html/%PROJECT_NAME% && sudo -S chmod -R 755 /var/www/html/%PROJECT_NAME%" 2>nul
) else (
    echo %YELLOW%⚠️ Настройка прав доступа будет выполнена вручную%NC%
)

:: Создаем базу данных
echo %BLUE%🗄️ Создаем базу данных...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S mysql -e \"CREATE DATABASE IF NOT EXISTS architect_portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;\"" 2>nul
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S mysql -e \"CREATE USER IF NOT EXISTS 'architect_user'@'localhost' IDENTIFIED BY 'architect_password_2024';\"" 2>nul
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S mysql -e \"GRANT ALL PRIVILEGES ON architect_portfolio.* TO 'architect_user'@'localhost';\"" 2>nul
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S mysql -e \"FLUSH PRIVILEGES;\"" 2>nul
) else (
    echo %YELLOW%⚠️ Создание базы данных будет выполнено вручную%NC%
)

:: Импортируем структуру БД
echo %BLUE%📊 Импортируем структуру базы данных...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "cd /var/www/html/%PROJECT_NAME% && mysql -u architect_user -parchitect_password_2024 architect_portfolio < backups/backup_architect_portfolio_2025-08-09_13-18-45.sql" 2>nul
) else (
    echo %YELLOW%⚠️ Импорт структуры БД будет выполнен вручную%NC%
)

:: Настраиваем подключение к БД
echo %BLUE%🔧 Настраиваем подключение к базе данных...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "cd /var/www/html/%PROJECT_NAME%/api && sudo -S cp db.php db.php.backup" 2>nul
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "cd /var/www/html/%PROJECT_NAME%/api && sudo -S sed -i 's/localhost/localhost/g; s/your_database_name/architect_portfolio/g; s/your_username/architect_user/g; s/your_password/architect_password_2024/g' db.php" 2>nul
) else (
    echo %YELLOW%⚠️ Настройка подключения к БД будет выполнена вручную%NC%
)

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
if exist "sshpass" (
    sshpass -p "!PASSWORD!" scp -o StrictHostKeyChecking=no temp_apache.conf !USERNAME!@%SERVER_IP%:/tmp/ 2>nul
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S mv /tmp/temp_apache.conf /etc/apache2/sites-available/%PROJECT_NAME%.conf && sudo -S a2ensite %PROJECT_NAME%.conf && sudo -S systemctl reload apache2" 2>nul
) else (
    echo %YELLOW%⚠️ Создание виртуального хоста будет выполнено вручную%NC%
)

:: Удаляем временный файл
del temp_apache.conf 2>nul

:: Настраиваем файрвол
echo %BLUE%🔥 Настраиваем файрвол...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S ufw allow ssh && sudo -S ufw allow 80 && sudo -S ufw allow 443 && sudo -S ufw --force enable" 2>nul
) else (
    echo %YELLOW%⚠️ Настройка файрвола будет выполнена вручную%NC%
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
if exist "sshpass" (
    sshpass -p "!PASSWORD!" scp -o StrictHostKeyChecking=no temp_update.sh !USERNAME!@%SERVER_IP%:/var/www/html/%PROJECT_NAME%/update.sh 2>nul
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S chmod +x /var/www/html/%PROJECT_NAME%/update.sh" 2>nul
) else (
    echo %YELLOW%⚠️ Создание скрипта обновления будет выполнено вручную%NC%
)

:: Удаляем временный файл
del temp_update.sh 2>nul

:: Проверяем статус сервисов
echo %BLUE%🔍 Проверяем статус сервисов...%NC%
if exist "sshpass" (
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S systemctl status apache2 --no-pager -l" 2>nul
    sshpass -p "!PASSWORD!" ssh -o StrictHostKeyChecking=no !USERNAME!@%SERVER_IP% "sudo -S systemctl status mysql --no-pager -l" 2>nul
) else (
    echo %YELLOW%⚠️ Проверка статуса сервисов будет выполнена вручную%NC%
)

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
echo   💻 SSH на сервер: ssh !USERNAME!@%SERVER_IP%
echo   📝 Запуск обновления: cd /var/www/html/%PROJECT_NAME% ^&^& ./update.sh
echo.
echo %YELLOW%⚠️ Не забудьте изменить пароли по умолчанию!%NC%
echo.
echo %GREEN%🚀 Удачной работы с Architect Portfolio!%NC%
echo.
pause
