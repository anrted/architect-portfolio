<template>
  <div v-if="loading" class="space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <div class="h-8 bg-gray-200 rounded w-64 animate-pulse"></div>
        <div class="h-4 bg-gray-200 rounded w-48 mt-2 animate-pulse"></div>
      </div>
      <div class="h-8 bg-gray-200 rounded w-32 animate-pulse"></div>
    </div>
    
    <div class="bg-white rounded-lg shadow p-6">
      <div class="h-6 bg-gray-200 rounded w-48 mb-4 animate-pulse"></div>
      <div class="space-y-4">
        <div class="h-4 bg-gray-200 rounded w-full animate-pulse"></div>
        <div class="h-4 bg-gray-200 rounded w-3/4 animate-pulse"></div>
        <div class="h-4 bg-gray-200 rounded w-1/2 animate-pulse"></div>
      </div>
    </div>
  </div>
  
  <div v-else class="space-y-6">
    <!-- Заголовок -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">
          {{ isEdit ? 'Редактирование проекта' : 'Создание проекта' }}
        </h1>
        <p class="text-gray-600">{{ isEdit ? 'Изменить данные проекта' : 'Добавить новый проект в портфолио' }}</p>
      </div>
      
      <router-link
        to="/admin/projects"
        class="text-gray-600 hover:text-gray-900 flex items-center space-x-2"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
        </svg>
        <span>Назад к списку</span>
      </router-link>
    </div>
    
    <!-- Ошибки -->
    <div v-if="error" class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
      {{ error }}
    </div>
    
    <!-- Форма -->
    <form @submit.prevent="handleSubmit" class="space-y-6">
      <!-- Основная информация -->
      <div class="bg-white rounded-lg shadow p-6">
        <h2 class="text-lg font-medium text-gray-900 mb-4">Основная информация</h2>
        
        <div class="grid grid-cols-1 gap-6">
          <div>
            <label for="title" class="block text-sm font-medium text-gray-700 mb-2">
              Название проекта *
            </label>
            <input
              id="title"
              v-model="form.title"
              type="text"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              placeholder="Введите название проекта"
            />
          </div>
          
          <div>
            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
              Описание
            </label>
            <textarea
              id="description"
              v-model="form.description"
              rows="3"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              placeholder="Краткое описание проекта"
            ></textarea>
          </div>
          
          <div>
            <label for="image_url" class="block text-sm font-medium text-gray-700 mb-2">
              URL главного изображения
            </label>
            <input
              id="image_url"
              v-model="form.image_url"
              type="url"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              placeholder="https://example.com/image.jpg"
            />
            <div v-if="form.image_url" class="mt-4">
              <p class="text-sm text-gray-600 mb-2">Предварительный просмотр:</p>
              <img :src="form.image_url" alt="Preview" class="w-48 h-32 object-cover rounded-lg border" />
            </div>
          </div>
        </div>
      </div>
      
      <!-- Блоки проекта -->
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-lg font-medium text-gray-900">Содержимое проекта</h2>
          <button
            type="button"
            @click="addBlock"
            class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 flex items-center space-x-2"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
            </svg>
            <span>Добавить блок</span>
          </button>
        </div>
        
        <div v-if="form.blocks.length === 0" class="text-center py-8 text-gray-500">
          <svg class="w-12 h-12 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
          </svg>
          <p>Нет блоков содержимого</p>
          <p class="text-sm">Добавьте изображения или текстовые блоки</p>
        </div>
        
        <div v-else class="space-y-4">
          <div
            v-for="(block, index) in form.blocks"
            :key="index"
            class="border border-gray-200 rounded-lg p-4"
          >
            <div class="flex items-center justify-between mb-4">
              <div class="flex items-center space-x-4">
                <select
                  v-model="block.type"
                  class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="text">Текст</option>
                  <option value="image">Изображение</option>
                </select>
                
                <span class="text-sm text-gray-500">Блок {{ index + 1 }}</span>
              </div>
              
              <div class="flex items-center space-x-2">
                <button
                  v-if="index > 0"
                  type="button"
                  @click="moveBlock(index, -1)"
                  class="text-gray-600 hover:text-gray-900 p-1 rounded"
                  title="Переместить вверх"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"></path>
                  </svg>
                </button>
                
                <button
                  v-if="index < form.blocks.length - 1"
                  type="button"
                  @click="moveBlock(index, 1)"
                  class="text-gray-600 hover:text-gray-900 p-1 rounded"
                  title="Переместить вниз"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                  </svg>
                </button>
                
                <button
                  type="button"
                  @click="removeBlock(index)"
                  class="text-red-600 hover:text-red-800 p-1 rounded"
                  title="Удалить блок"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                  </svg>
                </button>
              </div>
            </div>
            
            <div v-if="block.type === 'text'">
              <textarea
                v-model="block.content"
                rows="4"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Введите текст блока"
              ></textarea>
            </div>
            
            <div v-else-if="block.type === 'image'">
              <input
                v-model="block.content"
                type="url"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="URL изображения"
              />
              <div v-if="block.content" class="mt-4">
                <img :src="block.content" alt="Preview" class="max-w-full h-64 object-cover rounded-lg border" />
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Кнопки -->
      <div class="flex justify-end space-x-4">
        <router-link
          to="/admin/projects"
          class="px-4 py-2 text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200"
        >
          Отмена
        </router-link>
        
        <button
          type="submit"
          :disabled="loading"
          class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {{ loading ? 'Сохранение...' : (isEdit ? 'Сохранить изменения' : 'Создать проект') }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick } from 'vue'
