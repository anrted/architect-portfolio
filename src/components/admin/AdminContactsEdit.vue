<template>
  <div class="space-y-6">
    <div v-if="loading">
      <AdminSkeleton />
    </div>
    
    <div v-else>
      <!-- Заголовок -->
      <div class="flex justify-between items-center">
        <h1 class="text-2xl font-bold text-gray-900">Редактирование контактной информации</h1>
        <button
          @click="saveContent"
          :disabled="saving"
          class="bg-blue-600 text-white px-6 py-3 rounded-xl hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2 transition-all duration-200 shadow-lg hover:shadow-xl font-medium"
        >
          <svg v-if="saving" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <span>{{ saving ? 'Сохранение...' : 'Сохранить изменения' }}</span>
        </button>
      </div>

      <!-- Форма редактирования -->
      <div class="bg-white rounded-lg shadow p-6">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <!-- Основная информация -->
          <div class="space-y-6">
            <h2 class="text-xl font-semibold text-gray-900 border-b pb-2">Основная информация</h2>
            
            <!-- Заголовок -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Заголовок секции</label>
              <input
                v-model="form.title"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Свяжитесь со мной"
              />
            </div>

            <!-- Подзаголовок -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Подзаголовок</label>
              <input
                v-model="form.subtitle"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Готов обсудить ваш проект и воплотить архитектурные идеи в реальность"
              />
            </div>
          </div>

          <!-- Контактная информация -->
          <div class="space-y-6">
            <h2 class="text-xl font-semibold text-gray-900 border-b pb-2">Контактная информация</h2>
            
            <div class="space-y-4">
              <div
                v-for="(contact, index) in form.contact_info"
                :key="index"
                class="p-4 border border-gray-200 rounded-lg"
              >
                <div class="flex items-center justify-between mb-3">
                  <span class="text-sm font-medium text-gray-700">Контакт {{ index + 1 }}</span>
                  <button
                    @click="removeContact(index)"
                    class="text-gray-600 hover:text-gray-800 p-2 rounded-lg hover:bg-gray-100 bg-white border border-gray-200 shadow-sm hover:shadow-md transition-all duration-200"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                  </button>
                </div>
                
                <div class="grid grid-cols-2 gap-3">
                  <div>
                    <label class="block text-xs font-medium text-gray-700 mb-1">Тип</label>
                    <select
                      v-model="contact.type"
                      class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    >
                      <option value="email">Email</option>
                      <option value="phone">Телефон</option>
                      <option value="address">Адрес</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-xs font-medium text-gray-700 mb-1">Название</label>
                    <input
                      v-model="contact.label"
                      type="text"
                      class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                      placeholder="Email"
                    />
                  </div>
                </div>
                
                <div class="mt-3">
                  <label class="block text-xs font-medium text-gray-700 mb-1">Значение</label>
                  <textarea
                    v-model="contact.value"
                    rows="2"
                    class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    :placeholder="contact.type === 'email' ? 'ivan.architect@email.com' : contact.type === 'phone' ? '+7 (999) 123-45-67' : 'г. Москва, ул. Архитектурная, 12'"
                  ></textarea>
                </div>
              </div>
              
              <button
                @click="addContact"
                class="w-full py-3 px-4 border-2 border-dashed border-gray-300 rounded-xl text-gray-500 hover:border-gray-400 hover:text-gray-700 transition-all duration-200 hover:bg-gray-50 font-medium bg-white"
              >
                + Добавить контакт
              </button>
            </div>
          </div>
        </div>

        <!-- Социальные сети -->
        <div class="mt-8">
          <h2 class="text-xl font-semibold text-gray-900 border-b pb-2 mb-4">Социальные сети</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div
              v-for="(social, index) in form.social_links"
              :key="index"
              class="p-4 border border-gray-200 rounded-lg"
            >
              <div class="flex items-center justify-between mb-3">
                <span class="text-sm font-medium text-gray-700">Соцсеть {{ index + 1 }}</span>
                <button
                  @click="removeSocial(index)"
                  class="text-gray-600 hover:text-gray-800 p-2 rounded-lg hover:bg-gray-100 bg-white border border-gray-200 shadow-sm hover:shadow-md transition-all duration-200"
                >
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                  </svg>
                </button>
              </div>
              
              <div class="grid grid-cols-2 gap-3">
                <div>
                  <label class="block text-xs font-medium text-gray-700 mb-1">Платформа</label>
                  <select
                    v-model="social.platform"
                    class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  >
                    <option value="twitter">Twitter</option>
                    <option value="facebook">Facebook</option>
                    <option value="linkedin">LinkedIn</option>
                    <option value="instagram">Instagram</option>
                    <option value="youtube">YouTube</option>
                    <option value="telegram">Telegram</option>
                  </select>
                </div>
                <div>
                  <label class="block text-xs font-medium text-gray-700 mb-1">URL</label>
                  <input
                    v-model="social.url"
                    type="url"
                    class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="https://..."
                  />
                </div>
              </div>
            </div>
          </div>
          
          <button
            @click="addSocial"
            class="w-full mt-4 py-3 px-4 border-2 border-dashed border-gray-300 rounded-xl text-gray-500 hover:border-gray-400 hover:text-gray-700 transition-all duration-200 hover:bg-gray-50 font-medium bg-white"
          >
            + Добавить социальную сеть
          </button>
        </div>

        <!-- Время работы -->
        <div class="mt-8">
          <h2 class="text-xl font-semibold text-gray-900 border-b pb-2 mb-4">Время работы</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div
              v-for="(hours, index) in form.working_hours"
              :key="index"
              class="p-4 border border-gray-200 rounded-lg"
            >
              <div class="flex items-center justify-between mb-3">
                <span class="text-sm font-medium text-gray-700">Время работы {{ index + 1 }}</span>
                <button
                  @click="removeWorkingHours(index)"
                  class="text-gray-600 hover:text-gray-800 p-2 rounded-lg hover:bg-gray-100 bg-white border border-gray-200 shadow-sm hover:shadow-md transition-all duration-200"
                >
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                  </svg>
                </button>
              </div>
              
              <div class="grid grid-cols-2 gap-3">
                <div>
                  <label class="block text-xs font-medium text-gray-700 mb-1">Дни</label>
                  <input
                    v-model="hours.days"
                    type="text"
                    class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="Пн-Пт"
                  />
                </div>
                <div>
                  <label class="block text-xs font-medium text-gray-700 mb-1">Часы</label>
                  <input
                    v-model="hours.hours"
                    type="text"
                    class="w-full px-2 py-1 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="9:00 - 18:00"
                  />
                </div>
              </div>
            </div>
          </div>
          
          <button
            @click="addWorkingHours"
            class="w-full mt-4 py-3 px-4 border-2 border-dashed border-gray-300 rounded-xl text-gray-500 hover:border-gray-400 hover:text-gray-700 transition-all duration-200 hover:bg-gray-50 font-medium bg-white"
          >
            + Добавить время работы
          </button>
        </div>
      </div>

      <!-- Предварительный просмотр -->
      <div class="bg-white rounded-lg shadow p-6">
        <h2 class="text-xl font-semibold text-gray-900 border-b pb-2 mb-4">Предварительный просмотр</h2>
        <div class="bg-gradient-to-br from-blue-50 via-white to-blue-100 rounded-lg p-6">
          <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">{{ form.title || 'Свяжитесь со мной' }}</h1>
            <p class="text-lg text-gray-600">{{ form.subtitle || 'Готов обсудить ваш проект...' }}</p>
          </div>
          
          <div class="grid md:grid-cols-2 gap-8">
            <!-- Контактная информация -->
            <div class="bg-white rounded-lg p-6 shadow">
              <h3 class="text-xl font-bold text-gray-900 mb-4">Контактная информация</h3>
              <div class="space-y-4">
                <div
                  v-for="contact in form.contact_info"
                  :key="contact.type"
                  class="flex items-start space-x-3"
                >
                  <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
                    <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                    </svg>
                  </div>
                  <div>
                    <h4 class="font-semibold text-gray-900">{{ contact.label || 'Контакт' }}</h4>
                    <p class="text-blue-600">{{ contact.value || 'Значение' }}</p>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Время работы -->
            <div class="bg-white rounded-lg p-6 shadow">
              <h3 class="text-xl font-bold text-gray-900 mb-4">Время работы</h3>
              <div class="space-y-2">
                <div
                  v-for="hours in form.working_hours"
                  :key="hours.days"
                  class="flex justify-between"
                >
                  <span class="font-medium text-gray-900">{{ hours.days || 'Дни' }}</span>
                  <span class="text-gray-600">{{ hours.hours || 'Часы' }}</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Социальные сети -->
          <div class="mt-6 bg-white rounded-lg p-6 shadow">
            <h3 class="text-xl font-bold text-gray-900 mb-4">Социальные сети</h3>
            <div class="flex space-x-4">
              <div
                v-for="social in form.social_links"
                :key="social.platform"
                class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center text-white"
              >
                <span class="text-xs font-bold">{{ social.platform || 'SOC' }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue'
import { useRoute, onBeforeRouteUpdate } from 'vue-router'
import axios from 'axios'
import AdminSkeleton from './AdminSkeleton.vue'

const route = useRoute()

const form = ref({
  section_name: 'contacts',
  title: '',
  subtitle: '',
  contact_info: [],
  social_links: [],
  working_hours: []
})

const loading = ref(true)
const saving = ref(false)
const error = ref('')

const loadContent = async () => {
  try {
    const response = await axios.get('/api/admin_contacts.php')
    if (response.data) {
      form.value = response.data
    } else {
      // Используем значения по умолчанию если данные не найдены
      form.value = {
        title: 'Свяжитесь со мной',
        subtitle: 'Готов обсудить ваш проект и воплотить архитектурные идеи в реальность',
        contact_info: [
          { type: 'email', label: 'Email', value: 'ivan.architect@email.com' },
          { type: 'phone', label: 'Телефон', value: '+7 (999) 123-45-67' },
          { type: 'address', label: 'Адрес', value: 'г. Москва, ул. Архитектурная, 12' }
        ],
        social_links: [
          { platform: 'telegram', url: 'https://t.me/ivan_architect' },
          { platform: 'instagram', url: 'https://instagram.com/ivan_architect' }
        ],
        working_hours: [
          { days: 'Пн-Пт', hours: '9:00 - 18:00' },
          { days: 'Сб-Вс', hours: 'По договоренности' }
        ]
      }
    }
  } catch (error) {
    console.error('Ошибка загрузки контента:', error)
    // Используем значения по умолчанию при ошибке
    form.value = {
      title: 'Свяжитесь со мной',
      subtitle: 'Готов обсудить ваш проект и воплотить архитектурные идеи в реальность',
      contact_info: [
        { type: 'email', label: 'Email', value: 'ivan.architect@email.com' },
        { type: 'phone', label: 'Телефон', value: '+7 (999) 123-45-67' },
        { type: 'address', label: 'Адрес', value: 'г. Москва, ул. Архитектурная, 12' }
      ],
      social_links: [
        { platform: 'telegram', url: 'https://t.me/ivan_architect' },
        { platform: 'instagram', url: 'https://instagram.com/ivan_architect' }
      ],
      working_hours: [
        { days: 'Пн-Пт', hours: '9:00 - 18:00' },
        { days: 'Сб-Вс', hours: 'По договоренности' }
      ]
    }
  } finally {
    loading.value = false
  }
}

const addContact = () => {
  form.value.contact_info.push({ type: 'email', label: '', value: '', icon: 'email' })
}

const removeContact = (index) => {
  form.value.contact_info.splice(index, 1)
}

const addSocial = () => {
  form.value.social_links.push({ platform: 'twitter', url: '', icon: 'twitter' })
}

const removeSocial = (index) => {
  form.value.social_links.splice(index, 1)
}

const addWorkingHours = () => {
  form.value.working_hours.push({ days: '', hours: '' })
}

const removeWorkingHours = (index) => {
  form.value.working_hours.splice(index, 1)
}

const saveContent = async () => {
  saving.value = true
  error.value = ''
  
  try {
    await axios.put('/api/admin_contacts.php', form.value)
    alert('Контент успешно сохранен!')
  } catch (err) {
    error.value = err.response?.data?.error || 'Ошибка при сохранении контента'
    alert(error.value)
  } finally {
    saving.value = false
  }
}

// Загружаем данные при монтировании компонента
onMounted(() => {
  loadContent()
})

// Следим за изменениями маршрута и перезагружаем данные при необходимости
watch(() => route.path, (newPath, oldPath) => {
  if (newPath === '/admin/contacts' && newPath !== oldPath) {
    nextTick(() => {
      loadContent()
    })
  }
})

// Дополнительная проверка при обновлении маршрута
onBeforeRouteUpdate((to, from) => {
  if (to.path === '/admin/contacts') {
    nextTick(() => {
      loadContent()
    })
  }
})
</script>
