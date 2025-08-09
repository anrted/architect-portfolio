#!/bin/bash

# Скрипт для загрузки проекта Architect Portfolio на GitHub
# Включает создание нового репозитория и настройку GitHub Pages

echo "🚀 Начинаем загрузку проекта на GitHub..."

# Проверяем наличие git
if ! command -v git &> /dev/null; then
    echo "❌ Git не установлен. Пожалуйста, установите Git"
    exit 1
fi

# Проверяем наличие gh CLI (опционально)
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI найден"
    USE_GH_CLI=true
else
    echo "⚠️  GitHub CLI не найден. Будем использовать ручную настройку"
    USE_GH_CLI=false
fi

# Запрашиваем название репозитория
read -p "Введите название репозитория (например: architect-portfolio): " REPO_NAME

if [ -z "$REPO_NAME" ]; then
    REPO_NAME="architect-portfolio"
fi

# Запрашиваем описание репозитория
read -p "Введите описание репозитория (опционально): " REPO_DESCRIPTION

if [ -z "$REPO_DESCRIPTION" ]; then
    REPO_DESCRIPTION="Современный сайт-портфолио архитектора с админ-панелью"
fi

echo "📋 Настройки репозитория:"
echo "   Название: $REPO_NAME"
echo "   Описание: $REPO_DESCRIPTION"

# Создаем .gitignore для продакшена
echo "📋 Обновляем .gitignore для продакшена..."
cat > .gitignore << 'EOF'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

node_modules
# dist - включено для GitHub Pages
# dist-ssr
*.local

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# Build files (исключаем только для разработки)
# dist/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
EOF

# Инициализируем git репозиторий (если еще не инициализирован)
if [ ! -d ".git" ]; then
    echo "🔧 Инициализируем Git репозиторий..."
    git init
fi

# Добавляем все файлы
echo "📦 Добавляем файлы в Git..."
git add .

# Создаем первый коммит
echo "💾 Создаем первый коммит..."
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

# Создаем репозиторий на GitHub
if [ "$USE_GH_CLI" = true ]; then
    echo "🌐 Создаем репозиторий на GitHub через CLI..."
    gh repo create "$REPO_NAME" --description "$REPO_DESCRIPTION" --public --source=. --remote=origin --push
