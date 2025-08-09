

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import Header from './components/Header.vue'
import About from './components/About.vue'
import Projects from './components/Projects.vue'
import Gallery from './components/Gallery.vue'
import Steps from './components/Steps.vue'
import Reviews from './components/Reviews.vue'
import Contacts from './components/Contacts.vue'

const route = useRoute()

// Проверяем, находимся ли мы в админке
const isAdminRoute = computed(() => {
  return route.path.startsWith('/admin')
})
</script>

<template>
  <div class="min-h-screen text-gray-900 font-sans antialiased" :style="{ background: `linear-gradient(135deg, var(--background-primary), var(--primary-color-light)10, var(--background-primary))` }">
    <!-- Скрываем основной Header в админке -->
    <Header v-if="!isAdminRoute" />
    <main class="max-w-6xl mx-auto px-4 sm:px-6 pt-24 sm:pt-28 md:pt-32 pb-6 sm:pb-8 md:pb-10" :class="{ 'pt-0': isAdminRoute }">
      <router-view />
    </main>
    <footer class="bg-white/80 border-t border-gray-200 mt-6 sm:mt-8 md:mt-10" v-if="!isAdminRoute" :style="{ borderColor: 'var(--border-primary)' }">
      <div class="max-w-6xl mx-auto px-4 sm:px-6 py-4 sm:py-6 text-center text-xs sm:text-sm tracking-wide" :style="{ color: 'var(--text-color-light)' }">
        &copy; 2025 Архитектор Иван Иванов. Все права защищены.
      </div>
    </footer>
  </div>
</template>

<style>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
