<template>
  <div class="space-y-6">
    <!-- Заголовок -->
    <div>
      <h1 class="text-2xl font-bold text-gray-900">Управление компонентами главной страницы</h1>
      <p class="text-gray-600">Настройте видимость и порядок компонентов на главной странице</p>
    </div>

    <!-- Загрузка -->
    <div v-if="loading" class="text-center py-8">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
      <p class="mt-2 text-gray-600">Загрузка компонентов...</p>
    </div>

    <!-- Основной контент -->
    <div v-else>
      <!-- Информация -->
      <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-blue-400" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
            </svg>
          </div>
          <div class="ml-3">
            <h3 class="text-sm font-medium text-blue-800">Как это работает</h3>
            <div class="mt-2 text-sm text-blue-700">
              <p>• Перетаскивайте компоненты для изменения порядка</p>
              <p>• Используйте переключатели для показа/скрытия компонентов</p>
              <p>• Изменения применяются сразу после сохранения</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Список компонентов -->
      <div class="bg-white rounded-lg shadow">
        <div class="p-6 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Компоненты главной страницы</h2>
        </div>
        
        <div class="p-6">
          <div v-if="components.length === 0" class="text-center py-8 text-gray-500">
            Компоненты не найдены
          </div>
          
          <div v-else class="space-y-4">
            <draggable 
              v-model="components" 
              item-key="id"
              @end="onDragEnd"
              class="space-y-4"
              ghost-class="sortable-ghost"
              drag-class="sortable-drag"
            >
              <template #item="{ element: component }">
                <div class="flex items-center justify-between p-4 border border-gray-200 rounded-lg bg-white hover:shadow-md transition-all duration-200 cursor-move">
                  <!-- Drag handle -->
                  <div class="flex items-center space-x-4">
                    <div class="cursor-move text-gray-400 hover:text-gray-600">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8h16M4 16h16"></path>
                      </svg>
                    </div>
                    
                    <!-- Иконка компонента -->
                    <div class="flex-shrink-0">
                      <div class="w-10 h-10 bg-gray-100 rounded-lg flex items-center justify-center">
                        <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
                        </svg>
                      </div>
                    </div>
                    
                    <!-- Информация о компоненте -->
                    <div class="flex-1">
                      <h3 class="font-medium text-gray-900">{{ component.name }}</h3>
                      <p class="text-sm text-gray-600">{{ component.description }}</p>
                      
                    </div>
                  </div>
                  
                  <!-- Переключатель видимости -->
                  <div class="flex items-center space-x-4">
                    <div class="flex items-center">
                      <label class="relative inline-flex items-center cursor-pointer">
                        <input 
                          type="checkbox" 
                          v-model="component.visible"
                          @change="updateComponentVisibility(component)"
                          class="sr-only peer"
                        >
                        <div class="relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
                        <span class="ml-3 text-sm font-medium text-gray-900">
                          {{ component.visible ? 'Видимый' : 'Скрытый' }}
                        </span>
                      </label>
                    </div>
                  </div>
                </div>
              </template>
            </draggable>
          </div>
        </div>
      </div>

      <!-- Кнопки действий -->
      <div class="flex justify-end space-x-4">
        <button
          @click="resetToDefaults"
          class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          Сбросить к значениям по умолчанию
        </button>
        
        <button
          @click="saveComponents"
          :disabled="saving"
          class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span v-if="saving" class="flex items-center">
            <svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Сохранение...
          </span>
          <span v-else>Сохранить изменения</span>
        </button>
      </div>
    </div>

    <!-- Уведомления -->
    <div v-if="message" class="fixed top-4 right-4 z-50">
      <div :class="[
        'px-4 py-3 rounded-lg shadow-lg max-w-sm',
        message.type === 'success' ? 'bg-green-500 text-white' : 'bg-red-500 text-white'
      ]">
        <div class="flex items-center">
          <svg v-if="message.type === 'success'" class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
          </svg>
          <svg v-else class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
          <span>{{ message.text }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import draggable from 'vuedraggable'

const components = ref([])
const loading = ref(true)
const saving = ref(false)
const message = ref(null)

// Загрузка компонентов
const loadComponents = async () => {
  try {
    const response = await axios.get('/api/admin_components.php')
    if (response.data) {
      components.value = response.data
    }
  } catch (error) {
    console.error('Ошибка загрузки компонентов:', error)
    showMessage('Ошибка загрузки компонентов', 'error')
  } finally {
    loading.value = false
  }
}

// Сохранение компонентов
const saveComponents = async () => {
  saving.value = true
  try {
    // Обновляем порядок компонентов
    components.value.forEach((component, index) => {
      component.order = index + 1
    })
    
    const response = await axios.post('/api/admin_components.php', components.value)
    if (response.data.success) {
      showMessage('Компоненты успешно сохранены', 'success')
    } else {
      showMessage('Ошибка сохранения компонентов', 'error')
    }
  } catch (error) {
    console.error('Ошибка сохранения компонентов:', error)
    showMessage('Ошибка сохранения компонентов', 'error')
  } finally {
    saving.value = false
  }
}

// Обновление видимости компонента
const updateComponentVisibility = (component) => {
  console.log(`Компонент ${component.name} ${component.visible ? 'показан' : 'скрыт'}`)
}

// Обработка окончания перетаскивания
const onDragEnd = () => {
  // Обновляем порядок компонентов
  components.value.forEach((component, index) => {
    component.order = index + 1
  })
}

// Сброс к значениям по умолчанию
const resetToDefaults = () => {
  if (confirm('Вы уверены, что хотите сбросить все настройки к значениям по умолчанию?')) {
    components.value = [
      {
        id: 'about',
        name: 'О себе',
        component: 'About',
        visible: true,
        order: 1,
        description: 'Секция с информацией о себе'
      },
      {
        id: 'gallery',
        name: 'Галерея',
        component: 'Gallery',
        visible: true,
        order: 2,
        description: 'Галерея проектов'
      },
      {
        id: 'steps',
        name: 'Этапы работы',
        component: 'Steps',
        visible: true,
        order: 3,
        description: 'Этапы работы над проектами'
      },
      {
        id: 'reviews',
        name: 'Отзывы',
        component: 'Reviews',
        visible: true,
        order: 4,
        description: 'Отзывы клиентов'
      },
      {
        id: 'contacts',
        name: 'Контакты',
        component: 'Contacts',
        visible: true,
        order: 5,
        description: 'Контактная информация'
      }
    ]
    showMessage('Настройки сброшены к значениям по умолчанию', 'success')
  }
}

// Показать сообщение
const showMessage = (text, type = 'success') => {
  message.value = { text, type }
  setTimeout(() => {
    message.value = null
  }, 3000)
}

// Загружаем компоненты при монтировании
onMounted(() => {
  loadComponents()
})
</script>

<style scoped>
.sortable-ghost {
  opacity: 0.5;
  background: #f3f4f6;
  transform: rotate(2deg);
}

.sortable-drag {
  opacity: 0.8;
  background: #ffffff;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  transform: rotate(-2deg);
}

.cursor-move {
  cursor: move;
}
</style>
