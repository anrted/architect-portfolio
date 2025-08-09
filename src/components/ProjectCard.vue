<template>
  <router-link
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
</template>

<script setup>
const props = defineProps({
  project: {
    type: Object,
    required: true
  }
})
</script>
