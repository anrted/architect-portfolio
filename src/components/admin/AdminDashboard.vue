<template>
  <div class="space-y-6">
    <div v-if="loading">
      <AdminSkeleton />
    </div>
    
    <div v-else>
      <!-- Заголовок -->
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Добро пожаловать в админ панель</h1>
        <p class="text-gray-600">Управление портфолио архитектора</p>
      </div>
      
      <!-- Статистика -->
      <div v-if="canViewSection('projects')" class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div class="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-all duration-200">
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
        
        <div class="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-all duration-200">
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
        
        <div class="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-all duration-200">
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
              v-if="canViewSection('projects')"
              to="/admin/projects/create"
              class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-all duration-200 hover:shadow-md"
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
              v-if="canViewSection('projects')"
              to="/admin/projects"
              class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-all duration-200 hover:shadow-md"
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
            
            <router-link
              v-if="canViewSection('backup')"
              to="/admin/backup"
              class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-all duration-200 hover:shadow-md"
            >
              <div class="p-2 bg-purple-100 rounded-lg">
                <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                </svg>
              </div>
              <div class="ml-4">
                <p class="font-medium text-gray-900">Резервные копии</p>
                <p class="text-sm text-gray-600">Создать резервную копию БД</p>
              </div>
            </router-link>
            
            <router-link
              v-if="canViewSection('about')"
              to="/admin/about"
              class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-all duration-200 hover:shadow-md"
            >
              <div class="p-2 bg-yellow-100 rounded-lg">
                <svg class="w-6 h-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                </svg>
              </div>
              <div class="ml-4">
                <p class="font-medium text-gray-900">Редактировать главную</p>
                <p class="text-sm text-gray-600">Изменить контент главной страницы</p>
              </div>
            </router-link>
            
            <router-link
              v-if="canViewSection('header')"
              to="/admin/header"
              class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-all duration-200 hover:shadow-md"
            >
              <div class="p-2 bg-indigo-100 rounded-lg">
                <svg class="w-6 h-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                </svg>
              </div>
              <div class="ml-4">
                <p class="font-medium text-gray-900">Редактировать шапку</p>
                <p class="text-sm text-gray-600">Изменить контент шапки сайта</p>
              </div>
            </router-link>
            
            <router-link
              v-if="canViewSection('contacts')"
              to="/admin/contacts"
              class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-all duration-200 hover:shadow-md"
            >
              <div class="p-2 bg-pink-100 rounded-lg">
                <svg class="w-6 h-6 text-pink-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                </svg>
              </div>
              <div class="ml-4">
                <p class="font-medium text-gray-900">Редактировать контакты</p>
                <p class="text-sm text-gray-600">Изменить контактную информацию</p>
              </div>
            </router-link>
            
            <router-link
              v-if="canViewSection('users')"
              to="/admin/users"
              class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-all duration-200 hover:shadow-md"
            >
              <div class="p-2 bg-red-100 rounded-lg">
                <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                </svg>
              </div>
              <div class="ml-4">
                <p class="font-medium text-gray-900">Управление пользователями</p>
                <p class="text-sm text-gray-600">Управлять пользователями админки</p>
              </div>
            </router-link>
          </div>
        </div>
      </div>
      
      <!-- Последние проекты -->
      <div v-if="canViewSection('projects')" class="bg-white rounded-lg shadow">
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
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick, computed } from 'vue'
import { useRoute, onBeforeRouteUpdate } from 'vue-router'
import axios from 'axios'
import AdminSkeleton from './AdminSkeleton.vue'
import { useAdminStore } from '../../stores/admin'

const route = useRoute()
const adminStore = useAdminStore()

const user = computed(() => adminStore.user)
const canViewSection = adminStore.canViewSection

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
    console.log('Загружаем статистику...')
    const response = await axios.get('/api/admin_projects.php?stats=true')
    console.log('Ответ статистики:', response.data)
    if (response.data) {
      stats.value = {
        totalProjects: response.data.totalProjects || 0,
        projectsWithBlocks: response.data.projectsWithBlocks || 0,
        lastUpdate: response.data.lastUpdate || 'Недавно'
      }
    }
  } catch (error) {
    console.error('Ошибка загрузки статистики:', error)
    if (error.response) {
      console.error('Статус ошибки:', error.response.status)
      console.error('Данные ошибки:', error.response.data)
    }
    stats.value = {
      totalProjects: 0,
      projectsWithBlocks: 0,
      lastUpdate: 'Недавно'
    }
  }
}

const loadRecentProjects = async () => {
  try {
    console.log('Загружаем последние проекты...')
    const response = await axios.get('/api/admin_projects.php?limit=3')
    console.log('Ответ проектов:', response.data)
    if (response.data && response.data.projects) {
      recentProjects.value = response.data.projects
    }
  } catch (error) {
    console.error('Ошибка загрузки последних проектов:', error)
    if (error.response) {
      console.error('Статус ошибки:', error.response.status)
      console.error('Данные ошибки:', error.response.data)
    }
    recentProjects.value = []
  }
}

const loadData = async () => {
  console.log('Начинаем загрузку данных...')
  loading.value = true
  try {
    await Promise.all([loadStats(), loadRecentProjects()])
    console.log('Данные загружены успешно')
  } catch (error) {
    console.error('Ошибка загрузки данных:', error)
  } finally {
    loading.value = false
    console.log('Загрузка завершена')
  }
}

// Загружаем данные при монтировании компонента
onMounted(() => {
  loadData()
})

// Следим за изменениями маршрута и перезагружаем данные при необходимости
watch(() => route.path, (newPath, oldPath) => {
  if (newPath === '/admin' && newPath !== oldPath) {
    nextTick(() => {
      loadData()
    })
  }
})

// Дополнительная проверка при обновлении маршрута
onBeforeRouteUpdate((to, from) => {
  if (to.path === '/admin') {
    nextTick(() => {
      loadData()
    })
  }
})
</script>
