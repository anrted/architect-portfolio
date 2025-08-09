-- Скрипт для добавления настройки цветовой палитры сайта
-- Выполните этот запрос в вашей базе данных

-- Создание таблицы для настроек сайта
CREATE TABLE IF NOT EXISTS `site_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(255) NOT NULL,
  `setting_value` text NOT NULL,
  `setting_type` enum('string','json','boolean','number') DEFAULT 'string',
  `description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Добавление настроек цветовой палитры
INSERT INTO `site_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('color_palette', '{
  "primary": {
    "main": "#2563eb",
    "light": "#3b82f6", 
    "dark": "#1d4ed8",
    "contrast": "#ffffff"
  },
  "textColor": {
    "main": "#1e293b",
    "light": "#64748b",
    "dark": "#0f172a",
    "contrast": "#ffffff"
  },
  "background": {
    "primary": "#ffffff",
    "secondary": "#f8fafc",
    "tertiary": "#f1f5f9"
  },
  "text": {
    "primary": "#1e293b",
    "secondary": "#64748b", 
    "muted": "#94a3b8"
  },
  "border": {
    "primary": "#e2e8f0",
    "secondary": "#cbd5e1"
  },
  "success": {
    "main": "#10b981",
    "light": "#34d399",
    "dark": "#059669"
  },
  "error": {
    "main": "#ef4444",
    "light": "#f87171", 
    "dark": "#dc2626"
  },
  "warning": {
    "main": "#f59e0b",
    "light": "#fbbf24",
    "dark": "#d97706"
  },
  "info": {
    "main": "#3b82f6",
    "light": "#60a5fa",
    "dark": "#2563eb"
  }
}', 'json', 'Настройки цветовой палитры сайта для админки'),
('theme_mode', 'light', 'string', 'Режим темы: light, dark, auto'),
('custom_css', '', 'string', 'Пользовательские CSS стили'),
('site_title_color', '#1e293b', 'string', 'Цвет заголовка сайта'),
('site_description_color', '#64748b', 'string', 'Цвет описания сайта'),
('button_primary_color', '#2563eb', 'string', 'Основной цвет кнопок'),
('button_secondary_color', '#64748b', 'string', 'Вторичный цвет кнопок'),
('link_color', '#2563eb', 'string', 'Цвет ссылок'),
('link_hover_color', '#1d4ed8', 'string', 'Цвет ссылок при наведении')
ON DUPLICATE KEY UPDATE 
  `setting_value` = VALUES(`setting_value`),
  `description` = VALUES(`description`),
  `updated_at` = CURRENT_TIMESTAMP;

-- Комментарий: После выполнения этого скрипта вы сможете управлять цветовой палитрой через админку
-- Для получения настроек используйте запрос: SELECT * FROM site_settings WHERE setting_key = 'color_palette';
