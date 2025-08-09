<template>
  <div class="space-y-6">
    <div v-if="loading">
      <AdminSkeleton />
    </div>
    
    <div v-else>
      <!-- Заголовок -->
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-900">Цветовая палитра</h1>
          <p class="text-gray-600">Настройка цветов сайта архитектора. Выберите основной цвет, остальные оттенки сгенерируются автоматически для создания гармоничной цветовой схемы.</p>
        </div>
        <div class="flex space-x-3">
          <button
            @click="resetToDefaults"
            class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all duration-200"
          >
            Сбросить
          </button>
          <button
            @click="savePalette"
            :disabled="saving"
            class="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="saving">Сохранение...</span>
            <span v-else>Сохранить</span>
          </button>
        </div>
      </div>

      <!-- Сообщения -->
      <div v-if="message" class="p-4 rounded-lg" :class="messageType === 'success' ? 'bg-green-50 text-green-800' : 'bg-red-50 text-red-800'">
        {{ message }}
      </div>

      <!-- Основные цвета -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Основной цвет -->
        <div class="bg-white rounded-lg shadow p-6">
          <h3 class="text-lg font-medium text-gray-900 mb-4">Основной цвет сайта</h3>
          <p class="text-sm text-gray-600 mb-4">Этот цвет будет использоваться как основной акцентный цвет для заголовков, кнопок, ссылок и ключевых элементов интерфейса сайта архитектора</p>
          
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <label class="text-sm font-medium text-gray-700">Основной цвет</label>
              <div class="flex items-center space-x-2">
                <input
                  v-model="primaryColor"
                  type="color"
                  class="w-12 h-8 rounded border border-gray-300 cursor-pointer"
                  @input="generatePalette"
                />
                <input
                  v-model="primaryColor"
                  type="text"
                  class="w-20 px-2 py-1 text-sm border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  placeholder="#2563eb"
                  @input="generatePalette"
                />
              </div>
            </div>
          </div>

          <!-- Где используется -->
          <div class="mt-6 p-4 bg-gray-50 rounded-lg">
            <h4 class="font-medium text-gray-900 mb-2">Где используется на сайте:</h4>
            <ul class="text-sm text-gray-600 space-y-1">
              <li>• <strong>Заголовки и логотип</strong> - основной цвет для названия архитектора в шапке</li>
              <li>• <strong>Навигационные ссылки</strong> - цвет при наведении и активных состояниях</li>
              <li>• <strong>Кнопки действий</strong> - "Обсудить проект", "Связаться", "Посмотреть все проекты"</li>
              <li>• <strong>Акцентные элементы</strong> - иконки, теги проектов, стрелки</li>
              <li>• <strong>Интерактивные элементы</strong> - hover-эффекты, фокусные состояния</li>
              <li>• <strong>Фоновые акценты</strong> - градиенты, декоративные элементы</li>
            </ul>
          </div>
        </div>

        <!-- Предварительный просмотр -->
        <div class="bg-white rounded-lg shadow p-6">
          <h3 class="text-lg font-medium text-gray-900 mb-4">Предварительный просмотр</h3>
          <div class="space-y-3">
            <div class="flex items-center space-x-3">
              <div class="w-8 h-8 rounded" :style="{ backgroundColor: palette.primary.main }"></div>
              <span class="text-sm font-medium">Основной цвет</span>
              <span class="text-sm text-gray-500">{{ palette.primary.main }}</span>
            </div>
            <div class="flex items-center space-x-3">
              <div class="w-8 h-8 rounded" :style="{ backgroundColor: palette.primary.light }"></div>
              <span class="text-sm font-medium">Светлый оттенок</span>
              <span class="text-sm text-gray-500">{{ palette.primary.light }}</span>
            </div>
            <div class="flex items-center space-x-3">
              <div class="w-8 h-8 rounded" :style="{ backgroundColor: palette.primary.dark }"></div>
              <span class="text-sm font-medium">Темный оттенок</span>
              <span class="text-sm text-gray-500">{{ palette.primary.dark }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Сгенерированная палитра -->
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-medium text-gray-900">Сгенерированная палитра</h3>
          <button
            @click="showAdvanced = !showAdvanced"
            class="text-sm text-blue-600 hover:text-blue-700 font-medium"
          >
            {{ showAdvanced ? 'Скрыть' : 'Показать' }} расширенные настройки
          </button>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <!-- Primary Colors -->
          <div class="border border-gray-200 rounded-lg p-4">
            <h4 class="font-medium text-gray-900 mb-3">Основные цвета</h4>
            <div class="space-y-2">
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Основной</span>
                <div class="flex items-center space-x-2">
                  <div class="w-6 h-6 rounded border" :style="{ backgroundColor: palette.primary.main }"></div>
                  <span class="text-xs font-mono">{{ palette.primary.main }}</span>
                </div>
              </div>
              <div v-if="showAdvanced" class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Светлый</span>
                <div class="flex items-center space-x-2">
                  <input
                    v-model="palette.primary.light"
                    type="color"
                    class="w-6 h-6 rounded border border-gray-300 cursor-pointer"
                  />
                  <input
                    v-model="palette.primary.light"
                    type="text"
                    class="w-16 px-1 py-0.5 text-xs border border-gray-300 rounded"
                  />
                </div>
              </div>
              <div v-if="showAdvanced" class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Темный</span>
                <div class="flex items-center space-x-2">
                  <input
                    v-model="palette.primary.dark"
                    type="color"
                    class="w-6 h-6 rounded border border-gray-300 cursor-pointer"
                  />
                  <input
                    v-model="palette.primary.dark"
                    type="text"
                    class="w-16 px-1 py-0.5 text-xs border border-gray-300 rounded"
                  />
                </div>
              </div>
            </div>
          </div>

          <!-- Text Colors -->
          <div class="border border-gray-200 rounded-lg p-4">
            <h4 class="font-medium text-gray-900 mb-3">Цвет текста</h4>
            <div class="space-y-2">
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Основной</span>
                <div class="flex items-center space-x-2">
                  <div class="w-6 h-6 rounded border" :style="{ backgroundColor: palette.textColor.main }"></div>
                  <span class="text-xs font-mono">{{ palette.textColor.main }}</span>
                </div>
              </div>
              <div v-if="showAdvanced" class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Светлый</span>
                <div class="flex items-center space-x-2">
                  <input
                    v-model="palette.textColor.light"
                    type="color"
                    class="w-6 h-6 rounded border border-gray-300 cursor-pointer"
                  />
                  <input
                    v-model="palette.textColor.light"
                    type="text"
                    class="w-16 px-1 py-0.5 text-xs border border-gray-300 rounded"
                  />
                </div>
              </div>
              <div v-if="showAdvanced" class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Темный</span>
                <div class="flex items-center space-x-2">
                  <input
                    v-model="palette.textColor.dark"
                    type="color"
                    class="w-6 h-6 rounded border border-gray-300 cursor-pointer"
                  />
                  <input
                    v-model="palette.textColor.dark"
                    type="text"
                    class="w-16 px-1 py-0.5 text-xs border border-gray-300 rounded"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Примеры использования -->
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-medium text-gray-900">Примеры использования на сайте</h3>
          <button
            @click="showExamples = !showExamples"
            class="text-sm text-blue-600 hover:text-blue-700 font-medium"
          >
            {{ showExamples ? 'Скрыть' : 'Показать' }} примеры
          </button>
        </div>
        <div v-if="showExamples" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <!-- Заголовки и логотип -->
          <div class="space-y-3">
            <h4 class="font-medium text-gray-900">Заголовки и логотип</h4>
            <div class="space-y-2">
              <div class="p-3 rounded-lg border" :style="{ borderColor: palette.primary.light, backgroundColor: palette.background.secondary }">
                <h5 class="font-bold text-xl" :style="{ color: palette.primary.main }">Архитектор Иван Иванов</h5>
                <p class="text-sm mt-1" :style="{ color: palette.textColor.light }">Архитектор современности</p>
              </div>
            </div>
          </div>

          <!-- Навигация -->
          <div class="space-y-3">
            <h4 class="font-medium text-gray-900">Навигация</h4>
            <div class="space-y-2">
              <div class="flex space-x-2">
                <a href="#" class="px-3 py-2 rounded-lg font-medium transition-colors" :style="{ color: palette.textColor.main }">Обо мне</a>
                <a href="#" class="px-3 py-2 rounded-lg font-medium transition-colors" :style="{ color: palette.primary.main, backgroundColor: palette.primary.light + '20' }">Проекты</a>
                <a href="#" class="px-3 py-2 rounded-lg font-medium transition-colors" :style="{ color: palette.textColor.main }">Контакты</a>
              </div>
            </div>
          </div>

          <!-- Кнопки действий -->
          <div class="space-y-3">
            <h4 class="font-medium text-gray-900">Кнопки действий</h4>
            <div class="space-y-2">
              <button class="px-4 py-2 rounded-lg text-white font-medium w-full" :style="{ backgroundColor: palette.primary.main }">
                Обсудить проект
              </button>
              <button class="px-4 py-2 rounded-lg border font-medium w-full" :style="{ borderColor: palette.primary.main, color: palette.primary.main }">
                Посмотреть все проекты
              </button>
            </div>
          </div>

          <!-- Карточки проектов -->
          <div class="space-y-3">
            <h4 class="font-medium text-gray-900">Карточки проектов</h4>
            <div class="p-4 rounded-lg border shadow-sm" :style="{ borderColor: palette.primary.light, backgroundColor: palette.background.primary }">
              <div class="h-24 bg-gradient-to-br rounded-lg mb-3" :style="{ background: `linear-gradient(135deg, ${palette.primary.light}20, ${palette.primary.main}20)` }"></div>
              <h5 class="font-medium" :style="{ color: palette.textColor.main }">Современный дом</h5>
              <p class="text-sm mt-1" :style="{ color: palette.textColor.light }">Частный дом в современном стиле</p>
              <div class="mt-3">
                <span class="text-xs px-2 py-1 rounded-full font-medium" :style="{ backgroundColor: palette.primary.light + '30', color: palette.primary.dark }">
                  Архитектура
                </span>
              </div>
            </div>
          </div>

          <!-- Акцентные элементы -->
          <div class="space-y-3">
            <h4 class="font-medium text-gray-900">Акцентные элементы</h4>
            <div class="space-y-2">
              <div class="flex items-center space-x-3">
                <div class="w-8 h-8 rounded-lg flex items-center justify-center" :style="{ backgroundColor: palette.primary.main }">
                  <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                  </svg>
                </div>
                <span class="text-sm font-medium" :style="{ color: palette.textColor.main }">10+ лет опыта</span>
              </div>
              <div class="flex items-center space-x-3">
                <div class="w-8 h-8 rounded-lg flex items-center justify-center" :style="{ backgroundColor: palette.primary.light }">
                  <svg class="w-4 h-4" :style="{ color: palette.primary.dark }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                  </svg>
                </div>
                <span class="text-sm font-medium" :style="{ color: palette.textColor.main }">Инновационный подход</span>
              </div>
            </div>
          </div>

          <!-- Формы и интерактивные элементы -->
          <div class="space-y-3">
            <h4 class="font-medium text-gray-900">Формы и интерактивные элементы</h4>
            <div class="space-y-2">
              <input 
                type="text" 
                placeholder="Ваше имя" 
                class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2"
                :style="{ borderColor: palette.primary.light, '--tw-ring-color': palette.primary.main }"
              />
              <div class="flex space-x-2">
                <button class="px-3 py-1 rounded text-sm font-medium" :style="{ backgroundColor: palette.primary.main, color: palette.primary.contrast }">
                  Отправить
                </button>
                <button class="px-3 py-1 rounded text-sm font-medium border" :style="{ borderColor: palette.primary.main, color: palette.primary.main }">
                  Отмена
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import AdminSkeleton from './AdminSkeleton.vue'

const loading = ref(true)
const saving = ref(false)
const message = ref('')
const messageType = ref('success')
const showAdvanced = ref(false)
const showExamples = ref(false)

// Основной цвет
const primaryColor = ref('#2563eb')

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

const palette = ref({ ...defaultPalette })

// Утилиты для работы с цветами
const hexToHsl = (hex) => {
  const r = parseInt(hex.substr(1, 2), 16) / 255
  const g = parseInt(hex.substr(3, 2), 16) / 255
  const b = parseInt(hex.substr(5, 2), 16) / 255

  const max = Math.max(r, g, b)
  const min = Math.min(r, g, b)
  let h, s, l = (max + min) / 2

  if (max === min) {
    h = s = 0
  } else {
    const d = max - min
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
    switch (max) {
      case r: h = (g - b) / d + (g < b ? 6 : 0); break
      case g: h = (b - r) / d + 2; break
      case b: h = (r - g) / d + 4; break
    }
    h /= 6
  }

  return [h * 360, s * 100, l * 100]
}

const hslToHex = (h, s, l) => {
  h /= 360
  s /= 100
  l /= 100

  const c = (1 - Math.abs(2 * l - 1)) * s
  const x = c * (1 - Math.abs((h * 6) % 2 - 1))
  const m = l - c / 2
  let r = 0, g = 0, b = 0

  if (0 <= h && h < 1/6) {
    r = c; g = x; b = 0
  } else if (1/6 <= h && h < 1/3) {
    r = x; g = c; b = 0
  } else if (1/3 <= h && h < 1/2) {
    r = 0; g = c; b = x
  } else if (1/2 <= h && h < 2/3) {
    r = 0; g = x; b = c
  } else if (2/3 <= h && h < 5/6) {
    r = x; g = 0; b = c
  } else if (5/6 <= h && h <= 1) {
    r = c; g = 0; b = x
  }

  const rHex = Math.round((r + m) * 255).toString(16).padStart(2, '0')
  const gHex = Math.round((g + m) * 255).toString(16).padStart(2, '0')
  const bHex = Math.round((b + m) * 255).toString(16).padStart(2, '0')

  return `#${rHex}${gHex}${bHex}`
}

// Функция для генерации оттенков цвета
const generateShades = (color) => {
  // Конвертируем основной цвет в HSL
  const [h, s, l] = hexToHsl(color)

  // Генерируем светлые оттенки (аналогично Tailwind CSS)
  const lightL = Math.min(100, l + (100 - l) * 0.3)
  const lightColor = hslToHex(h, s, lightL)

  // Генерируем темные оттенки (аналогично Tailwind CSS)
  const darkL = Math.max(0, l * 0.7)
  const darkColor = hslToHex(h, s, darkL)

  return {
    light: lightColor,
    dark: darkColor
  }
}

// Функция для генерации цвета текста на основе основного цвета
const generateTextColor = (primaryColor) => {
  const [h, s, l] = hexToHsl(primaryColor)
  
  // Генерируем цвет текста - используем темный оттенок для основного текста
  // Основной текст должен быть темным для хорошей читаемости
  const textMain = hslToHex(h, Math.min(15, s * 0.2), Math.max(15, Math.min(25, l * 0.3)))
  
  // Светлый оттенок для вторичного текста
  const textLight = hslToHex(h, Math.min(10, s * 0.15), Math.max(40, Math.min(60, l * 0.8)))
  
  // Темный оттенок для заголовков
  const textDark = hslToHex(h, Math.min(20, s * 0.3), Math.max(5, Math.min(15, l * 0.2)))
  
  return {
    main: textMain,
    light: textLight,
    dark: textDark,
    contrast: '#ffffff'
  }
}

// Генерация палитры на основе основного цвета
const generatePalette = () => {
  const primaryShades = generateShades(primaryColor.value)
  const textColors = generateTextColor(primaryColor.value)
  
  palette.value = {
    ...palette.value,
    primary: {
      main: primaryColor.value,
      light: primaryShades.light,
      dark: primaryShades.dark,
      contrast: '#ffffff'
    },
    textColor: textColors,
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
}

// Загрузка цветовой палитры
const loadPalette = async () => {
  try {
    const response = await axios.get('/api/settings.php?key=color_palette')
    if (response.data && response.data.setting_value) {
      palette.value = { ...defaultPalette, ...response.data.setting_value }
      primaryColor.value = palette.value.primary.main
      // Генерируем новые цвета на основе загруженного основного цвета
      generatePalette()
    } else {
      // Если нет сохраненных настроек, генерируем палитру по умолчанию
      generatePalette()
    }
  } catch (error) {
    console.error('Ошибка загрузки цветовой палитры:', error)
    message.value = 'Ошибка загрузки цветовой палитры'
    messageType.value = 'error'
    // В случае ошибки генерируем палитру по умолчанию
    generatePalette()
  } finally {
    loading.value = false
  }
}

// Сохранение цветовой палитры
const savePalette = async () => {
  saving.value = true
  message.value = ''
  
  try {
    const response = await axios.post('/api/settings.php', {
      setting_key: 'color_palette',
      setting_value: palette.value,
      setting_type: 'json',
      description: 'Настройки цветовой палитры сайта для админки'
    })
    
    if (response.data.success) {
      message.value = 'Цветовая палитра успешно сохранена'
      messageType.value = 'success'
    } else {
      throw new Error('Ошибка сохранения')
    }
  } catch (error) {
    console.error('Ошибка сохранения цветовой палитры:', error)
    message.value = 'Ошибка сохранения цветовой палитры'
    messageType.value = 'error'
  } finally {
    saving.value = false
  }
}

// Сброс к значениям по умолчанию
const resetToDefaults = () => {
  primaryColor.value = defaultPalette.primary.main
  generatePalette() // Используем новую функцию генерации
  message.value = 'Палитра сброшена к значениям по умолчанию'
  messageType.value = 'success'
}

onMounted(() => {
  loadPalette()
})
</script>
