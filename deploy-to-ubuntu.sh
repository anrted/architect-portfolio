#!/bin/bash

# Скрипт для автоматического развертывания Architect Portfolio на Ubuntu сервер
# Использование: ./deploy-to-ubuntu.sh [IP_ADDRESS] [USERNAME]

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Параметры
SERVER_IP=${1:-"94.156.112.187"}
USERNAME=${2:-"root"}
PROJECT_NAME="architect-portfolio"
REPO_URL="https://github.com/anrted/architect-portfolio.git"

echo -e "${BLUE}🚀 Начинаем развертывание Architect Portfolio на Ubuntu сервер${NC}"
echo -e "${YELLOW}Сервер: ${SERVER_IP}${NC}"
echo -e "${YELLOW}Пользователь: ${USERNAME}${NC}"
echo ""

# Проверяем подключение к серверу
echo -e "${BLUE}📡 Проверяем подключение к серверу...${NC}"
if ! ssh -o ConnectTimeout=10 -o BatchMode=yes ${USERNAME}@${SERVER_IP} exit 2>/dev/null; then
    echo -e "${RED}❌ Не удалось подключиться к серверу ${SERVER_IP}${NC}"
    echo -e "${YELLOW}Убедитесь, что:${NC}"
    echo -e "  - Сервер доступен по адресу ${SERVER_IP}"
    echo -e "  - SSH ключи настроены или пароль введен"
    echo -e "  - Пользователь ${USERNAME} имеет права sudo"
    exit 1
fi
echo -e "${GREEN}✅ Подключение к серверу успешно${NC}"

# Обновляем систему
echo -e "${BLUE}🔄 Обновляем систему...${NC}"
ssh ${USERNAME}@${SERVER_IP} "sudo apt update && sudo apt upgrade -y"
echo -e "${GREEN}✅ Система обновлена${NC}"

# Устанавливаем необходимые пакеты
echo -e "${BLUE}📦 Устанавливаем необходимые пакеты...${NC}"
ssh ${USERNAME}@${SERVER_IP} "sudo apt install -y apache2 php8.1 php8.1-fpm php8.1-mysql php8.1-json php8.1-mbstring php8.1-xml php8.1-curl php8.1-zip mysql-server git unzip"
echo -e "${GREEN}✅ Пакеты установлены${NC}"

# Настраиваем Apache
echo -e "${BLUE}🌐 Настраиваем Apache...${NC}"
ssh ${USERNAME}@${SERVER_IP} "sudo a2enmod rewrite && sudo systemctl restart apache2"
echo -e "${GREEN}✅ Apache настроен${NC}"

# Создаем директорию для проекта
echo -e "${BLUE}📁 Создаем директорию для проекта...${NC}"
ssh ${USERNAME}@${SERVER_IP} "sudo mkdir -p /var/www/html/${PROJECT_NAME} && sudo chown ${USERNAME}:${USERNAME} /var/www/html/${PROJECT_NAME}"
echo -e "${GREEN}✅ Директория создана${NC}"

# Клонируем репозиторий
echo -e "${BLUE}📋 Клонируем репозиторий...${NC}"
ssh ${USERNAME}@${SERVER_IP} "cd /var/www/html/${PROJECT_NAME} && git clone ${REPO_URL} ."
echo -e "${GREEN}✅ Репозиторий клонирован${NC}"

# Настраиваем права доступа
echo -e "${BLUE}🔒 Настраиваем права доступа...${NC}"
ssh ${USERNAME}@${SERVER_IP} "sudo chown -R www-data:www-data /var/www/html/${PROJECT_NAME} && sudo chmod -R 755 /var/www/html/${PROJECT_NAME}"
echo -e "${GREEN}✅ Права доступа настроены${NC}"

# Создаем базу данных
echo -e "${BLUE}🗄️ Создаем базу данных...${NC}"
ssh ${USERNAME}@${SERVER_IP} "sudo mysql -e \"CREATE DATABASE IF NOT EXISTS architect_portfolio CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;\""
ssh ${USERNAME}@${SERVER_IP} "sudo mysql -e \"CREATE USER IF NOT EXISTS 'architect_user'@'localhost' IDENTIFIED BY 'architect_password_2024';\""
ssh ${USERNAME}@${SERVER_IP} "sudo mysql -e \"GRANT ALL PRIVILEGES ON architect_portfolio.* TO 'architect_user'@'localhost';\""
ssh ${USERNAME}@${SERVER_IP} "sudo mysql -e \"FLUSH PRIVILEGES;\""
echo -e "${GREEN}✅ База данных создана${NC}"

