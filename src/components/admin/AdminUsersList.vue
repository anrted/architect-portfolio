<template>
  <div class="space-y-4 sm:space-y-6">
    <!-- Заголовок и кнопка добавления -->
    <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
      <div>
        <h1 class="text-xl sm:text-2xl font-bold text-gray-900">Пользователи</h1>
        <p class="text-sm sm:text-base text-gray-600">Управление пользователями админки</p>
      </div>
      <button
        @click="showCreateModal = true"
        class="bg-blue-600 text-white px-3 py-2 sm:px-4 sm:py-2 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 text-sm sm:text-base w-full sm:w-auto"
      >
        <svg class="w-4 h-4 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
        </svg>
        Добавить пользователя
      </button>
    </div>

    <!-- Поиск -->
    <div class="bg-white p-3 sm:p-4 rounded-lg shadow">
      <div class="flex gap-2 sm:gap-4">
        <div class="flex-1">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Поиск по имени, email или логину..."
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
            @input="handleSearch"
          />
        </div>
      </div>
    </div>

    <!-- Список пользователей -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
      <div v-if="loading" class="p-4 sm:p-6">
        <AdminSkeleton />
      </div>
      
      <div v-else-if="users.length === 0" class="p-4 sm:p-6 text-center text-gray-500">
        <svg class="w-8 h-8 sm:w-12 sm:h-12 mx-auto mb-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-6a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
        </svg>
        <p class="text-sm sm:text-base">Пользователи не найдены</p>
      </div>
      
      <div v-else class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-3 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Пользователь
              </th>
              <th class="px-2 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden sm:table-cell">
                Роль
              </th>
              <th class="px-2 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden sm:table-cell">
                Статус
              </th>
              <th class="px-2 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden lg:table-cell">
                Последний вход
              </th>
              <th class="px-3 sm:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Действия
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="user in users" :key="user.id" class="hover:bg-gray-50">
              <td class="px-3 sm:px-6 py-4">
                <div class="flex items-center">
                  <div class="flex-shrink-0 h-8 w-8 sm:h-10 sm:w-10">
                    <div class="h-8 w-8 sm:h-10 sm:w-10 rounded-full bg-blue-500 flex items-center justify-center">
                      <span class="text-white font-medium text-sm sm:text-base">{{ user.full_name.charAt(0).toUpperCase() }}</span>
                    </div>
                  </div>
                  <div class="ml-3 sm:ml-4 min-w-0 flex-1">
                    <div class="text-sm font-medium text-gray-900 truncate">{{ user.full_name }}</div>
                    <div class="text-xs sm:text-sm text-gray-500 truncate">{{ user.email }}</div>
                    <div class="text-xs text-gray-400">@{{ user.username }}</div>
                    <!-- Мобильная информация -->
                    <div class="sm:hidden mt-1">
                      <span 
                        class="inline-flex px-2 py-1 text-xs font-semibold rounded-full mr-2"
                        :class="user.role === 'admin' ? 'bg-red-100 text-red-800' : 'bg-blue-100 text-blue-800'"
                      >
                        {{ user.role === 'admin' ? 'Админ' : 'Редактор' }}
                      </span>
                      <span 
                        class="inline-flex px-2 py-1 text-xs font-semibold rounded-full"
                        :class="user.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
                      >
                        {{ user.is_active ? 'Активен' : 'Неактивен' }}
                      </span>
                    </div>
                  </div>
                </div>
              </td>
              <td class="px-2 sm:px-6 py-4 hidden sm:table-cell">
                <span 
                  class="inline-flex px-2 py-1 text-xs font-semibold rounded-full"
                  :class="user.role === 'admin' ? 'bg-red-100 text-red-800' : 'bg-blue-100 text-blue-800'"
                >
                  {{ user.role === 'admin' ? 'Администратор' : 'Редактор' }}
                </span>
              </td>
              <td class="px-2 sm:px-6 py-4 hidden sm:table-cell">
                <span 
                  class="inline-flex px-2 py-1 text-xs font-semibold rounded-full"
                  :class="user.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
                >
                  {{ user.is_active ? 'Активен' : 'Неактивен' }}
                </span>
              </td>
              <td class="px-2 sm:px-6 py-4 text-sm text-gray-500 hidden lg:table-cell">
                {{ user.last_login ? formatDate(user.last_login) : 'Никогда' }}
              </td>
              <td class="px-3 sm:px-6 py-4 text-sm font-medium">
                <div class="flex flex-col sm:flex-row gap-1 sm:gap-2">
                  <button
                    @click="editUser(user)"
                    class="inline-flex items-center justify-center text-blue-600 hover:text-blue-900 text-xs sm:text-sm px-2 py-1 rounded hover:bg-blue-50 transition-colors"
                  >
                    <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                    </svg>
                    <span class="hidden sm:inline">Редактировать</span>
                    <span class="sm:hidden">Изменить</span>
                  </button>
                  <button
                    v-if="user.id !== currentUser?.id"
                    @click="deleteUser(user)"
                    class="inline-flex items-center justify-center text-red-600 hover:text-red-900 text-xs sm:text-sm px-2 py-1 rounded hover:bg-red-50 transition-colors"
                  >
                    <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                    </svg>
                    <span class="hidden sm:inline">Удалить</span>
                    <span class="sm:hidden">Удал.</span>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Пагинация -->
    <div v-if="pagination.total_pages > 1" class="bg-white px-3 sm:px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
      <div class="flex-1 flex justify-between sm:hidden">
        <button
          @click="changePage(pagination.current_page - 1)"
          :disabled="pagination.current_page === 1"
          class="relative inline-flex items-center px-3 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Назад
        </button>
        <button
          @click="changePage(pagination.current_page + 1)"
          :disabled="pagination.current_page === pagination.total_pages"
          class="ml-3 relative inline-flex items-center px-3 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Вперед
        </button>
      </div>
      <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
        <div>
          <p class="text-sm text-gray-700">
            Показано <span class="font-medium">{{ (pagination.current_page - 1) * pagination.per_page + 1 }}</span>
            до <span class="font-medium">{{ Math.min(pagination.current_page * pagination.per_page, pagination.total_items) }}</span>
            из <span class="font-medium">{{ pagination.total_items }}</span> результатов
          </p>
        </div>
        <div>
          <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
            <button
              v-for="page in getPageNumbers()"
              :key="page"
              @click="changePage(page)"
              :class="[
                page === pagination.current_page
                  ? 'z-10 bg-blue-50 border-blue-500 text-blue-600'
                  : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
                'relative inline-flex items-center px-3 sm:px-4 py-2 border text-sm font-medium'
              ]"
            >
              {{ page }}
            </button>
          </nav>
        </div>
      </div>
    </div>

    <!-- Модал создания/редактирования пользователя -->
    <AdminUserForm
      v-if="showCreateModal || showEditModal"
      :user="editingUser"
      :mode="showCreateModal ? 'create' : 'edit'"
      @close="closeModal"
      @saved="handleUserSaved"
    />

    <!-- Модал подтверждения удаления -->
    <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg p-4 sm:p-6 max-w-md w-full mx-4">
        <h3 class="text-lg font-medium text-gray-900 mb-4">Подтверждение удаления</h3>
        <p class="text-gray-600 mb-6 text-sm sm:text-base">
          Вы уверены, что хотите удалить пользователя <strong>{{ deletingUser?.full_name }}</strong>?
          Это действие нельзя отменить.
        </p>
        <div class="flex flex-col sm:flex-row justify-end gap-2 sm:gap-3 sm:space-x-3">
          <button
            @click="showDeleteModal = false"
            class="px-4 py-2 text-gray-700 bg-gray-200 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500 text-sm sm:text-base"
          >
            Отмена
          </button>
          <button
            @click="confirmDelete"
            class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 text-sm sm:text-base"
          >
            Удалить
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch, nextTick } from 'vue'
import { useRoute, onBeforeRouteUpdate } from 'vue-router'
import axios from 'axios'
import AdminSkeleton from './AdminSkeleton.vue'
import AdminUserForm from './AdminUserForm.vue'
import { useAdminStore } from '../../stores/admin.js'

