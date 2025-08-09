<template>
  <div class="min-h-screen bg-gray-50 flex">
    <!-- Боковая панель -->
    <aside class="w-64 bg-white shadow-lg">
      <div class="p-6 border-b border-gray-200">
        <h1 class="text-xl font-bold text-gray-900">Админ панель</h1>
        <p class="text-sm text-gray-600">{{ user?.full_name }}</p>
      </div>
      
      <nav class="mt-6">
        <router-link
          to="/admin"
          class="flex items-center px-6 py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path === '/admin' }"
        >
          <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2H5a2 2 0 00-2-2z"></path>
          </svg>
          Главная
        </router-link>
        
        <router-link
          to="/admin/projects"
          class="flex items-center px-6 py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path.startsWith('/admin/projects') }"
        >
          <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
          </svg>
          Проекты
        </router-link>
      </nav>
    </aside>
    
    <!-- Основной контент -->
    <main class="flex-1 overflow-hidden">
      <!-- Шапка -->
      <header class="bg-white shadow-sm border-b border-gray-200">
        <div class="px-6 py-4 flex justify-between items-center">
          <h2 class="text-lg font-medium text-gray-900">
            {{ pageTitle }}
          </h2>
          
          <div class="flex items-center space-x-4">
            <router-link 
              to="/"
              target="_blank"
              class="text-gray-600 hover:text-gray-900"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
              </svg>
            </router-link>
            
            <button 
              @click="handleLogout"
              class="text-gray-600 hover:text-gray-900"
              title="Выйти"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
              </svg>
            </button>
          </div>
        </div>
      </header>
      
      <!-- Содержимое страницы -->
      <div class="p-6">
        <router-view />
      </div>
    </main>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAdminStore } from '../../stores/admin'

const route = useRoute()
const router = useRouter()
const adminStore = useAdminStore()

const user = computed(() => adminStore.user)

const pageTitle = computed(() => {
  const titles = {
    '/admin': 'Панель управления',
    '/admin/projects': 'Управление проектами',
    '/admin/projects/create': 'Создание проекта',
    '/admin/projects/edit': 'Редактирование проекта'
  }
  
  for (const [path, title] of Object.entries(titles)) {
    if (route.path.startsWith(path)) {
      return title
    }
  }
  
  return 'Админ панель'
})

const handleLogout = async () => {
  await adminStore.logout()
  router.push('/admin/login')
}
</script>

<style scoped>
.border-r-3 {
  border-right-width: 3px;
}
</style>
