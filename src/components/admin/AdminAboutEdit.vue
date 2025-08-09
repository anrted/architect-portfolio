<template>
  <div class="space-y-6">
    <div v-if="loading">
      <AdminSkeleton />
    </div>
    
    <div v-else>
      <!-- Заголовок -->
      <div class="flex justify-between items-center">
        <h1 class="text-2xl font-bold text-gray-900">Редактирование главной страницы</h1>
        <button
          @click="saveContent"
          :disabled="saving"
          class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2 transition-all duration-200"
        >
          <svg v-if="saving" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <span>{{ saving ? 'Сохранение...' : 'Сохранить изменения' }}</span>
        </button>
      </div>

      <!-- Форма редактирования -->
      <div class="bg-white rounded-lg shadow p-6">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <!-- Основная информация -->
          <div class="space-y-6">
            <h2 class="text-xl font-semibold text-gray-900 border-b pb-2">Основная информация</h2>
            
            <!-- Имя -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Имя и фамилия</label>
              <input
                v-model="form.title"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Иван Иванов"
              />
            </div>

            <!-- Должность -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Должность</label>
              <input
                v-model="form.subtitle"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Архитектор современности"
              />
            </div>

            <!-- Основной текст -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Основной текст</label>
              <textarea
                v-model="form.main_text"
                rows="6"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Опишите ваш опыт и подход к работе..."
              ></textarea>
            </div>
          </div>

          <!-- Преимущества и статистика -->
          <div class="space-y-6">
            <!-- Преимущества -->
            <div>
              <h2 class="text-xl font-semibold text-gray-900 border-b pb-2 mb-4">Ключевые преимущества</h2>
              <div class="space-y-3">
                <div
                  v-for="(advantage, index) in form.advantages"
                  :key="index"
                  class="flex items-center space-x-3 p-3 border border-gray-200 rounded-lg"
                >
                  <div class="flex-1">
                    <input
                      v-model="advantage.text"
                      type="text"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      :placeholder="`Преимущество ${index + 1}`"
                    />
                  </div>
                  <button
                    @click="removeAdvantage(index)"
                    class="text-red-500 hover:text-red-700 p-2"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                    </svg>
                  </button>
                </div>
                <button
                  @click="addAdvantage"
                  class="w-full py-2 px-4 border-2 border-dashed border-gray-300 rounded-lg text-gray-500 hover:border-gray-400 hover:text-gray-700 transition-colors"
                >
                  + Добавить преимущество
                </button>
              </div>
            </div>

            <!-- Статистика -->
            <div>
              <h2 class="text-xl font-semibold text-gray-900 border-b pb-2 mb-4">Статистика</h2>
              <div class="grid grid-cols-2 gap-4">
                <div
                  v-for="(stat, index) in form.statistics"
                  :key="index"
                  class="p-3 border border-gray-200 rounded-lg"
                >
                  <div class="flex items-center justify-between mb-2">
                    <span class="text-sm font-medium text-gray-700">Статистика {{ index + 1 }}</span>
                    <button
                      @click="removeStatistic(index)"
                      class="text-red-500 hover:text-red-700"
                    >
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                      </svg>
                    </button>
                  </div>
                  <input
                    v-model="stat.value"
                    type="text"
                    class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 mb-2"
                    placeholder="50+"
                  />
                  <input
                    v-model="stat.label"
                    type="text"
                    class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="Реализованных проектов"
                  />
                </div>
              </div>
              <button
                @click="addStatistic"
                class="w-full mt-3 py-2 px-4 border-2 border-dashed border-gray-300 rounded-lg text-gray-500 hover:border-gray-400 hover:text-gray-700 transition-colors"
              >
                + Добавить статистику
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Предварительный просмотр -->
      <div class="bg-white rounded-lg shadow p-6">
        <h2 class="text-xl font-semibold text-gray-900 border-b pb-2 mb-4">Предварительный просмотр</h2>
        <div class="bg-gradient-to-br from-blue-50 via-white to-blue-100 rounded-lg p-6">
          <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">{{ form.title || 'Иван Иванов' }}</h1>
            <p class="text-lg text-gray-600">{{ form.subtitle || 'Архитектор современности' }}</p>
          </div>
          
          <div class="grid md:grid-cols-2 gap-8">
            <div class="space-y-4">
              <div class="prose prose-sm text-gray-700">
                <p class="whitespace-pre-line">{{ form.main_text || 'Текст о себе...' }}</p>
              </div>
              
              <div class="grid grid-cols-2 gap-4">
                <div
                  v-for="advantage in form.advantages"
                  :key="advantage.text"
                  class="flex items-center space-x-3"
                >
                  <div class="w-6 h-6 bg-blue-100 rounded-lg flex items-center justify-center">
                    <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                  </div>
                  <span class="font-medium text-gray-900">{{ advantage.text || 'Преимущество' }}</span>
                </div>
              </div>
            </div>
            
            <div class="bg-white rounded-lg p-6 shadow">
              <div class="grid grid-cols-2 gap-4">
                <div
                  v-for="stat in form.statistics"
                  :key="stat.value"
                  class="text-center"
                >
                  <div class="text-2xl font-bold text-blue-600">{{ stat.value || '0' }}</div>
                  <div class="text-sm text-gray-600">{{ stat.label || 'Статистика' }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue'
import { useRoute, onBeforeRouteUpdate } from 'vue-router'
import axios from 'axios'
import AdminSkeleton from './AdminSkeleton.vue'

const route = useRoute()

const form = ref({
  section_name: 'hero',
  title: '',
  subtitle: '',
  main_text: '',
  advantages: [],
  statistics: []
})

const loading = ref(true)
const saving = ref(false)
const error = ref('')

const loadContent = async () => {
  try {
    const response = await axios.get('/api/admin_about.php')
    if (response.data) {
      form.value = response.data
    } else {
      // Используем значения по умолчанию если данные не найдены
      form.value = {
        title: 'Иван Иванов',
        subtitle: 'Архитектор современности',
        main_text: 'Опытный архитектор с более чем 10-летним стажем работы в области современной архитектуры. Специализируюсь на создании уникальных проектов, которые сочетают в себе функциональность, эстетику и инновационные решения.',
        advantages: [
          { text: 'Более 50 реализованных проектов' },
          { text: 'Современные технологии и материалы' },
          { text: 'Индивидуальный подход к каждому клиенту' },
          { text: 'Полный цикл проектирования' }
        ],
        statistics: [
          { value: '50+', label: 'Реализованных проектов' },
          { value: '10+', label: 'Лет опыта' },
          { value: '100%', label: 'Довольных клиентов' },
          { value: '24/7', label: 'Поддержка' }
        ]
      }
    }
  } catch (error) {
    console.error('Ошибка загрузки контента:', error)
    // Используем значения по умолчанию при ошибке
    form.value = {
      title: 'Иван Иванов',
      subtitle: 'Архитектор современности',
      main_text: 'Опытный архитектор с более чем 10-летним стажем работы в области современной архитектуры. Специализируюсь на создании уникальных проектов, которые сочетают в себе функциональность, эстетику и инновационные решения.',
      advantages: [
        { text: 'Более 50 реализованных проектов' },
        { text: 'Современные технологии и материалы' },
        { text: 'Индивидуальный подход к каждому клиенту' },
        { text: 'Полный цикл проектирования' }
      ],
      statistics: [
        { value: '50+', label: 'Реализованных проектов' },
        { value: '10+', label: 'Лет опыта' },
        { value: '100%', label: 'Довольных клиентов' },
        { value: '24/7', label: 'Поддержка' }
      ]
    }
  } finally {
    loading.value = false
  }
}

const addAdvantage = () => {
  form.value.advantages.push({ text: '', icon: 'check' })
}

const removeAdvantage = (index) => {
  form.value.advantages.splice(index, 1)
}

const addStatistic = () => {
  form.value.statistics.push({ value: '', label: '' })
}

const removeStatistic = (index) => {
  form.value.statistics.splice(index, 1)
}

const saveContent = async () => {
  saving.value = true
  error.value = ''
  
  try {
    await axios.put('/api/admin_about.php', form.value)
    alert('Контент успешно сохранен!')
  } catch (err) {
    error.value = err.response?.data?.error || 'Ошибка при сохранении контента'
    alert(error.value)
  } finally {
    saving.value = false
  }
}

// Загружаем данные при монтировании компонента
onMounted(() => {
  loadContent()
})

// Следим за изменениями маршрута и перезагружаем данные при необходимости
watch(() => route.path, (newPath, oldPath) => {
  if (newPath === '/admin/about' && newPath !== oldPath) {
    nextTick(() => {
      loadContent()
    })
  }
})

// Дополнительная проверка при обновлении маршрута
onBeforeRouteUpdate((to, from) => {
  if (to.path === '/admin/about') {
    nextTick(() => {
      loadContent()
    })
  }
})
</script>
