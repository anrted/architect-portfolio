import axios from 'axios'

// Структура цветовой палитры по умолчанию
const defaultPalette = {
  primary: {
    main: '#2563eb',
    light: '#3b82f6',
    dark: '#1d4ed8',
    contrast: '#ffffff'
  },
  textColor: {
    main: '#1e293b',
    light: '#64748b',
    dark: '#0f172a',
    contrast: '#ffffff'
  },
  background: {
    primary: '#ffffff',
    secondary: '#f8fafc',
    tertiary: '#f1f5f9'
  },
  text: {
    primary: '#1e293b',
    secondary: '#64748b',
    muted: '#94a3b8'
  },
  border: {
    primary: '#e2e8f0',
    secondary: '#cbd5e1'
  },
  success: {
    main: '#10b981',
    light: '#34d399',
    dark: '#059669'
  },
  error: {
    main: '#ef4444',
    light: '#f87171',
    dark: '#dc2626'
  },
  warning: {
    main: '#f59e0b',
    light: '#fbbf24',
    dark: '#d97706'
  },
  info: {
    main: '#3b82f6',
    light: '#60a5fa',
    dark: '#2563eb'
  }
}

/**
 * Загружает цветовую палитру из базы данных
 * @returns {Promise<Object>} Цветовая палитра
 */
export async function loadColorPalette() {
  try {
    const response = await axios.get('/api/settings.php?key=color_palette')
    if (response.data && response.data.setting_value) {
      return { ...defaultPalette, ...response.data.setting_value }
    }
    return defaultPalette
  } catch (error) {
    console.error('Ошибка загрузки цветовой палитры:', error)
    return defaultPalette
  }
}

/**
 * Применяет цветовую палитру к CSS переменным
 * @param {Object} palette - Цветовая палитра
 */
export function applyColorPalette(palette) {
  const root = document.documentElement
  
  // Основные цвета
  root.style.setProperty('--primary-color', palette.primary.main)
  root.style.setProperty('--primary-color-light', palette.primary.light)
  root.style.setProperty('--primary-color-dark', palette.primary.dark)
  root.style.setProperty('--primary-color-contrast', palette.primary.contrast)
  
  // Цвета текста
  root.style.setProperty('--text-color-main', palette.textColor.main)
  root.style.setProperty('--text-color-light', palette.textColor.light)
  root.style.setProperty('--text-color-dark', palette.textColor.dark)
  root.style.setProperty('--text-color-contrast', palette.textColor.contrast)
  
  // Фоновые цвета
  root.style.setProperty('--background-primary', palette.background.primary)
  root.style.setProperty('--background-secondary', palette.background.secondary)
  root.style.setProperty('--background-tertiary', palette.background.tertiary)
  
  // Цвета текста (legacy)
  root.style.setProperty('--text-primary', palette.text.primary)
  root.style.setProperty('--text-secondary', palette.text.secondary)
  root.style.setProperty('--text-muted', palette.text.muted)
  
  // Цвета границ
  root.style.setProperty('--border-primary', palette.border.primary)
  root.style.setProperty('--border-secondary', palette.border.secondary)
  
  // Цвета состояний
  root.style.setProperty('--success-color', palette.success.main)
  root.style.setProperty('--error-color', palette.error.main)
  root.style.setProperty('--warning-color', palette.warning.main)
  root.style.setProperty('--info-color', palette.info.main)
}

/**
 * Инициализирует цветовую палитру на сайте
 */
export async function initializeColorPalette() {
  const palette = await loadColorPalette()
  applyColorPalette(palette)
  return palette
}

/**
 * Получает текущую цветовую палитру из CSS переменных
 * @returns {Object} Текущая цветовая палитра
 */
export function getCurrentColorPalette() {
  const root = document.documentElement
  const style = getComputedStyle(root)
  
  return {
    primary: {
      main: style.getPropertyValue('--primary-color').trim() || defaultPalette.primary.main,
      light: style.getPropertyValue('--primary-color-light').trim() || defaultPalette.primary.light,
      dark: style.getPropertyValue('--primary-color-dark').trim() || defaultPalette.primary.dark,
      contrast: style.getPropertyValue('--primary-color-contrast').trim() || defaultPalette.primary.contrast
    },
    textColor: {
      main: style.getPropertyValue('--text-color-main').trim() || defaultPalette.textColor.main,
      light: style.getPropertyValue('--text-color-light').trim() || defaultPalette.textColor.light,
      dark: style.getPropertyValue('--text-color-dark').trim() || defaultPalette.textColor.dark,
      contrast: style.getPropertyValue('--text-color-contrast').trim() || defaultPalette.textColor.contrast
    }
  }
}