const route = useRoute()
const adminStore = useAdminStore()

// Состояние
const users = ref([])
const loading = ref(false)
const searchQuery = ref('')
const showCreateModal = ref(false)
const showEditModal = ref(false)
const showDeleteModal = ref(false)
const editingUser = ref(null)
const deletingUser = ref(null)
const pagination = ref({
  current_page: 1,
  per_page: 10,
  total_items: 0,
  total_pages: 0
})

// Получаем текущего пользователя
const currentUser = computed(() => adminStore.user)

// Загрузка пользователей
const loadUsers = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.value.current_page,
      limit: pagination.value.per_page
    }
    
    if (searchQuery.value) {
      params.search = searchQuery.value
    }
    
    const response = await axios.get('/api/admin_users.php', { params })
    
    if (response.data.success) {
      users.value = response.data.users
      pagination.value = response.data.pagination
    }
  } catch (error) {
    console.error('Ошибка загрузки пользователей:', error)
  } finally {
    loading.value = false
  }
}

// Поиск
const handleSearch = () => {
  pagination.value.current_page = 1
  loadUsers()
}

// Изменение страницы
const changePage = (page) => {
  if (page >= 1 && page <= pagination.value.total_pages) {
    pagination.value.current_page = page
    loadUsers()
  }
}

