

<script setup>
import Header from './components/Header.vue'
import About from './components/About.vue'
import Projects from './components/Projects.vue'
import Gallery from './components/Gallery.vue'
import Steps from './components/Steps.vue'
import Reviews from './components/Reviews.vue'
import Contacts from './components/Contacts.vue'
</script>


<template>
  <div class="min-h-screen bg-gradient-to-br from-white via-blue-50 to-blue-100 text-gray-900 font-sans antialiased">
    <Header />
    <main class="max-w-6xl mx-auto px-4 pt-32 pb-10">
      <router-view />
    </main>
    <footer class="bg-white/80 border-t border-gray-200 mt-10">
      <div class="max-w-6xl mx-auto px-4 py-6 text-center text-gray-500 text-sm tracking-wide">
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
