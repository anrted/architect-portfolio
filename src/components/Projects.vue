<template>
  <section id="projects" class="mb-16">
    <h2 class="text-3xl font-bold mb-8 text-center tracking-tight">Проекты</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      <template v-if="loading">
        <div v-for="n in 3" :key="n" class="bg-white rounded-xl shadow-lg p-6 animate-pulse flex flex-col gap-4">
          <div class="h-48 bg-gray-200 rounded-lg"></div>
          <div class="h-6 bg-gray-200 rounded w-2/3"></div>
          <div class="h-4 bg-gray-100 rounded w-full"></div>
        </div>
      </template>
      <template v-else>
        <div v-if="error" class="col-span-full text-center text-red-500 py-10">{{ error }}</div>
        <template v-else>
          <router-link
            v-for="project in projects"
            :key="project.id"
            :to="`/projects/${project.id}`"
            class="bg-white rounded-xl shadow-lg overflow-hidden flex flex-col hover:shadow-2xl transition group focus:outline-none focus:ring-2 focus:ring-blue-400"
            style="text-decoration: none;"
          >
            <div class="relative h-48 bg-gray-100 flex items-center justify-center">
              <img
                v-if="project.image_url"
                :src="project.image_url"
                :alt="project.title"
                class="object-cover w-full h-48 transition-opacity duration-500 group-hover:brightness-90" 
                loading="lazy"
                @load="e => e.target.classList.add('opacity-100')"
                style="opacity:0;"
              />
              <span v-else class="text-gray-400">Нет изображения</span>
            </div>
            <div class="p-4 flex-1 flex flex-col">
              <h3 class="text-xl font-bold mb-2 group-hover:text-blue-700">{{ project.title }}</h3>
              <p class="text-gray-600 flex-1">{{ project.description }}</p>
            </div>
          </router-link>
          <div v-if="!projects.length && !loading" class="col-span-full text-center text-gray-400 py-10">Нет проектов</div>
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
