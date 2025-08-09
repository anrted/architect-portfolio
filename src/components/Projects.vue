<template>
  <section id="projects" class="mb-16">
    <h2 class="text-3xl font-bold mb-8 text-center tracking-tight" :style="{ color: 'var(--text-color-main)' }">Проекты</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      <template v-if="loading">
        <div v-for="n in 3" :key="n" class="bg-white rounded-xl shadow-lg p-6 animate-pulse flex flex-col gap-4" :style="{ borderColor: 'var(--border-primary)' }">
          <div class="h-48 rounded-lg" :style="{ backgroundColor: 'var(--border-primary)' }"></div>
          <div class="h-6 rounded w-2/3" :style="{ backgroundColor: 'var(--border-primary)' }"></div>
          <div class="h-4 rounded w-full" :style="{ backgroundColor: 'var(--border-secondary)' }"></div>
        </div>
      </template>
      <template v-else>
        <div v-if="error" class="col-span-full text-center py-10" :style="{ color: 'var(--error-color)' }">{{ error }}</div>
        <template v-else>
          <router-link
            v-for="project in projects"
            :key="project.id"
            :to="`/projects/${project.id}`"
            class="bg-white rounded-xl shadow-lg overflow-hidden flex flex-col hover:shadow-2xl transition group focus:outline-none focus:ring-2"
            :style="{ 
              borderColor: 'var(--border-primary)',
              '--tw-ring-color': 'var(--primary-color)'
            }"
            style="text-decoration: none;"
          >
            <div class="relative h-48 flex items-center justify-center" :style="{ backgroundColor: 'var(--background-secondary)' }">
              <img
                v-if="project.image_url && project.image_url.trim() !== ''"
                :src="project.image_url"
                :alt="project.title"
                class="object-cover w-full h-48 transition-opacity duration-500 group-hover:brightness-90" 
                loading="lazy"
              />
              <div v-else class="w-full h-48 flex items-center justify-center" :style="{ background: `linear-gradient(135deg, var(--border-primary), var(--border-secondary))` }">
                <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--text-color-light)' }">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 002 2z"></path>
                </svg>
              </div>
            </div>
            <div class="p-4 flex-1 flex flex-col">
              <h3 class="text-xl font-bold mb-2" :style="{ color: 'var(--text-color-main)' }">{{ project.title }}</h3>
              <p class="flex-1" :style="{ color: 'var(--text-color-light)' }">{{ project.description }}</p>
            </div>
          </router-link>
          <div v-if="!projects.length && !loading" class="col-span-full text-center py-10" :style="{ color: 'var(--text-color-light)' }">Нет проектов</div>
        </template>
      </template>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const projects = ref([])
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  try {
    // Универсальный путь: всегда ищет api относительно корня сайта
    const res = await axios.get('/api/projects.php')
    if (Array.isArray(res.data)) {
      projects.value = res.data
    } else {
      projects.value = []
      error.value = 'Некорректный ответ от API (ожидался массив)';
    }
  } catch (e) {
    if (e.response) {
      error.value = `Ошибка API: ${e.response.status} ${e.response.statusText}`
    } else if (e.request) {
      error.value = 'Нет ответа от сервера. Проверьте доступность API.'
    } else {
      error.value = 'Ошибка: ' + e.message
    }
    projects.value = []
  } finally {
    loading.value = false
  }
})
</script>
