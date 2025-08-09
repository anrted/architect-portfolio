<template>
  <div class="min-h-screen bg-gray-50 flex flex-col lg:flex-row">
    <!-- Мобильная кнопка меню -->
    <div class="lg:hidden fixed top-4 left-4 z-[60]">
      <button
        @click="toggleMobileMenu"
        class="bg-white p-2.5 rounded-xl shadow-lg hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 border border-gray-300 transition-all duration-200 hover:shadow-xl"
      >
        <svg class="w-6 h-6 text-gray-900" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
        </svg>
      </button>
    </div>

    <!-- Боковая панель -->
    <aside 
      class="fixed inset-y-0 left-0 z-[55] w-64 bg-white shadow-lg transform transition-transform duration-300 ease-in-out lg:relative lg:translate-x-0 lg:flex-shrink-0"
      :class="mobileMenuOpen ? 'translate-x-0' : '-translate-x-full'"
    >
      <div class="p-4 sm:p-6 border-b border-gray-200">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-lg sm:text-xl font-bold text-gray-900">Админ панель</h1>
            <p class="text-xs sm:text-sm text-gray-600">{{ user?.full_name }}</p>
          </div>
          <button
            @click="toggleMobileMenu"
            class="lg:hidden p-2.5 rounded-xl hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 border border-gray-300 transition-all duration-200 bg-white shadow-sm hover:shadow-md"
          >
            <svg class="w-5 h-5 text-gray-900" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
          </button>
        </div>
      </div>
      
      <nav class="mt-4 sm:mt-6">
        <router-link
          to="/admin"
          @click="closeMobileMenu"
          class="flex items-center px-4 sm:px-6 py-2 sm:py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600 transition-all duration-200 text-sm sm:text-base"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path === '/admin' }"
        >
          <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2 sm:mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2H5a2 2 0 00-2-2z"></path>
          </svg>
          <span class="truncate">Главная</span>
        </router-link>
        
        <router-link
          v-if="canViewSection('about')"
          to="/admin/about"
          @click="closeMobileMenu"
          class="flex items-center px-4 sm:px-6 py-2 sm:py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600 transition-all duration-200 text-sm sm:text-base"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path === '/admin/about' }"
        >
          <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2 sm:mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
          </svg>
          <span class="truncate">Главная страница</span>
        </router-link>
        
        <router-link
          v-if="canViewSection('about')"
          to="/admin/components"
          @click="closeMobileMenu"
          class="flex items-center px-4 sm:px-6 py-2 sm:py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600 transition-all duration-200 text-sm sm:text-base"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path === '/admin/components' }"
        >
          <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2 sm:mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
          </svg>
          <span class="truncate">Компоненты</span>
        </router-link>
        
        <router-link
          v-if="canViewSection('header')"
          to="/admin/header"
          @click="closeMobileMenu"
          class="flex items-center px-4 sm:px-6 py-2 sm:py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600 transition-all duration-200 text-sm sm:text-base"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path === '/admin/header' }"
        >
          <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2 sm:mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          </svg>
          <span class="truncate">Шапка сайта</span>
        </router-link>
        
        <router-link
          v-if="canViewSection('contacts')"
          to="/admin/contacts"
          @click="closeMobileMenu"
          class="flex items-center px-4 sm:px-6 py-2 sm:py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600 transition-all duration-200 text-sm sm:text-base"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path === '/admin/contacts' }"
        >
          <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2 sm:mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
          </svg>
          <span class="truncate">Контакты</span>
        </router-link>
        
        <router-link
          v-if="canViewSection('backup')"
          to="/admin/backup"
          @click="closeMobileMenu"
          class="flex items-center px-4 sm:px-6 py-2 sm:py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600 transition-all duration-200 text-sm sm:text-base"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path === '/admin/backup' }"
        >
          <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2 sm:mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
          </svg>
          <span class="truncate">Резервные копии</span>
        </router-link>
        
        <router-link
          v-if="canViewSection('settings')"
          to="/admin/colors"
          @click="closeMobileMenu"
          class="flex items-center px-4 sm:px-6 py-2 sm:py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600 transition-all duration-200 text-sm sm:text-base"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path === '/admin/colors' }"
        >
          <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2 sm:mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17v4a2 2 0 002 2h4M7 17l-2.828 2.828a2 2 0 01-2.828 0L2 16.172a2 2 0 010-2.828L7 17z"></path>
          </svg>
          <span class="truncate">Цветовая палитра</span>
        </router-link>
        
        <router-link
          v-if="canViewSection('projects')"
          to="/admin/projects"
          @click="closeMobileMenu"
          class="flex items-center px-4 sm:px-6 py-2 sm:py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600 transition-all duration-200 text-sm sm:text-base"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path.startsWith('/admin/projects') }"
        >
          <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2 sm:mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
          </svg>
          <span class="truncate">Проекты</span>
        </router-link>
        
        <router-link
          v-if="canViewSection('users')"
          to="/admin/users"
          @click="closeMobileMenu"
          class="flex items-center px-4 sm:px-6 py-2 sm:py-3 text-gray-700 hover:bg-blue-50 hover:text-blue-600 border-r-3 hover:border-blue-600 transition-all duration-200 text-sm sm:text-base"
          :class="{ 'bg-blue-50 text-blue-600 border-blue-600': $route.path === '/admin/users' }"
        >
          <svg class="w-4 h-4 sm:w-5 sm:h-5 mr-2 sm:mr-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
          </svg>
          <span class="truncate">Пользователи</span>
        </router-link>
      </nav>
    </aside>

    <!-- Затемнение для мобильного меню -->
    <div 
      v-if="mobileMenuOpen" 
      @click="closeMobileMenu"
      class="fixed inset-0 bg-black bg-opacity-50 z-[50] lg:hidden"
    ></div>
    
    <!-- Основной контент -->
    <main class="flex-1 overflow-hidden lg:ml-0 flex flex-col min-h-0">
      <!-- Шапка -->
      <header class="bg-white shadow-sm border-b border-gray-200 flex-shrink-0">
        <div class="px-4 sm:px-6 py-4 flex justify-between items-center">
          <h2 class="text-base sm:text-lg font-medium text-gray-900">
            {{ pageTitle }}
          </h2>
          
          <div class="flex items-center space-x-2 sm:space-x-4">
            <router-link 
              to="/"
              target="_blank"
              class="text-gray-600 hover:text-gray-900 transition-colors duration-200 p-2 rounded-md hover:bg-gray-100"
            >
              <svg class="w-4 h-4 sm:w-5 sm:h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
              </svg>
            </router-link>
            
            <button 
              @click="handleLogout"
              class="text-gray-600 hover:text-gray-900 transition-colors duration-200 p-2 rounded-lg hover:bg-gray-100 bg-white border border-gray-200 shadow-sm hover:shadow-md"
              title="Выйти"
            >
              <svg class="w-4 h-4 sm:w-5 sm:h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
              </svg>
            </button>
          </div>
        </div>
      </header>
      
      <!-- Содержимое страницы -->
      <div class="flex-1 flex flex-col min-h-0 p-4 sm:p-6 lg:pt-6 pt-20">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" :key="$route.path" class="h-full" />
          </transition>
        </router-view>
      </div>
    </main>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAdminStore } from '../../stores/admin'

const route = useRoute()
const router = useRouter()
const adminStore = useAdminStore()

const user = computed(() => adminStore.user)
const canViewSection = adminStore.canViewSection

const mobileMenuOpen = ref(false)

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}

const closeMobileMenu = () => {
  mobileMenuOpen.value = false
}

const pageTitle = computed(() => {
  const titles = {
    '/admin': 'Панель управления',
    '/admin/about': 'Редактирование главной страницы',
    '/admin/components': 'Управление компонентами',
    '/admin/header': 'Редактирование шапки сайта',
    '/admin/contacts': 'Редактирование контактов',
    '/admin/backup': 'Резервные копии БД',
    '/admin/projects': 'Управление проектами',
    '/admin/projects/create': 'Создание проекта',
    '/admin/projects/edit': 'Редактирование проекта',
    '/admin/users': 'Управление пользователями',
    '/admin/colors': 'Цветовая палитра'
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

/* Плавные переходы */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

/* Анимация для скелетона */
@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>
