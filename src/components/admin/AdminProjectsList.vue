<template>
  <div class="space-y-6">
    <!-- Заголовок и действия -->
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold text-gray-900">Управление проектами</h1>
      <router-link
        to="/admin/projects/create"
        class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 flex items-center space-x-2"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
        </svg>
        <span>Создать проект</span>
      </router-link>
    </div>
    
    <!-- Поиск и фильтры -->
    <div class="bg-white rounded-lg shadow p-6">
      <div class="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0">
        <div class="flex-1 max-w-md">
          <input
            v-model="searchQuery"
            @input="handleSearch"
            type="text"
            placeholder="Поиск проектов..."
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>
        
        <div class="flex items-center space-x-4">
          <select
            v-model="perPage"
            @change="loadProjects"
            class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="10">10 на странице</option>
            <option value="25">25 на странице</option>
            <option value="50">50 на странице</option>
          </select>
        </div>
      </div>
    </div>
    
    <!-- Список проектов -->
    <div class="bg-white rounded-lg shadow">
      <div v-if="loading" class="p-8 text-center">
        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
        <p class="mt-2 text-gray-600">Загрузка проектов...</p>
      </div>
      
      <div v-else-if="projects.length === 0" class="p-8 text-center text-gray-500">
        <svg class="w-12 h-12 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
        </svg>
        <p>Проекты не найдены</p>
        <router-link
          to="/admin/projects/create"
          class="text-blue-600 hover:text-blue-800 mt-2 inline-block"
        >
          Создать первый проект
        </router-link>
      </div>
      
      <div v-else>
        <div class="divide-y divide-gray-200">
          <div
            v-for="project in projects"
            :key="project.id"
            class="p-6 hover:bg-gray-50 transition-colors"
          >
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-4">
                <img
                  v-if="project.image_url"
                  :src="project.image_url"
                  :alt="project.title"
                  class="w-20 h-20 object-cover rounded-lg"
                />
                <div class="w-20 h-20 bg-gray-200 rounded-lg flex items-center justify-center" v-else>
                  <svg class="w-10 h-10 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                  </svg>
                </div>
                
                <div class="flex-1">
                  <h3 class="text-lg font-medium text-gray-900">{{ project.title }}</h3>
                  <p class="text-gray-600 mt-1" v-if="project.description">
                    {{ project.description.substring(0, 150) }}{{ project.description.length > 150 ? '...' : '' }}
                  </p>
                  <div class="flex items-center space-x-4 mt-2 text-sm text-gray-500">
                    <span>{{ formatDate(project.created_at) }}</span>
                    <span>{{ project.blocks?.length || 0 }} блоков</span>
                  </div>
                </div>
              </div>
              
              <div class="flex items-center space-x-2">
                <router-link
                  :to="`/projects/${project.id}`"
                  target="_blank"
                  class="text-gray-600 hover:text-gray-900 p-2 rounded-md hover:bg-gray-100"
                  title="Просмотреть"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                  </svg>
                </router-link>
                
                <router-link
                  :to="`/admin/projects/edit/${project.id}`"
                  class="text-blue-600 hover:text-blue-800 p-2 rounded-md hover:bg-blue-50"
                  title="Редактировать"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                  </svg>
                </router-link>
                
                <button
                  @click="confirmDelete(project)"
                  class="text-red-600 hover:text-red-800 p-2 rounded-md hover:bg-red-50"
                  title="Удалить"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                  </svg>
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Пагинация -->
        <div v-if="pagination.total_pages > 1" class="px-6 py-4 border-t border-gray-200">
          <div class="flex items-center justify-between">
            <div class="text-sm text-gray-700">
              Показано {{ (pagination.current_page - 1) * pagination.per_page + 1 }} - 
              {{ Math.min(pagination.current_page * pagination.per_page, pagination.total_items) }} 
              из {{ pagination.total_items }} проектов
            </div>
            
            <div class="flex items-center space-x-2">
              <button
                @click="changePage(pagination.current_page - 1)"
                :disabled="pagination.current_page <= 1"
                class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Назад
              </button>
              
              <span class="px-3 py-2 text-sm font-medium">
                {{ pagination.current_page }} из {{ pagination.total_pages }}
              </span>
              
              <button
                @click="changePage(pagination.current_page + 1)"
                :disabled="pagination.current_page >= pagination.total_pages"
                class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Вперед
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Модал подтверждения удаления -->
  <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4">
      <h3 class="text-lg font-medium text-gray-900 mb-4">Подтвердите удаление</h3>
      <p class="text-gray-600 mb-6">
        Вы уверены, что хотите удалить проект "{{ projectToDelete?.title }}"? 
        Это действие нельзя отменить.
      </p>
      
      <div class="flex justify-end space-x-4">
        <button
          @click="cancelDelete"
          class="px-4 py-2 text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200"
        >
          Отмена
        </button>
        <button
          @click="deleteProject"
          :disabled="deleting"
          class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 disabled:opacity-50"
        >
          {{ deleting ? 'Удаление...' : 'Удалить' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const projects = ref([])
const loading = ref(true)
const searchQuery = ref('')
const perPage = ref(10)
const currentPage = ref(1)
const pagination = ref({
  current_page: 1,
  total_pages: 1,
  total_items: 0,
  per_page: 10
})

const showDeleteModal = ref(false)
const projectToDelete = ref(null)
const deleting = ref(false)

let searchTimeout = null

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('ru-RU', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const loadProjects = async () => {
  loading.value = true
  
  try {
    const params = new URLSearchParams({
      page: currentPage.value,
      limit: perPage.value
    })
    
    if (searchQuery.value.trim()) {
      params.append('search', searchQuery.value.trim())
    }
    
    const response = await axios.get(`/api/admin_projects.php?${params}`)
    
    projects.value = response.data.projects || []
    pagination.value = response.data.pagination || {}
  } catch (error) {
    console.error('Ошибка загрузки проектов:', error)
    projects.value = []
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    currentPage.value = 1
    loadProjects()
  }, 500)
}

const changePage = (page) => {
  if (page >= 1 && page <= pagination.value.total_pages) {
    currentPage.value = page
    loadProjects()
  }
}

const confirmDelete = (project) => {
  projectToDelete.value = project
  showDeleteModal.value = true
}

const cancelDelete = () => {
  projectToDelete.value = null
  showDeleteModal.value = false
}

const deleteProject = async () => {
  if (!projectToDelete.value) return
  
  deleting.value = true
  
  try {
    await axios.delete(`/api/admin_projects.php?id=${projectToDelete.value.id}`)
    
    // Перезагружаем список проектов
    await loadProjects()
    
    showDeleteModal.value = false
    projectToDelete.value = null
  } catch (error) {
    console.error('Ошибка удаления проекта:', error)
    alert('Ошибка при удалении проекта')
  } finally {
    deleting.value = false
  }
}

onMounted(() => {
  loadProjects()
})
</script>
