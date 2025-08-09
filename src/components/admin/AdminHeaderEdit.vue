<template>
  <div class="space-y-6">
    <div v-if="loading">
      <AdminSkeleton />
    </div>
    
    <div v-else>
      <!-- Заголовок -->
      <div class="flex justify-between items-center">
        <h1 class="text-2xl font-bold text-gray-900">Редактирование шапки сайта</h1>
        <button
          @click="saveContent"
          :disabled="saving"
          class="bg-blue-600 text-white px-6 py-3 rounded-xl hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2 transition-all duration-200 shadow-lg hover:shadow-xl font-medium"
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
            
            <!-- Заголовок -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Заголовок шапки</label>
              <input
                v-model="form.title"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
                placeholder="Архитектор Иван Иванов"
              />
              <p class="text-sm text-gray-500 mt-1">Основной заголовок, отображаемый в шапке</p>
            </div>

            <!-- Подзаголовок -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Подзаголовок</label>
              <input
                v-model="form.subtitle"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
                placeholder="Современная архитектура"
              />
              <p class="text-sm text-gray-500 mt-1">Дополнительный текст под заголовком (опционально)</p>
            </div>
          </div>

          <!-- Навигационные ссылки -->
          <div class="space-y-6">
            <h2 class="text-xl font-semibold text-gray-900 border-b pb-2">Навигационные ссылки</h2>
            
            <div class="space-y-4">
              <div
                v-for="(link, index) in form.navigation_links"
                :key="index"
                class="p-4 border border-gray-200 rounded-lg hover:border-gray-300 transition-all duration-200"
              >
                <div class="flex items-center justify-between mb-3">
                  <span class="text-sm font-medium text-gray-700">Ссылка {{ index + 1 }}</span>
                  <button
                    @click="removeLink(index)"
                    class="text-gray-600 hover:text-gray-800 p-2 rounded-lg hover:bg-gray-100 bg-white border border-gray-200 shadow-sm hover:shadow-md transition-all duration-200"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                  </button>
                </div>
                
                <div class="grid grid-cols-2 gap-3">
                  <div>
                    <label class="block text-xs font-medium text-gray-700 mb-1">Текст ссылки</label>
                    <input
                      v-model="link.text"
                      type="text"
                      class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
                      placeholder="Обо мне"
                    />
                  </div>
                  <div>
                    <label class="block text-xs font-medium text-gray-700 mb-1">URL</label>
                    <input
                      v-model="link.url"
                      type="text"
                      class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
                      placeholder="/"
                    />
                  </div>
                </div>
                
                <div class="mt-3">
                  <label class="block text-xs font-medium text-gray-700 mb-1">Тип ссылки</label>
                  <select
                    v-model="link.type"
                    class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
                  >
                    <option value="router-link">Внутренняя ссылка (Vue Router)</option>
                    <option value="anchor">Якорная ссылка (#)</option>
                    <option value="external">Внешняя ссылка</option>
                  </select>
                </div>
              </div>
              
              <button
                @click="addLink"
                class="w-full py-3 px-4 border-2 border-dashed border-gray-300 rounded-xl text-gray-500 hover:border-gray-400 hover:text-gray-700 transition-all duration-200 hover:bg-gray-50 font-medium bg-white"
              >
                + Добавить ссылку
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Предварительный просмотр -->
      <div class="bg-white rounded-lg shadow p-6">
        <h2 class="text-xl font-semibold text-gray-900 border-b pb-2 mb-4">Предварительный просмотр</h2>
        <div class="bg-gradient-to-br from-blue-50 via-white to-blue-100 rounded-lg p-6">
          <!-- Шапка -->
          <header class="bg-white/80 backdrop-blur shadow-md border-b border-gray-200 rounded-lg">
            <div class="max-w-6xl mx-auto px-4 py-3 flex justify-between items-center">
              <div>
                <h1 class="text-2xl md:text-3xl font-extrabold tracking-tight text-blue-700 drop-shadow-sm">
                  {{ form.title || 'Архитектор Иван Иванов' }}
                </h1>
                <p v-if="form.subtitle" class="text-sm text-gray-600 mt-1">{{ form.subtitle }}</p>
              </div>
              <nav class="hidden md:flex gap-8 text-lg font-medium">
                <a
                  v-for="link in form.navigation_links"
                  :key="link.text"
                  :href="link.url"
                  class="transition text-gray-700 hover:text-blue-600 hover:underline underline-offset-8"
                >
                  {{ link.text || 'Ссылка' }}
                </a>
              </nav>
              <div class="md:hidden">
                <button class="p-2 rounded focus:outline-none focus:ring-2 focus:ring-blue-400">
                  <svg class="w-7 h-7 text-blue-700" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4 6h16M4 12h16M4 18h16" />
                  </svg>
                </button>
              </div>
            </div>
          </header>
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
  section_name: 'header',
  title: '',
  subtitle: '',
  navigation_links: []
})

const loading = ref(true)
const saving = ref(false)
const error = ref('')

const loadContent = async () => {
  try {
    const response = await axios.get('/api/admin_header.php')
    if (response.data) {
      form.value = response.data
    } else {
      // Используем значения по умолчанию если данные не найдены
      form.value = {
        title: 'Архитектор Иван Иванов',
        subtitle: 'Современная архитектура',
        navigation_links: [
          { text: 'Обо мне', url: '/', type: 'router-link' },
          { text: 'Проекты', url: '/projects', type: 'router-link' },
          { text: 'Контакты', url: '#contacts', type: 'anchor' }
        ]
      }
    }
  } catch (error) {
    console.error('Ошибка загрузки контента:', error)
    // Используем значения по умолчанию при ошибке
    form.value = {
      title: 'Архитектор Иван Иванов',
      subtitle: 'Современная архитектура',
      navigation_links: [
        { text: 'Обо мне', url: '/', type: 'router-link' },
        { text: 'Проекты', url: '/projects', type: 'router-link' },
        { text: 'Контакты', url: '#contacts', type: 'anchor' }
      ]
    }
  } finally {
    loading.value = false
  }
}

const addLink = () => {
  form.value.navigation_links.push({ text: '', url: '', type: 'router-link' })
}

const removeLink = (index) => {
  form.value.navigation_links.splice(index, 1)
}

const saveContent = async () => {
  saving.value = true
  error.value = ''
  
  try {
    await axios.put('/api/admin_header.php', form.value)
    alert('Контент шапки успешно сохранен!')
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
  if (newPath === '/admin/header' && newPath !== oldPath) {
    nextTick(() => {
      loadContent()
    })
  }
})

// Дополнительная проверка при обновлении маршрута
onBeforeRouteUpdate((to, from) => {
  if (to.path === '/admin/header') {
    nextTick(() => {
      loadContent()
    })
  }
})
</script>