// Получение номеров страниц для пагинации
const getPageNumbers = () => {
  const pages = []
  const current = pagination.value.current_page
  const total = pagination.value.total_pages
  
  if (total <= 7) {
    for (let i = 1; i <= total; i++) {
      pages.push(i)
    }
  } else {
    if (current <= 4) {
      for (let i = 1; i <= 5; i++) {
        pages.push(i)
      }
      pages.push('...')
      pages.push(total)
    } else if (current >= total - 3) {
      pages.push(1)
      pages.push('...')
      for (let i = total - 4; i <= total; i++) {
        pages.push(i)
      }
    } else {
      pages.push(1)
      pages.push('...')
      for (let i = current - 1; i <= current + 1; i++) {
        pages.push(i)
      }
      pages.push('...')
      pages.push(total)
    }
  }
  
  return pages
}

// Редактирование пользователя
const editUser = (user) => {
  editingUser.value = { ...user }
  showEditModal.value = true
}

// Удаление пользователя
const deleteUser = (user) => {
  deletingUser.value = user
  showDeleteModal.value = true
}

// Подтверждение удаления
const confirmDelete = async () => {
  try {
    const response = await axios.delete(`/api/admin_users.php?id=${deletingUser.value.id}`)
    
    if (response.data.success) {
      await loadUsers()
      showDeleteModal.value = false
      deletingUser.value = null
    }
  } catch (error) {
    console.error('Ошибка удаления пользователя:', error)
  }
}

// Закрытие модала
const closeModal = () => {
  showCreateModal.value = false
  showEditModal.value = false
  editingUser.value = null
}

// Обработка сохранения пользователя
const handleUserSaved = async () => {
  await loadUsers()
  closeModal()
}

// Форматирование даты
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('ru-RU', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// Загружаем данные при монтировании компонента
onMounted(() => {
  loadUsers()
})

// Следим за изменениями маршрута
watch(() => route.path, (newPath, oldPath) => {
  if (newPath === '/admin/users' && newPath !== oldPath) {
    nextTick(() => {
      loadUsers()
    })
  }
})

// Дополнительная проверка при обновлении маршрута
onBeforeRouteUpdate((to, from) => {
  if (to.path === '/admin/users') {
    nextTick(() => {
      loadUsers()
    })
  }
})
</script>