import { useRoute, useRouter, onBeforeRouteUpdate } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const router = useRouter()

const isEdit = computed(() => !!route.params.id)

const form = ref({
  title: '',
  description: '',
  image_url: '',
  blocks: []
})

const loading = ref(false)
const error = ref('')

const addBlock = () => {
  form.value.blocks.push({
    type: 'text',
    content: ''
  })
}

const removeBlock = (index) => {
  form.value.blocks.splice(index, 1)
}

const moveBlock = (index, direction) => {
  const newIndex = index + direction
  if (newIndex >= 0 && newIndex < form.value.blocks.length) {
    const block = form.value.blocks.splice(index, 1)[0]
    form.value.blocks.splice(newIndex, 0, block)
  }
}

const loadProject = async () => {
  if (!isEdit.value) {
    // Очищаем форму для создания нового проекта
    form.value = {
      title: '',
      description: '',
      image_url: '',
      blocks: []
    }
    loading.value = false
    return
  }
  
  loading.value = true
  try {
    const response = await axios.get(`/api/project_full.php?id=${route.params.id}`)
    
    if (response.data && response.data.id) {
      form.value = {
        title: response.data.title || '',
        description: response.data.description || '',
        image_url: response.data.image_url || '',
        blocks: response.data.blocks || []
      }
    } else {
      router.push('/admin/projects')
    }
  } catch (error) {
    console.error('Ошибка загрузки проекта:', error)
    router.push('/admin/projects')
  } finally {
    loading.value = false
  }
}

const handleSubmit = async () => {
  loading.value = true
  error.value = ''
  
  try {
    const data = {
      ...form.value
    }
    
    if (isEdit.value) {
      data.id = route.params.id
      await axios.put('/api/admin_projects.php', data)
    } else {
      await axios.post('/api/admin_projects.php', data)
    }
    
    router.push('/admin/projects')
  } catch (err) {
    error.value = err.response?.data?.error || 'Ошибка при сохранении проекта'
  } finally {
    loading.value = false
  }
}

// Загружаем данные при монтировании компонента
onMounted(() => {
  if (isEdit.value) {
    loading.value = true
  }
  loadProject()
})

// Следим за изменениями маршрута и перезагружаем данные при необходимости
watch(() => route.path, (newPath, oldPath) => {
  if (newPath !== oldPath) {
    nextTick(() => {
      loadProject()
    })
  }
})

// Следим за изменениями ID проекта
watch(() => route.params.id, (newId, oldId) => {
  if (newId !== oldId) {
    nextTick(() => {
      loadProject()
    })
  }
})

// Дополнительная проверка при обновлении маршрута
onBeforeRouteUpdate((to, from) => {
  nextTick(() => {
    loadProject()
  })
})
</script>
