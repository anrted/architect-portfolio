<template>
  <!-- Loading state -->
  <section v-if="loading" class="max-w-5xl mx-auto py-8 px-4">
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden animate-pulse">
      <!-- Header skeleton -->
      <div class="h-80 bg-gradient-to-r from-gray-200 to-gray-300"></div>
      <div class="p-8">
        <div class="h-10 bg-gray-200 rounded w-2/3 mb-4"></div>
        <div class="h-6 bg-gray-100 rounded w-1/4 mb-8"></div>
        <div class="space-y-4">
          <div class="h-4 bg-gray-100 rounded w-full"></div>
          <div class="h-4 bg-gray-100 rounded w-5/6"></div>
          <div class="h-4 bg-gray-100 rounded w-4/5"></div>
        </div>
      </div>
    </div>
  </section>

  <!-- Project content -->
  <section v-else-if="project" class="max-w-5xl mx-auto py-8 px-4">
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
      <!-- Hero image if available -->
      <div v-if="project.image_url" class="relative h-80 md:h-96 overflow-hidden">
        <img 
          :src="project.image_url" 
          :alt="project.title"
          class="w-full h-full object-cover"
          loading="lazy"
        />
        <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
        <div class="absolute bottom-0 left-0 p-8 text-white">
          <h1 class="text-4xl md:text-5xl font-bold mb-4" :style="{ color: 'var(--text-color-main)' }">{{ project.title }}</h1>
        </div>
      </div>

      <!-- Content -->
      <div class="p-8 md:p-12">
        <!-- Title if no hero image -->
        <div v-if="!project.image_url" class="mb-8">
          <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">{{ project.title }}</h1>
        </div>

        <!-- Navigation -->
        <div class="mb-8">
          <router-link 
            to="/projects" 
            class="inline-flex items-center font-medium transition-colors group"
            :style="{ color: 'var(--primary-color)' }"
          >
            <svg class="w-5 h-5 mr-2 transform group-hover:-translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
            </svg>
            Назад к проектам
          </router-link>
        </div>

        <!-- Project description if available -->
        <div v-if="project.description" class="mb-12">
          <div class="prose prose-lg max-w-none leading-relaxed" :style="{ color: 'var(--text-color-main)' }">
            {{ project.description }}
          </div>
        </div>

        <!-- Content blocks -->
        <div v-if="project.blocks && project.blocks.length > 0" class="space-y-12">
          <template v-for="(block, idx) in project.blocks" :key="idx">
            <!-- Image block -->
            <div v-if="block.type === 'image'" class="relative">
              <img 
                :src="block.content" 
                :alt="`Изображение ${idx + 1}`"
                class="w-full rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300" 
                loading="lazy" 
              />
            </div>
            
            <!-- Text block -->
            <div v-else-if="block.type === 'text'" class="prose prose-lg max-w-none">
              <div class="leading-relaxed whitespace-pre-line text-lg" :style="{ color: 'var(--text-color-main)' }">
                {{ block.content }}
              </div>
            </div>
          </template>
        </div>

        <!-- Empty state -->
        <div v-else class="text-center py-16">
          <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--text-color-light)' }">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
          </svg>
          <p class="text-lg" :style="{ color: 'var(--text-color-light)' }">Контент проекта пока не добавлен</p>
        </div>
      </div>
    </div>

    <!-- Related actions -->
    <div class="mt-8 flex justify-center">
      <router-link 
        to="/projects" 
        class="px-8 py-3 rounded-lg font-medium transition-colors flex items-center space-x-2 shadow-lg hover:shadow-xl"
        :style="{ backgroundColor: 'var(--primary-color)', color: 'var(--primary-color-contrast)' }"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
        </svg>
        <span>Посмотреть другие проекты</span>
      </router-link>
    </div>
  </section>

  <!-- Not found state -->
  <section v-else class="max-w-2xl mx-auto py-16 px-4 text-center">
    <div class="bg-white rounded-2xl shadow-lg p-12">
      <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" :style="{ color: 'var(--text-color-light)' }">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
      </svg>
      <h2 class="text-2xl font-bold mb-2" :style="{ color: 'var(--text-color-main)' }">Проект не найден</h2>
      <p class="mb-6" :style="{ color: 'var(--text-color-light)' }">Возможно, проект был удален или ссылка неверная</p>
      <router-link 
        to="/projects" 
        class="inline-flex items-center font-medium"
        :style="{ color: 'var(--primary-color)' }"
      >
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
        </svg>
        Вернуться к проектам
      </router-link>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const project = ref(null)
const loading = ref(true)

onMounted(async () => {
  try {
    const res = await axios.get(`/api/project_full.php?id=${route.params.id}`)
    if (res.data && res.data.id) {
      project.value = res.data
    }
  } finally {
    loading.value = false
  }
})
</script>