else
    echo "🌐 Создайте репозиторий на GitHub вручную:"
    echo "1. Перейдите на https://github.com/new"
    echo "2. Название репозитория: $REPO_NAME"
    echo "3. Описание: $REPO_DESCRIPTION"
    echo "4. Выберите 'Public'"
    echo "5. НЕ инициализируйте с README, .gitignore или лицензией"
    echo "6. Нажмите 'Create repository'"
    echo ""
    read -p "После создания репозитория нажмите Enter для продолжения..."
    
    # Добавляем remote origin
    echo "🔗 Добавляем remote origin..."
    git remote add origin "https://github.com/$(gh auth status --json 2>/dev/null | grep -o '"login":"[^"]*"' | cut -d'"' -f4 || echo "YOUR_USERNAME")/$REPO_NAME.git"
fi

# Проверяем, добавлен ли remote
if ! git remote get-url origin &> /dev/null; then
    echo "⚠️  Remote origin не найден. Добавьте его вручную:"
    echo "git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
    echo ""
    read -p "После добавления remote нажмите Enter для продолжения..."
fi

# Пушим в main ветку
echo "📤 Пушим в GitHub..."
git branch -M main
git push -u origin main

# Создаем ветку для GitHub Pages
echo "🌐 Создаем ветку для GitHub Pages..."
git checkout -b gh-pages

# Копируем содержимое dist в корень для GitHub Pages
echo "📋 Копируем файлы для GitHub Pages..."
if [ -d "dist" ]; then
    # Создаем временную папку
    mkdir -p temp_gh_pages
    
    # Копируем содержимое dist
    cp -r dist/* temp_gh_pages/
    
    # Копируем важные файлы
    cp README.md temp_gh_pages/ 2>/dev/null || true
    cp LICENSE temp_gh_pages/ 2>/dev/null || true
    
    # Удаляем старые файлы (кроме .git)
    find . -mindepth 1 -not -path './.git*' -not -path './temp_gh_pages*' -delete
    
    # Перемещаем файлы из временной папки
    mv temp_gh_pages/* .
    rmdir temp_gh_pages
    
    # Добавляем все файлы
    git add .
    
    # Коммитим изменения
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
    
    # Пушим gh-pages ветку
    git push -u origin gh-pages
    
    # Возвращаемся на main ветку
    git checkout main
else
    echo "⚠️  Папка dist не найдена. Создайте сборку: npm run build"
fi

# Создаем README для GitHub
echo "📋 Создаем README для GitHub..."
cat > README.md << 'EOF'
# 🏗️ Architect Portfolio

Современный сайт-портфолио архитектора с полнофункциональной админ-панелью для управления контентом.

## 🌐 Демо

**🌐 Живой сайт**: [https://YOUR_USERNAME.github.io/architect-portfolio](https://YOUR_USERNAME.github.io/architect-portfolio)

## 🎯 Основные возможности

### 🌐 Фронтенд (Vue.js 3)
- ✅ Современный адаптивный дизайн
- ✅ Динамическая загрузка компонентов
- ✅ Drag-and-drop управление компонентами
- ✅ Цветовая палитра и настройки темы
- ✅ Оптимизированная производительность

### 🔧 Админ-панель
- ✅ Управление проектами и галереей
- ✅ Управление компонентами главной страницы
- ✅ Система пользователей с правами доступа
- ✅ Редактирование контента (о себе, контакты, шапка)
- ✅ Резервное копирование базы данных
- ✅ Цветовая палитра и настройки темы

### 🎨 Дизайн и UX
- ✅ Современный минималистичный дизайн
- ✅ Адаптивная верстка для всех устройств
- ✅ Плавные анимации и переходы
- ✅ Интуитивный интерфейс
- ✅ Drag-and-drop функциональность

## 🚀 Быстрый старт

### Требования
- PHP 7.4+ или 8.0+
- MySQL 5.7+ или MariaDB 10.2+
- Node.js 16+ и npm
- Apache/Nginx

### Установка

1. **Клонируйте репозиторий**
```bash
git clone https://github.com/YOUR_USERNAME/architect-portfolio.git
cd architect-portfolio
```

2. **Установите зависимости**
```bash
npm install
```

3. **Настройте базу данных**
- Создайте новую базу данных
- Импортируйте структуру из `backups/backup_architect_portfolio_*.sql`
- Настройте подключение в `public/api/db.php`

4. **Запустите в режиме разработки**
```bash
npm run dev
```

5. **Соберите для продакшена**
```bash
npm run build
```

## 📁 Структура проекта

```
architect-portfolio/
├── src/                        # Исходный код Vue.js
│   ├── components/             # Vue компоненты
│   │   ├── admin/             # Компоненты админ-панели
│   │   └── ...                # Публичные компоненты
│   ├── stores/                # Vuex stores
│   ├── router.js              # Маршрутизация
│   └── main.js                # Точка входа
├── public/                    # Публичные файлы
│   ├── api/                   # PHP API endpoints
│   ├── backups/               # Резервные копии БД
│   └── index.html             # Главная страница
├── dist/                      # Собранные файлы (после build)
└── docs/                      # Документация
```

## 🔧 API Endpoints

### Админские API (требуют авторизации)
- `GET/POST /api/admin_components.php` - управление компонентами
- `GET/POST /api/admin_projects.php` - управление проектами
- `GET/POST /api/admin_users.php` - управление пользователями
- `GET/POST /api/admin_about.php` - редактирование главной страницы
- `GET/POST /api/admin_header.php` - редактирование шапки
- `GET/POST /api/admin_contacts.php` - редактирование контактов
- `GET/POST /api/admin_backup.php` - резервное копирование

### Публичные API
- `GET /api/components.php` - получение настроек компонентов
- `GET /api/projects.php` - получение проектов
- `GET /api/about.php` - получение контента главной страницы
- `GET /api/contacts.php` - получение контактов

## 🎨 Кастомизация

### Управление компонентами
1. Войдите в админ-панель: `/admin`
2. Перейдите в раздел "Компоненты"
3. Используйте drag-and-drop для изменения порядка
4. Включайте/выключайте компоненты переключателями

### Изменение дизайна
- **Цветовая палитра**: `/admin/colors`
- **Компоненты**: `/admin/components`
- **Контент**: `/admin/about`, `/admin/header`, `/admin/contacts`

## 🔒 Безопасность

### Рекомендации
1. Измените пароли по умолчанию
2. Настройте HTTPS
3. Регулярно обновляйте резервные копии
4. Мониторьте логи ошибок

### Права доступа
- `admin` - полные права на все разделы
- `editor` - ограниченные права в зависимости от настроек

## 📦 Сборка проекта

### Автоматическая сборка
```bash
# Linux/Mac
./build.sh

# Windows
build.bat
```

### Ручная сборка
```bash
# Установка зависимостей
npm install

# Сборка фронтенда
npm run build

# Копирование файлов
cp -r dist/* build/
cp -r public/* build/
```

## 🎯 Основные функции

### Управление контентом
- ✅ Редактирование главной страницы
- ✅ Управление проектами и галереей
- ✅ Редактирование контактов
- ✅ Управление шапкой сайта

### Система пользователей
- ✅ Регистрация и авторизация
- ✅ Роли и права доступа
- ✅ Управление пользователями

### Дизайн и UX
- ✅ Адаптивная верстка
- ✅ Современный дизайн
- ✅ Drag-and-drop интерфейс
- ✅ Цветовая палитра

### Технические возможности
- ✅ API-first архитектура
- ✅ Современный стек (Vue 3, PHP 8)
- ✅ Оптимизированная производительность
- ✅ Безопасность и валидация

## 📞 Поддержка

### Документация
- [Инструкция по установке](INSTALL.md)
- [Управление компонентами](COMPONENTS_MANAGEMENT.md)
- [Админ-панель](ADMIN_README.md)
- [Управление пользователями](USERS_MANAGEMENT.md)
- [Цветовая палитра](COLOR_PALETTE_FEATURE.md)
- [API настройки](SETTINGS_API_README.md)

### Решение проблем
1. Проверьте логи ошибок PHP
2. Убедитесь в правильности настроек БД
3. Проверьте права доступа к файлам
4. Обратитесь к документации

## 📄 Лицензия

Проект разработан для демонстрации возможностей современной веб-разработки.

## 🚀 Разработка

### Команды разработки
```bash
# Запуск в режиме разработки
npm run dev

# Сборка для продакшена
npm run build

# Предварительный просмотр сборки
npm run preview
```

### Структура разработки
- **Frontend**: Vue.js 3 + Vite + Tailwind CSS
- **Backend**: PHP 7.4+ + MySQL
- **State Management**: Vuex/Pinia
- **HTTP Client**: Axios
- **Drag-and-drop**: vuedraggable@next

---

**Architect Portfolio** - современное решение для создания профессиональных сайтов-портфолио архитекторов.

## ⭐ Поддержка проекта

Если проект вам понравился, поставьте звездочку ⭐ на GitHub!
EOF

# Обновляем README с правильным именем пользователя
if [ "$USE_GH_CLI" = true ]; then
    USERNAME=$(gh auth status --json 2>/dev/null | grep -o '"login":"[^"]*"' | cut -d'"' -f4 || echo "YOUR_USERNAME")
else
    USERNAME="YOUR_USERNAME"
fi

# Заменяем placeholder в README
sed -i "s/YOUR_USERNAME/$USERNAME/g" README.md

# Коммитим обновленный README
git add README.md
git commit -m "docs: обновлен README для GitHub"
git push

echo ""
echo "🎉 Проект успешно загружен на GitHub!"
echo ""
echo "📋 Следующие шаги:"
echo "1. Перейдите на https://github.com/$USERNAME/$REPO_NAME"
echo "2. В настройках репозитория включите GitHub Pages:"
echo "   - Settings > Pages"
echo "   - Source: Deploy from a branch"
echo "   - Branch: gh-pages"
echo "   - Folder: / (root)"
echo "3. Подождите несколько минут для развертывания"
echo "4. Ваш сайт будет доступен по адресу: https://$USERNAME.github.io/$REPO_NAME"
echo ""
echo "🔗 Полезные ссылки:"
echo "- Репозиторий: https://github.com/$USERNAME/$REPO_NAME"
echo "- GitHub Pages: https://$USERNAME.github.io/$REPO_NAME"
echo "- Issues: https://github.com/$USERNAME/$REPO_NAME/issues"
echo ""
echo "🚀 Удачной работы с Architect Portfolio!"
