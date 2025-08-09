@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Скрипт для передачи продакшн версии Architect Portfolio на Ubuntu сервер
:: Использование: deploy-prod-to-ubuntu.bat [IP_ADDRESS] [USERNAME]

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

echo %BLUE%🚀 Начинаем передачу продакшн версии на Ubuntu сервер%NC%
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

:: Проверяем наличие папки dist
if not exist "dist" (
    echo %RED%❌ Папка dist не найдена!%NC%
    echo %YELLOW%Сначала соберите проект командой: npm run build%NC%
    pause
    exit /b 1
)

echo %GREEN%✅ Папка dist найдена%NC%

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

:: Создаем директорию для проекта на сервере
echo %BLUE%📁 Создаем директорию для проекта на сервере...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo mkdir -p /var/www/html/%PROJECT_NAME% && sudo chown %USERNAME%:%USERNAME% /var/www/html/%PROJECT_NAME%"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при создании директории%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Директория создана%NC%

:: Очищаем директорию на сервере
echo %BLUE%🧹 Очищаем директорию на сервере...%NC%
ssh %USERNAME%@%SERVER_IP% "rm -rf /var/www/html/%PROJECT_NAME%/*"
if %errorlevel% neq 0 (
    echo %YELLOW%⚠️ Предупреждение: Не удалось очистить директорию%NC%
) else (
    echo %GREEN%✅ Директория очищена%NC%
)

:: Копируем файлы из dist на сервер
echo %BLUE%📤 Копируем продакшн файлы на сервер...%NC%
scp -r dist/* %USERNAME%@%SERVER_IP%:/var/www/html/%PROJECT_NAME%/
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при копировании файлов%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Файлы скопированы%NC%

:: Настраиваем права доступа
echo %BLUE%🔒 Настраиваем права доступа...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo chown -R www-data:www-data /var/www/html/%PROJECT_NAME% && sudo chmod -R 755 /var/www/html/%PROJECT_NAME%"
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка при настройке прав доступа%NC%
    pause
    exit /b 1
)
echo %GREEN%✅ Права доступа настроены%NC%

:: Создаем виртуальный хост Apache (если не существует)
echo %BLUE%🌐 Проверяем виртуальный хост Apache...%NC%
ssh %USERNAME%@%SERVER_IP% "test -f /etc/apache2/sites-available/%PROJECT_NAME%.conf"
if %errorlevel% neq 0 (
    echo %BLUE%📝 Создаем виртуальный хост Apache...%NC%
    
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
) else (
    echo %GREEN%✅ Виртуальный хост уже существует%NC%
)

:: Проверяем статус Apache
echo %BLUE%🔍 Проверяем статус Apache...%NC%
ssh %USERNAME%@%SERVER_IP% "sudo systemctl status apache2 --no-pager -l"
if %errorlevel% neq 0 (
    echo %YELLOW%⚠️ Предупреждение: Apache может быть не запущен%NC%
) else (
    echo %GREEN%✅ Apache работает корректно%NC%
)

:: Создаем .htaccess файл для SPA
echo %BLUE%📝 Создаем .htaccess файл для SPA...%NC%
echo RewriteEngine On > temp_htaccess
echo RewriteCond %%{REQUEST_FILENAME} !-f >> temp_htaccess
echo RewriteCond %%{REQUEST_FILENAME} !-d >> temp_htaccess
echo RewriteRule ^(.*)$ /index.html [QSA,L] >> temp_htaccess

scp temp_htaccess %USERNAME%@%SERVER_IP%:/var/www/html/%PROJECT_NAME%/.htaccess
if %errorlevel% neq 0 (
    echo %YELLOW%⚠️ Предупреждение: Не удалось создать .htaccess%NC%
) else (
    echo %GREEN%✅ .htaccess создан%NC%
)

del temp_htaccess

:: Проверяем доступность сайта
echo %BLUE%🌐 Проверяем доступность сайта...%NC%
timeout /t 3 /nobreak >nul
curl -s -o nul -w "%%{http_code}" http://%SERVER_IP% | findstr "200" >nul
if %errorlevel% equ 0 (
    echo %GREEN%✅ Сайт доступен по адресу http://%SERVER_IP%%NC%
) else (
    echo %YELLOW%⚠️ Сайт может быть недоступен. Проверьте вручную: http://%SERVER_IP%%NC%
)

echo.
echo %GREEN%🎉 Продакшн версия успешно развернута!%NC%
echo.
echo %BLUE%📋 Информация о развертывании:%NC%
echo   🌐 Сайт: http://%SERVER_IP%
echo   🔧 Админ-панель: http://%SERVER_IP%/admin
echo   👤 Логин: admin
echo   🔑 Пароль: admin123
echo.
echo %BLUE%📁 Файлы развернуты в:%NC%
echo   📂 /var/www/html/%PROJECT_NAME%/
echo.
echo %BLUE%🔄 Для обновления:%NC%
echo   💻 SSH на сервер: ssh %USERNAME%@%SERVER_IP%
echo   📝 Перезапустите скрипт: deploy-prod-to-ubuntu.bat
echo.
echo %GREEN%🚀 Удачной работы с Architect Portfolio!%NC%
echo.
pause
