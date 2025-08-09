# 🚀 Загрузка проекта на GitHub

## 🎯 Быстрая загрузка

### Для Windows:
```bash
# Запустите batch файл
deploy-to-github.bat
```

### Для Linux/Mac:
```bash
# Сделайте скрипт исполняемым
chmod +x deploy-to-github.sh

# Запустите скрипт
./deploy-to-github.sh
```

## 📋 Ручная загрузка

### 1. Подготовка проекта

```bash
# Убедитесь, что проект собран
npm run build

# Проверьте, что папка dist существует
ls dist/
```

### 2. Инициализация Git

```bash
# Инициализируем Git (если еще не инициализирован)
git init

# Добавляем все файлы
git add .

# Создаем первый коммит
git commit -m "Initial commit: Architect Portfolio"
```

### 3. Создание репозитория на GitHub

1. Перейдите на https://github.com/new
2. Введите название репозитория (например: `architect-portfolio`)
3. Добавьте описание: "Современный сайт-портфолио архитектора с админ-панелью"
4. Выберите "Public"
5. **НЕ** инициализируйте с README, .gitignore или лицензией
6. Нажмите "Create repository"

### 4. Загрузка на GitHub

```bash
# Добавляем remote origin
git remote add origin https://github.com/YOUR_USERNAME/architect-portfolio.git

# Пушим в main ветку
git branch -M main
git push -u origin main
```

### 5. Настройка GitHub Pages

```bash
# Создаем ветку для GitHub Pages
git checkout -b gh-pages

# Копируем содержимое dist в корень
cp -r dist/* .

# Добавляем и коммитим
git add .
git commit -m "Deploy to GitHub Pages"

# Пушим gh-pages ветку
git push -u origin gh-pages

# Возвращаемся на main
git checkout main
```

### 6. Включение GitHub Pages

1. Перейдите в настройки репозитория: Settings > Pages
2. Source: Deploy from a branch
3. Branch: gh-pages
4. Folder: / (root)
5. Нажмите Save

## 🌐 Результат

После настройки ваш сайт будет доступен по адресу:
```
https://YOUR_USERNAME.github.io/architect-portfolio
```

## 📁 Структура на GitHub

```
architect-portfolio/
├── main/                    # Основная ветка с исходным кодом
│   ├── src/                # Vue.js компоненты
│   ├── public/             # PHP API
│   ├── dist/               # Собранные файлы
│   └── docs/               # Документация
└── gh-pages/               # Ветка для GitHub Pages
    ├── index.html          # Главная страница
    ├── assets/             # Собранные ресурсы
    ├── api/                # PHP API
    └── backups/            # Резервные копии
```

## 🔗 Полезные ссылки

- **Репозиторий**: `https://github.com/YOUR_USERNAME/architect-portfolio`
- **GitHub Pages**: `https://YOUR_USERNAME.github.io/architect-portfolio`
- **Issues**: `https://github.com/YOUR_USERNAME/architect-portfolio/issues`

## 🎯 Основные возможности

После загрузки на GitHub ваш проект будет включать:

- ✅ **Живой сайт** на GitHub Pages
- ✅ **Полный исходный код** в main ветке
- ✅ **Документация** и инструкции
- ✅ **Готовность к развертыванию** на любом сервере
- ✅ **Возможность клонирования** другими разработчиками

## 🚀 Следующие шаги

1. **Настройте GitHub Pages** в настройках репозитория
2. **Добавьте описание** в README.md
3. **Настройте Issues** для обратной связи
4. **Добавьте теги** для лучшей навигации
5. **Поделитесь ссылкой** с сообществом

---

**🎉 Поздравляем! Ваш проект Architect Portfolio теперь доступен на GitHub!**
