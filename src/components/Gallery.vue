<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const projects = ref([])
const loading = ref(true)

onMounted(async () => {
  try {
    const res = await axios.get('/api/projects.php')
    if (Array.isArray(res.data)) {
      // Только проекты с изображением, ограничиваем до 6 для галереи
      projects.value = res.data.filter(p => p.image_url).slice(0, 6)
    } else {
      projects.value = []
    }
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <section id="gallery" class="mb-20">
    <!-- Заголовок -->
    <div class="text-center mb-16">
      <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6">Галерея работ</h2>
      <p class="text-xl text-gray-600 max-w-2xl mx-auto">
        Избранные проекты, демонстрирующие разнообразие архитектурных решений
      </p>
    </div>

    <!-- Галерея -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
      <template v-if="loading">
        <div v-for="n in 6" :key="n" class="group bg-white rounded-2xl shadow-lg overflow-hidden animate-pulse">
          <div class="h-64 bg-gradient-to-r from-gray-200 to-gray-300"></div>
          <div class="p-6">
            <div class="h-6 bg-gray-200 rounded w-2/3 mb-2"></div>
            <div class="h-4 bg-gray-100 rounded w-full"></div>
          </div>
        </div>
      </template>
      <template v-else>
        <router-link 
          v-for="(project, index) in projects" 
          :key="project.id"
          :to="`/projects/${project.id}`"
          class="group bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3 hover:scale-[1.02] border border-gray-100"
          :style="`animation-delay: ${index * 100}ms`"
        >
          <!-- Изображение с эффектами -->
          <div class="relative h-64 overflow-hidden">
            <img 
              :src="project.image_url" 
              :alt="project.title"
              class="w-full h-full object-cover transition-all duration-700 group-hover:scale-110 group-hover:brightness-110"
              loading="lazy"
            />
            <!-- Оверлей при ховере -->
            <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            
            <!-- Иконка просмотра -->
            <div class="absolute top-4 right-4 w-10 h-10 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 transform scale-75 group-hover:scale-100">
              <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
              </svg>
            </div>

            <!-- Название проекта на изображении -->
            <div class="absolute bottom-0 left-0 right-0 p-6 text-white transform translate-y-full group-hover:translate-y-0 transition-transform duration-300">
              <h3 class="text-xl font-bold mb-2 drop-shadow-lg">{{ project.title }}</h3>
              <p class="text-sm opacity-90 drop-shadow">{{ project.description?.substring(0, 80) }}{{ project.description?.length > 80 ? '...' : '' }}</p>
            </div>
          </div>

          <!-- Информация о проекте -->
          <div class="p-6 group-hover:bg-blue-50 transition-colors duration-300">
            <h3 class="text-xl font-bold text-gray-900 mb-2 group-hover:text-blue-700 transition-colors">
              {{ project.title }}
            </h3>
            <p class="text-gray-600 text-sm leading-relaxed group-hover:text-gray-700">
              {{ project.description?.substring(0, 100) }}{{ project.description?.length > 100 ? '...' : '' }}
            </p>
            
            <!-- Тег типа проекта (если есть в данных) -->
            <div class="mt-4 flex items-center justify-between">
              <span class="text-xs px-3 py-1 bg-blue-100 text-blue-600 rounded-full font-medium">
                Архитектура
              </span>
              <svg class="w-5 h-5 text-blue-600 transform group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path>
              </svg>
            </div>
          </div>
        </router-link>
        
        <!-- Пустое состояние -->
        <div v-if="!projects.length" class="col-span-full text-center py-16">
          <svg class="w-16 h-16 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
          </svg>
          <p class="text-gray-500 text-lg">Проекты скоро появятся</p>
        </div>
      </template>
    </div>

    <!-- Кнопка "Смотреть все проекты" -->
    <div class="text-center mt-12" v-if="projects.length > 0">
      <router-link 
        to="/projects" 
        class="inline-flex items-center px-8 py-4 bg-blue-600 text-white font-medium rounded-xl shadow-lg hover:bg-blue-700 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
      >
        <span>Смотреть все проекты</span>
        <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path>
        </svg>
      </router-link>
    </div>
  </section>
</template>

<style scoped>
@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.group {
  animation: slideInUp 0.6s ease-out forwards;
  opacity: 0;
}

.group:nth-child(1) { animation-delay: 0ms; }
.group:nth-child(2) { animation-delay: 100ms; }
.group:nth-child(3) { animation-delay: 200ms; }
.group:nth-child(4) { animation-delay: 300ms; }
.group:nth-child(5) { animation-delay: 400ms; }
.group:nth-child(6) { animation-delay: 500ms; }
</style>