# Импортируем структуру БД
echo -e "${BLUE}📊 Импортируем структуру базы данных...${NC}"
ssh ${USERNAME}@${SERVER_IP} "cd /var/www/html/${PROJECT_NAME} && mysql -u architect_user -parchitect_password_2024 architect_portfolio < backups/backup_architect_portfolio_2025-08-09_13-18-45.sql"
echo -e "${GREEN}✅ Структура БД импортирована${NC}"

# Настраиваем подключение к БД
echo -e "${BLUE}🔧 Настраиваем подключение к базе данных...${NC}"
ssh ${USERNAME}@${SERVER_IP} "cd /var/www/html/${PROJECT_NAME}/api && sudo cp db.php db.php.backup"
ssh ${USERNAME}@${SERVER_IP} "cd /var/www/html/${PROJECT_NAME}/api && sudo sed -i 's/localhost/localhost/g; s/your_database_name/architect_portfolio/g; s/your_username/architect_user/g; s/your_password/architect_password_2024/g' db.php"
echo -e "${GREEN}✅ Подключение к БД настроено${NC}"

# Создаем виртуальный хост Apache
echo -e "${BLUE}🌐 Создаем виртуальный хост Apache...${NC}"
cat > /tmp/architect-portfolio.conf << 'EOF'
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
EOF

scp /tmp/architect-portfolio.conf ${USERNAME}@${SERVER_IP}:/tmp/
ssh ${USERNAME}@${SERVER_IP} "sudo mv /tmp/architect-portfolio.conf /etc/apache2/sites-available/ && sudo a2ensite architect-portfolio.conf && sudo systemctl reload apache2"
echo -e "${GREEN}✅ Виртуальный хост создан${NC}"

# Настраиваем файрвол
echo -e "${BLUE}🔥 Настраиваем файрвол...${NC}"
ssh ${USERNAME}@${SERVER_IP} "sudo ufw allow ssh && sudo ufw allow 80 && sudo ufw allow 443 && sudo ufw --force enable"
echo -e "${GREEN}✅ Файрвол настроен${NC}"

# Создаем скрипт обновления
echo -e "${BLUE}📝 Создаем скрипт обновления...${NC}"
cat > /tmp/update.sh << 'EOF'
#!/bin/bash
cd /var/www/html/architect-portfolio
git pull origin main
sudo chown -R www-data:www-data /var/www/html/architect-portfolio
sudo chmod -R 755 /var/www/html/architect-portfolio
echo "Проект обновлен!"
EOF

scp /tmp/update.sh ${USERNAME}@${SERVER_IP}:/var/www/html/${PROJECT_NAME}/
ssh ${USERNAME}@${SERVER_IP} "sudo chmod +x /var/www/html/${PROJECT_NAME}/update.sh"
echo -e "${GREEN}✅ Скрипт обновления создан${NC}"

# Проверяем статус сервисов
echo -e "${BLUE}🔍 Проверяем статус сервисов...${NC}"
ssh ${USERNAME}@${SERVER_IP} "sudo systemctl status apache2 --no-pager -l"
ssh ${USERNAME}@${SERVER_IP} "sudo systemctl status mysql --no-pager -l"

# Очищаем временные файлы
rm -f /tmp/architect-portfolio.conf /tmp/update.sh

echo ""
echo -e "${GREEN}🎉 Развертывание завершено успешно!${NC}"
echo ""
echo -e "${BLUE}📋 Информация о развертывании:${NC}"
echo -e "  🌐 Сайт: http://${SERVER_IP}"
echo -e "  🔧 Админ-панель: http://${SERVER_IP}/admin"
echo -e "  👤 Логин: admin"
echo -e "  🔑 Пароль: admin123"
echo ""
echo -e "${BLUE}🗄️ База данных:${NC}"
echo -e "  📊 База данных: architect_portfolio"
echo -e "  👤 Пользователь: architect_user"
echo -e "  🔑 Пароль: architect_password_2024"
echo ""
echo -e "${BLUE}🔄 Обновление проекта:${NC}"
echo -e "  💻 SSH на сервер: ssh ${USERNAME}@${SERVER_IP}"
echo -e "  📝 Запуск обновления: cd /var/www/html/${PROJECT_NAME} && ./update.sh"
echo ""
echo -e "${YELLOW}⚠️  Не забудьте изменить пароли по умолчанию!${NC}"
echo ""
echo -e "${GREEN}🚀 Удачной работы с Architect Portfolio!${NC}"
