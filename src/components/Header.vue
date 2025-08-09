<template>
  <header class="fixed top-0 left-0 w-full z-50 bg-white/80 backdrop-blur shadow-md border-b border-gray-200" :style="{ borderColor: 'var(--border-primary)' }">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 py-2 sm:py-3 flex justify-between items-center">
      <div>
        <h1 class="text-xl sm:text-2xl md:text-3xl font-extrabold tracking-tight drop-shadow-sm select-none" :style="{ color: 'var(--primary-color)' }">
          {{ headerContent.title || 'Архитектор Иван Иванов' }}
        </h1>
        <p v-if="headerContent.subtitle" class="text-xs sm:text-sm mt-1" :style="{ color: 'var(--text-color-light)' }">{{ headerContent.subtitle }}</p>
      </div>
      <nav class="hidden md:flex gap-8 text-lg font-medium">
        <template v-for="link in headerContent.navigation_links" :key="link.text">
          <router-link 
            v-if="link.type === 'router-link'" 
            :to="link.url" 
            class="transition hover:underline underline-offset-8"
            :style="{ color: 'var(--text-color-main)' }"
            :class="{ 'text-primary-color': $route.path === link.url }"
          >
            {{ link.text }}
          </router-link>
          <a 
            v-else-if="link.type === 'anchor'" 
            :href="link.url" 
            class="transition hover:underline underline-offset-8"
            :style="{ color: 'var(--text-color-main)' }"
          >
            {{ link.text }}
          </a>
          <a 
            v-else 
            :href="link.url" 
            target="_blank" 
            rel="noopener noreferrer"
            class="transition hover:underline underline-offset-8"
            :style="{ color: 'var(--text-color-main)' }"
          >
            {{ link.text }}
          </a>
        </template>
      </nav>
      <div class="md:hidden">
        <button @click="open = !open" class="p-2.5 rounded-xl bg-white hover:bg-gray-50 shadow-lg border border-gray-300 focus:outline-none focus:ring-2 transition-all duration-200 hover:shadow-xl" :style="{ '--tw-ring-color': 'var(--primary-color)' }">
          <svg class="w-6 h-6 sm:w-7 sm:h-7" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round" :style="{ color: 'var(--text-color-main)' }">
            <path v-if="!open" d="M4 6h16M4 12h16M4 18h16" />
            <path v-else d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    </div>
    <transition name="fade">
      <nav v-if="open" class="md:hidden bg-white border-t border-gray-200 px-4 sm:px-6 pb-4 pt-2 flex flex-col gap-2 sm:gap-3 shadow-xl" :style="{ borderColor: 'var(--border-primary)' }">
        <template v-for="link in headerContent.navigation_links" :key="link.text">
          <router-link 
            v-if="link.type === 'router-link'" 
            :to="link.url" 
            class="py-3 sm:py-4 px-3 sm:px-4 rounded-lg transition-all duration-200 text-sm sm:text-base font-medium border border-transparent" 
            :style="{ 
              color: 'var(--text-color-main)',
              '--tw-ring-color': 'var(--primary-color)'
            }"
            :class="{ 
              'bg-blue-50 border-blue-200': $route.path === link.url,
              'hover:bg-blue-50 hover:border-blue-200': $route.path !== link.url
            }"
            @click="open = false"
          >
            {{ link.text }}
          </router-link>
          <a 
            v-else-if="link.type === 'anchor'" 
            :href="link.url" 
            class="py-3 sm:py-4 px-3 sm:px-4 rounded-lg transition-all duration-200 text-sm sm:text-base font-medium border border-transparent hover:bg-blue-50 hover:border-blue-200" 
            :style="{ color: 'var(--text-color-main)' }"
            @click="open = false"
          >
            {{ link.text }}
          </a>
          <a 
            v-else 
            :href="link.url" 
            target="_blank" 
            rel="noopener noreferrer"
            class="py-3 sm:py-4 px-3 sm:px-4 rounded-lg transition-all duration-200 text-sm sm:text-base font-medium border border-transparent hover:bg-blue-50 hover:border-blue-200" 
            :style="{ color: 'var(--text-color-main)' }"
            @click="open = false"
          >
            {{ link.text }}
          </a>
        </template>
      </nav>
    </transition>
  </header>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const open = ref(false)
const headerContent = ref({
  title: 'Архитектор Иван Иванов',
  subtitle: '',
  navigation_links: [
    { text: 'Обо мне', url: '/', type: 'router-link' },
    { text: 'Проекты', url: '/projects', type: 'router-link' },
    { text: 'Контакты', url: '#contacts', type: 'anchor' }
  ]
})

const loadHeaderContent = async () => {
  try {
    const response = await axios.get('/api/header.php?section=header')
    if (response.data) {
      headerContent.value = response.data
    }
  } catch (error) {
    console.error('Ошибка загрузки контента шапки:', error)
    // Используем значения по умолчанию если не удалось загрузить
  }
}

onMounted(() => {
  loadHeaderContent()
})
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
