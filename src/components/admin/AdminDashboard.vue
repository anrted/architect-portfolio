<template>
  <div class="space-y-6">
    <!-- Заголовок -->
    <div>
      <h1 class="text-2xl font-bold text-gray-900">Добро пожаловать в админ панель</h1>
      <p class="text-gray-600">Управление портфолио архитектора</p>
    </div>
    
    <!-- Статистика -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-2 bg-blue-100 rounded-lg">
            <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600">Всего проектов</p>
            <p class="text-2xl font-bold text-gray-900">{{ stats.totalProjects }}</p>
          </div>
        </div>
      </div>
      
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-2 bg-green-100 rounded-lg">
            <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 100 4m0-4v2m0-6V4"></path>
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600">Проектов с блоками</p>
            <p class="text-2xl font-bold text-gray-900">{{ stats.projectsWithBlocks }}</p>
          </div>
        </div>
      </div>
      
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-2 bg-purple-100 rounded-lg">
            <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600">Последнее обновление</p>
            <p class="text-sm font-bold text-gray-900">{{ stats.lastUpdate }}</p>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Быстрые действия -->
    <div class="bg-white rounded-lg shadow">
      <div class="p-6 border-b border-gray-200">
        <h2 class="text-lg font-medium text-gray-900">Быстрые действия</h2>
      </div>
      <div class="p-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <router-link
            to="/admin/projects/create"
            class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
          >
            <div class="p-2 bg-blue-100 rounded-lg">
              <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
              </svg>
            </div>
            <div class="ml-4">
              <p class="font-medium text-gray-900">Создать проект</p>
              <p class="text-sm text-gray-600">Добавить новый проект в портфолио</p>
            </div>
          </router-link>
          
          <router-link
            to="/admin/projects"
            class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
          >
            <div class="p-2 bg-green-100 rounded-lg">
              <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
              </svg>
            </div>
            <div class="ml-4">
              <p class="font-medium text-gray-900">Управлять проектами</p>
              <p class="text-sm text-gray-600">Редактировать и удалять проекты</p>
            </div>
          </router-link>
        </div>
      </div>
    </div>
    
    <!-- Последние проекты -->
    <div class="bg-white rounded-lg shadow">
      <div class="p-6 border-b border-gray-200">
        <h2 class="text-lg font-medium text-gray-900">Последние проекты</h2>
      </div>
      <div class="p-6">
        <div v-if="loading" class="text-center py-8">
          <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
          <p class="mt-2 text-gray-600">Загрузка...</p>
        </div>
        
        <div v-else-if="recentProjects.length === 0" class="text-center py-8 text-gray-500">
          Проекты не найдены
        </div>
        
        <div v-else class="space-y-4">
          <div
            v-for="project in recentProjects"
            :key="project.id"
            class="flex items-center justify-between p-4 border border-gray-200 rounded-lg"
          >
            <div class="flex items-center space-x-4">
              <img
                v-if="project.image_url"
                :src="project.image_url"
                :alt="project.title"
                class="w-16 h-16 object-cover rounded-lg"
              />
              <div class="w-16 h-16 bg-gray-200 rounded-lg flex items-center justify-center" v-else>
                <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                </svg>
              </div>
              <div>
                <h3 class="font-medium text-gray-900">{{ project.title }}</h3>
                <p class="text-sm text-gray-600">{{ formatDate(project.created_at) }}</p>
                <p class="text-sm text-gray-500">{{ project.blocks?.length || 0 }} блоков</p>
              </div>
            </div>
            
            <router-link
              :to="`/admin/projects/edit/${project.id}`"
              class="text-blue-600 hover:text-blue-800"
            >
              Редактировать
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const stats = ref({
  totalProjects: 0,
  projectsWithBlocks: 0,
  lastUpdate: 'Никогда'
})

const recentProjects = ref([])
const loading = ref(true)

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('ru-RU', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const loadStats = async () => {
  try {
    const response = await axios.get('/api/admin_projects.php?limit=5')
    
    if (response.data.projects) {
      recentProjects.value = response.data.projects
      stats.value.totalProjects = response.data.pagination.total_items
      stats.value.projectsWithBlocks = response.data.projects.filter(p => p.blocks && p.blocks.length > 0).length
      
      if (response.data.projects.length > 0) {
        stats.value.lastUpdate = formatDate(response.data.projects[0].created_at)
      }
    }
  } catch (error) {
    console.error('Ошибка загрузки статистики:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadStats()
})
</script>
