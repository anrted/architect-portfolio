<template>
  <header class="fixed top-0 left-0 w-full z-50 bg-white/80 backdrop-blur shadow-md border-b border-gray-200">
    <div class="max-w-6xl mx-auto px-4 py-3 flex justify-between items-center">
      <h1 class="text-2xl md:text-3xl font-extrabold tracking-tight text-blue-700 drop-shadow-sm select-none">
        Архитектор <span class="text-gray-800">Иван Иванов</span>
      </h1>
      <nav class="hidden md:flex gap-8 text-lg font-medium">
        <router-link to="/" class="transition text-gray-700 hover:text-blue-600 hover:underline underline-offset-8">Обо мне</router-link>
        <router-link to="/projects" class="transition text-gray-700 hover:text-blue-600 hover:underline underline-offset-8">Проекты</router-link>
        <a href="#contacts" class="transition text-gray-700 hover:text-blue-600 hover:underline underline-offset-8">Контакты</a>
      </nav>
      <div class="md:hidden">
        <button @click="open = !open" class="p-2 rounded focus:outline-none focus:ring-2 focus:ring-blue-400">
          <svg class="w-7 h-7 text-blue-700" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
            <path v-if="!open" d="M4 6h16M4 12h16M4 18h16" />
            <path v-else d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    </div>
    <transition name="fade">
      <nav v-if="open" class="md:hidden bg-white border-t border-gray-200 px-4 pb-4 pt-2 flex flex-col gap-3 shadow">
        <router-link to="/" class="py-2 px-2 rounded hover:bg-blue-50 transition" @click="open = false">Обо мне</router-link>
        <router-link to="/projects" class="py-2 px-2 rounded hover:bg-blue-50 transition" @click="open = false">Проекты</router-link>
        <a href="#contacts" class="py-2 px-2 rounded hover:bg-blue-50 transition" @click="open = false">Контакты</a>
      </nav>
    </transition>
  </header>
</template>

<script setup>
import { ref } from 'vue'
const open = ref(false)
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
