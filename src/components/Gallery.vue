<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
const projects = ref([])
const loading = ref(true)

onMounted(async () => {
  try {
    const res = await axios.get('/api/projects.php')
    if (Array.isArray(res.data)) {
      // Показываем только 4 последних проекта для галереи
      projects.value = res.data.slice(0, 4)
    } else {
      projects.value = []
    }
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <section id="gallery" class="mb-8 sm:mb-12 md:mb-16 lg:mb-20">
    <!-- Заголовок -->
    <div class="text-center mb-8 sm:mb-12 md:mb-16">
      <h2 class="text-2xl sm:text-3xl md:text-4xl lg:text-5xl font-bold mb-4 sm:mb-6" :style="{ color: 'var(--text-color-main)' }">Галерея работ</h2>
      <p class="text-base sm:text-lg md:text-xl max-w-2xl mx-auto px-4 sm:px-6" :style="{ color: 'var(--text-color-light)' }">
        Избранные проекты, демонстрирующие разнообразие архитектурных решений
      </p>
    </div>

    <!-- Галерея -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6 md:gap-8">
      <template v-if="loading">
        <div v-for="n in 4" :key="n" class="group bg-white rounded-xl sm:rounded-2xl shadow-lg overflow-hidden animate-pulse" :style="{ borderColor: 'var(--border-primary)' }">
          <div class="h-48 sm:h-56 md:h-64" :style="{ background: `linear-gradient(to right, var(--border-primary), var(--border-secondary))` }"></div>
          <div class="p-4 sm:p-6">
            <div class="h-4 sm:h-6 rounded w-2/3 mb-2" :style="{ backgroundColor: 'var(--border-primary)' }"></div>
            <div class="h-3 sm:h-4 rounded w-full" :style="{ backgroundColor: 'var(--border-secondary)' }"></div>
          </div>
        </div>
      </template>
      <template v-else>
        <router-link 
          v-for="(project, index) in projects" 
          :key="project.id"
          :to="`/projects/${project.id}`"
          class="group bg-white rounded-xl sm:rounded-2xl shadow-lg overflow-hidden hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-2 sm:hover:-translate-y-3 hover:scale-[1.02]"
          :style="`animation-delay: ${index * 100}ms; borderColor: var(--border-primary)`"
        >
          <!-- Изображение с эффектами -->
          <div class="relative h-48 sm:h-56 md:h-64 overflow-hidden">
            <img 
              v-if="project.image_url && project.image_url.trim() !== ''"
              :src="project.image_url" 
              :alt="project.title"
              class="w-full h-full object-cover transition-all duration-700 group-hover:scale-110 group-hover:brightness-110"
              loading="lazy"
            />
            <div v-else class="w-full h-full flex items-center justify-center" :style="{ background: `linear-gradient(135deg, var(--border-primary), var(--border-secondary))` }">
              <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--text-color-light)' }">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 002 2z"></path>
              </svg>
            </div>
            <!-- Оверлей при ховере -->
            <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            
            <!-- Иконка просмотра -->
            <div class="absolute top-3 sm:top-4 right-3 sm:right-4 w-8 h-8 sm:w-10 sm:h-10 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 transform scale-75 group-hover:scale-100">
              <svg class="w-4 h-4 sm:w-5 sm:h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
              </svg>
            </div>

            <!-- Название проекта на изображении -->
            <div class="absolute bottom-0 left-0 right-0 p-4 sm:p-6 text-white transform translate-y-full group-hover:translate-y-0 transition-transform duration-300">
              <h3 class="text-lg sm:text-xl font-bold mb-2 drop-shadow-lg">{{ project.title }}</h3>
              <p class="text-xs sm:text-sm opacity-90 drop-shadow">{{ project.description?.substring(0, 80) }}{{ project.description?.length > 80 ? '...' : '' }}</p>
            </div>
          </div>

          <!-- Информация о проекте -->
          <div class="p-4 sm:p-6 transition-colors duration-300" :style="{ backgroundColor: 'var(--background-primary)' }">
            <h3 class="text-lg sm:text-xl font-bold mb-2 transition-colors" :style="{ color: 'var(--text-color-main)' }">
              {{ project.title }}
            </h3>
            <p class="text-sm leading-relaxed transition-colors" :style="{ color: 'var(--text-color-light)' }">
              {{ project.description?.substring(0, 100) }}{{ project.description?.length > 100 ? '...' : '' }}
            </p>
            
            <!-- Тег типа проекта (если есть в данных) -->
            <div class="mt-4 flex items-center justify-between">
              <span class="text-xs px-2 sm:px-3 py-1 rounded-full font-medium" :style="{ backgroundColor: 'var(--primary-color-light)20', color: 'var(--primary-color)' }">
                Архитектура
              </span>
              <svg class="w-4 h-4 sm:w-5 sm:h-5 transform group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--primary-color)' }">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path>
              </svg>
            </div>
          </div>
        </router-link>
      </template>
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
