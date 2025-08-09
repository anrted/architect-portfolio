<template>
  <!-- Hero секция -->
  <section id="about" class="relative mb-8 sm:mb-12 md:mb-16 lg:mb-20 overflow-hidden">
    <!-- Фоновая секция -->
    <div class="relative bg-gradient-to-br from-blue-50 via-white to-blue-100 rounded-t-2xl sm:rounded-t-3xl p-4 sm:p-6 md:p-8 lg:p-16 shadow-xl">
      <!-- Декоративные элементы -->
      <div class="absolute top-0 right-0 w-32 h-32 sm:w-48 sm:h-48 md:w-64 md:h-64 bg-blue-200 rounded-full opacity-10 transform translate-x-16 sm:translate-x-24 md:translate-x-32 -translate-y-16 sm:-translate-y-24 md:-translate-y-32"></div>
      <div class="absolute bottom-0 left-0 w-24 h-24 sm:w-36 sm:h-36 md:w-48 md:h-48 bg-blue-300 rounded-full opacity-10 transform -translate-x-12 sm:-translate-x-18 md:-translate-x-24 translate-y-12 sm:translate-y-18 md:translate-y-24"></div>
      
      <div class="relative z-10 max-w-4xl mx-auto">
        <!-- Главный заголовок -->
        <div class="text-center mb-8 sm:mb-10 md:mb-12">
          <div class="inline-flex items-center justify-center w-16 h-16 sm:w-20 sm:h-20 md:w-24 md:h-24 bg-blue-600 rounded-full mb-4 sm:mb-6 shadow-lg">
            <svg class="w-8 h-8 sm:w-10 sm:h-10 md:w-12 md:h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
            </svg>
          </div>
          <h1 class="text-2xl sm:text-3xl md:text-4xl lg:text-6xl font-bold text-gray-900 mb-4 sm:mb-6 leading-tight">
            {{ content.title || 'Иван Иванов' }}
          </h1>
          <p class="text-lg sm:text-xl md:text-2xl text-gray-600 font-light mb-6 sm:mb-8">
            {{ content.subtitle || 'Архитектор современности' }}
          </p>
        </div>

        <!-- Основной контент -->
        <div class="grid md:grid-cols-2 gap-8 sm:gap-10 md:gap-12 items-center">
          <div class="space-y-4 sm:space-y-6">
            <div class="prose prose-sm sm:prose-base md:prose-lg text-gray-700 leading-relaxed">
              <p class="text-lg sm:text-xl font-medium text-gray-900 mb-3 sm:mb-4">
                Создаю пространства, которые вдохновляют
              </p>
              <p class="mb-3 sm:mb-4 whitespace-pre-line text-sm sm:text-base">
                {{ content.main_text || 'Я — архитектор с опытом более 10 лет, специализирующийся на современных жилых и общественных зданиях. В каждом проекте стремлюсь найти баланс между эстетикой, функциональностью и устойчивостью.' }}
              </p>
              <p v-if="!content.main_text" class="text-sm sm:text-base">
                Мой подход основан на глубоком понимании потребностей клиента, внимании к деталям и использовании передовых технологий в архитектуре.
              </p>
            </div>

            <!-- Ключевые преимущества -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 sm:gap-4 mt-6 sm:mt-8">
              <div
                v-for="advantage in content.advantages || defaultAdvantages"
                :key="advantage.text"
                class="flex items-center space-x-3"
              >
                <div class="w-6 h-6 sm:w-8 sm:h-8 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <svg class="w-4 h-4 sm:w-5 sm:h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                  </svg>
                </div>
                <span class="font-medium text-gray-900 text-sm sm:text-base">{{ advantage.text }}</span>
              </div>
            </div>
          </div>

          <!-- Статистика -->
          <div class="bg-white rounded-xl sm:rounded-2xl p-4 sm:p-6 md:p-8 shadow-lg border border-gray-100">
            <div class="grid grid-cols-2 gap-4 sm:gap-6">
              <div
                v-for="stat in content.statistics || defaultStatistics"
                :key="stat.value"
                class="text-center"
              >
                <div class="text-2xl sm:text-3xl font-bold text-blue-600 mb-1 sm:mb-2">{{ stat.value }}</div>
                <div class="text-xs sm:text-sm text-gray-600 font-medium">{{ stat.label }}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- CTA кнопка -->
        <div class="text-center mt-8 sm:mt-10 md:mt-12">
          <a href="#contacts" class="inline-flex items-center px-6 sm:px-8 py-3 sm:py-4 bg-blue-600 text-white font-medium rounded-xl shadow-lg hover:bg-blue-700 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 text-sm sm:text-base">
            <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-3.582 8-8 8a8.13 8.13 0 01-2.906-.515L7 21l1.515-3.094A8.002 8.002 0 013 12c0-4.418 3.582-8 8-8s8 3.582 8 8z"></path>
            </svg>
            Обсудить проект
          </a>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const content = ref({})
const loading = ref(true)

const defaultAdvantages = [
  { text: '10+ лет опыта', icon: 'check' },
  { text: 'Инновационный подход', icon: 'lightning' },
  { text: 'Точность в сроках', icon: 'clock' },
  { text: 'Индивидуальный подход', icon: 'heart' }
]

const defaultStatistics = [
  { value: '50+', label: 'Реализованных проектов' },
  { value: '10', label: 'Лет опыта' },
  { value: '100%', label: 'Довольных клиентов' },
  { value: '5', label: 'Наград' }
]

const loadContent = async () => {
  try {
    const response = await axios.get('/api/about.php?section=hero')
    if (response.data) {
      content.value = response.data
    }
  } catch (error) {
    console.error('Ошибка загрузки контента:', error)
    // Используем значения по умолчанию если не удалось загрузить
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadContent()
})
</script>
