<template>
  <div class="space-y-6">
    <div v-if="loadingBackups">
      <AdminSkeleton />
    </div>
    
    <div v-else>
      <!-- Заголовок -->
      <div class="flex justify-between items-center">
        <h1 class="text-2xl font-bold text-gray-900">Резервные копии базы данных</h1>
        <button
          @click="createBackup"
          :disabled="loading"
          class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2 transition-all duration-200"
        >
          <svg v-if="loading" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
          </svg>
          <span>{{ loading ? 'Создание...' : 'Создать резервную копию' }}</span>
        </button>
      </div>

      <!-- Информация -->
      <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
        <div class="flex items-start">
          <svg class="w-5 h-5 text-blue-600 mt-0.5 mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
          <div>
            <h3 class="text-sm font-medium text-blue-800">Информация о резервных копиях</h3>
            <div class="mt-2 text-sm text-blue-700">
              <p>• Резервные копии создаются в формате SQL и содержат полную структуру и данные базы данных</p>
              <p>• Файлы сохраняются в папке <code class="bg-blue-100 px-1 rounded">public/backups/</code></p>
              <p>• Рекомендуется создавать резервные копии перед крупными изменениями</p>
              <p>• Файлы можно скачать и использовать для восстановления данных</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Список резервных копий -->
      <div class="bg-white rounded-lg shadow">
        <div class="p-6 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Список резервных копий</h2>
        </div>
        
        <div class="p-6">
          <div v-if="loadingBackups" class="text-center py-8">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
            <p class="mt-2 text-gray-600">Загрузка резервных копий...</p>
          </div>
          
          <div v-else-if="backups.length === 0" class="text-center py-8 text-gray-500">
            <svg class="w-12 h-12 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
            </svg>
            <p class="text-lg font-medium text-gray-900 mb-2">Резервные копии не найдены</p>
            <p class="text-gray-600">Создайте первую резервную копию базы данных</p>
          </div>
          
          <div v-else class="space-y-4">
            <div
              v-for="backup in backups"
              :key="backup.filename"
              class="flex items-center justify-between p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
            >
              <div class="flex items-center space-x-4">
                <div class="p-2 bg-green-100 rounded-lg">
                  <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                  </svg>
                </div>
                <div>
                  <h3 class="font-medium text-gray-900">{{ backup.filename }}</h3>
                  <div class="flex items-center space-x-4 text-sm text-gray-600">
                    <span>{{ backup.created_at }}</span>
                    <span class="flex items-center">
                      <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4"></path>
                      </svg>
                      {{ backup.file_size }}
                    </span>
                  </div>
                </div>
              </div>
              
              <div class="flex items-center space-x-2">
                <a
                  :href="backup.download_url"
                  class="inline-flex items-center px-3 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                >
                  <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                  </svg>
                  Скачать
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Последние действия -->
    <div v-if="lastAction" class="bg-green-50 border border-green-200 rounded-lg p-4">
      <div class="flex items-center">
        <svg class="w-5 h-5 text-green-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
        <div>
          <h3 class="text-sm font-medium text-green-800">Успешно!</h3>
          <p class="text-sm text-green-700">{{ lastAction }}</p>
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

const backups = ref([])
const loading = ref(false)
const loadingBackups = ref(true)
const lastAction = ref('')

const loadBackups = async () => {
  loadingBackups.value = true
  try {
    const response = await axios.get('/api/admin_backup.php')
    if (response.data && response.data.backups) {
      backups.value = response.data.backups
    } else {
      backups.value = []
    }
  } catch (error) {
    console.error('Ошибка загрузки резервных копий:', error)
    backups.value = []
  } finally {
    loadingBackups.value = false
  }
}

const createBackup = async () => {
  loading.value = true
  lastAction.value = ''
  
  try {
    const response = await axios.post('/api/admin_backup.php')
    
    if (response.data.success) {
      lastAction.value = `Резервная копия "${response.data.filename}" успешно создана (${response.data.file_size})`
      
      // Обновляем список резервных копий
      await loadBackups()
    } else {
      throw new Error(response.data.error || 'Ошибка создания резервной копии')
    }
  } catch (error) {
    console.error('Ошибка создания резервной копии:', error)
    lastAction.value = `Ошибка: ${error.response?.data?.error || error.message}`
  } finally {
    loading.value = false
  }
}

// Загружаем данные при монтировании компонента
onMounted(() => {
  loadBackups()
})

// Следим за изменениями маршрута и перезагружаем данные при необходимости
watch(() => route.path, (newPath, oldPath) => {
  if (newPath === '/admin/backup' && newPath !== oldPath) {
    nextTick(() => {
      loadBackups()
    })
  }
})

// Дополнительная проверка при обновлении маршрута
onBeforeRouteUpdate((to, from) => {
  if (to.path === '/admin/backup') {
    nextTick(() => {
      loadBackups()
    })
  }
})
</script>
