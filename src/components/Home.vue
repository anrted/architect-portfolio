<template>
  <div class="space-y-8 sm:space-y-12 md:space-y-16 lg:space-y-20 animate-fadein">
    <component 
      v-for="component in visibleComponents" 
      :key="component.id"
      :is="component.component"
    />
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import About from './About.vue'
import Gallery from './Gallery.vue'
import Steps from './Steps.vue'
import Reviews from './Reviews.vue'
import Contacts from './Contacts.vue'

// Регистрируем компоненты
const componentMap = {
  About,
  Gallery,
  Steps,
  Reviews,
  Contacts
}

const components = ref([])
const loading = ref(true)

// Получаем только видимые компоненты, отсортированные по порядку
const visibleComponents = computed(() => {
  return components.value
    .filter(component => component.visible)
    .sort((a, b) => a.order - b.order)
    .map(component => ({
      ...component,
      component: componentMap[component.component]
    }))
})

// Загрузка настроек компонентов
const loadComponents = async () => {
  try {
    const response = await axios.get('/api/components.php')
    if (response.data) {
      components.value = response.data
    } else {
      // Значения по умолчанию если API недоступен
      components.value = [
        { id: 'about', component: 'About', visible: true, order: 1 },
        { id: 'gallery', component: 'Gallery', visible: true, order: 2 },
        { id: 'steps', component: 'Steps', visible: true, order: 3 },
        { id: 'reviews', component: 'Reviews', visible: true, order: 4 },
        { id: 'contacts', component: 'Contacts', visible: true, order: 5 }
      ]
    }
  } catch (error) {
    console.error('Ошибка загрузки компонентов:', error)
    // Используем значения по умолчанию при ошибке
    components.value = [
      { id: 'about', component: 'About', visible: true, order: 1 },
      { id: 'gallery', component: 'Gallery', visible: true, order: 2 },
      { id: 'steps', component: 'Steps', visible: true, order: 3 },
      { id: 'reviews', component: 'Reviews', visible: true, order: 4 },
      { id: 'contacts', component: 'Contacts', visible: true, order: 5 }
    ]
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadComponents()
})
</script>

<style scoped>
@keyframes fadein {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: none; }
}
.animate-fadein {
  animation: fadein 0.8s cubic-bezier(.4,0,.2,1);
}
</style>
