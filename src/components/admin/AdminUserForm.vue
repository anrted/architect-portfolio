<template>
  <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg p-6 max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
      <div class="flex justify-between items-center mb-6">
        <h3 class="text-lg font-medium text-gray-900">
          {{ mode === 'create' ? 'Создать пользователя' : 'Редактировать пользователя' }}
        </h3>
        <button
          @click="$emit('close')"
          class="text-gray-400 hover:text-gray-600"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <form @submit.prevent="handleSubmit" class="space-y-6">
        <!-- Основная информация -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label for="username" class="block text-sm font-medium text-gray-700 mb-2">
              Логин *
            </label>
            <input
              id="username"
              v-model="form.username"
              type="text"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              placeholder="Введите логин"
            />
          </div>

          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
              Email *
            </label>
            <input
              id="email"
              v-model="form.email"
              type="email"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              placeholder="Введите email"
            />
          </div>

          <div>
            <label for="full_name" class="block text-sm font-medium text-gray-700 mb-2">
              Полное имя *
            </label>
            <input
              id="full_name"
              v-model="form.full_name"
              type="text"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              placeholder="Введите полное имя"
            />
          </div>

          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
              Пароль {{ mode === 'edit' ? '(оставьте пустым, чтобы не изменять)' : '*' }}
            </label>
            <input
              id="password"
              v-model="form.password"
              type="password"
              :required="mode === 'create'"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              :placeholder="mode === 'create' ? 'Введите пароль' : 'Введите новый пароль'"
            />
          </div>

          <div>
            <label for="role" class="block text-sm font-medium text-gray-700 mb-2">
              Роль
            </label>
            <select
              id="role"
              v-model="form.role"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="editor">Редактор</option>
              <option value="admin">Администратор</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Статус
            </label>
            <div class="flex items-center">
              <input
                id="is_active"
                v-model="form.is_active"
                type="checkbox"
                class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
              />
              <label for="is_active" class="ml-2 block text-sm text-gray-900">
                Активен
              </label>
            </div>
          </div>
        </div>

        <!-- Права доступа -->
        <div class="border-t border-gray-200 pt-6">
          <h4 class="text-lg font-medium text-gray-900 mb-4">Права доступа</h4>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Проекты -->
            <div class="bg-gray-50 p-4 rounded-lg">
              <h5 class="font-medium text-gray-900 mb-3">Проекты</h5>
              <div class="space-y-2">
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.projects.read"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Просмотр</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.projects.create"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Создание</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.projects.update"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Редактирование</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.projects.delete"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Удаление</span>
                </label>
              </div>
            </div>

            <!-- Главная страница -->
            <div class="bg-gray-50 p-4 rounded-lg">
              <h5 class="font-medium text-gray-900 mb-3">Главная страница</h5>
              <div class="space-y-2">
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.about_content.read"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Просмотр</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.about_content.update"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Редактирование</span>
                </label>
              </div>
            </div>

            <!-- Шапка сайта -->
            <div class="bg-gray-50 p-4 rounded-lg">
              <h5 class="font-medium text-gray-900 mb-3">Шапка сайта</h5>
              <div class="space-y-2">
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.header_content.read"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Просмотр</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.header_content.update"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Редактирование</span>
                </label>
              </div>
            </div>

            <!-- Контакты -->
            <div class="bg-gray-50 p-4 rounded-lg">
              <h5 class="font-medium text-gray-900 mb-3">Контакты</h5>
              <div class="space-y-2">
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.contacts_content.read"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Просмотр</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.contacts_content.update"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Редактирование</span>
                </label>
              </div>
            </div>

            <!-- Пользователи -->
            <div class="bg-gray-50 p-4 rounded-lg">
              <h5 class="font-medium text-gray-900 mb-3">Пользователи</h5>
              <div class="space-y-2">
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.admin_users.read"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Просмотр</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.admin_users.create"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Создание</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.admin_users.update"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Редактирование</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.admin_users.delete"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Удаление</span>
                </label>
              </div>
            </div>

            <!-- Резервные копии -->
            <div class="bg-gray-50 p-4 rounded-lg">
              <h5 class="font-medium text-gray-900 mb-3">Резервные копии</h5>
              <div class="space-y-2">
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.admin_backup.read"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Просмотр</span>
                </label>
                <label class="flex items-center">
                  <input
                    v-model="form.permissions.admin_backup.create"
                    type="checkbox"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm text-gray-700">Создание</span>
                </label>
              </div>
            </div>
          </div>
        </div>

        <!-- Ошибки -->
        <div v-if="error" class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
          {{ error }}
        </div>

        <!-- Кнопки -->
        <div class="flex justify-end space-x-3 pt-6 border-t border-gray-200">
          <button
            type="button"
            @click="$emit('close')"
            class="px-4 py-2 text-gray-700 bg-gray-200 rounded-lg hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500 transition-all duration-200 font-medium"
          >
            Отмена
          </button>
          <button
            type="submit"
            :disabled="loading"
            class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed shadow-lg hover:shadow-xl transition-all duration-200 font-medium"
          >
            {{ loading ? 'Сохранение...' : (mode === 'create' ? 'Создать' : 'Сохранить') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import axios from 'axios'

const props = defineProps({
  user: {
    type: Object,
    default: null
  },
  mode: {
    type: String,
    required: true,
    validator: (value) => ['create', 'edit'].includes(value)
  }
})

const emit = defineEmits(['close', 'saved'])

// Состояние формы
const form = ref({
  username: '',
  email: '',
  password: '',
  full_name: '',
  role: 'editor',
  is_active: true,
  permissions: {
    projects: {
      read: false,
      create: false,
      update: false,
      delete: false
    },
    about_content: {
      read: false,
      update: false
    },
    header_content: {
      read: false,
      update: false
    },
    contacts_content: {
      read: false,
      update: false
    },
    admin_users: {
      read: false,
      create: false,
      update: false,
      delete: false
    },
    admin_backup: {
      read: false,
      create: false
    }
  }
})

const loading = ref(false)
const error = ref('')

// Инициализация формы
const initForm = () => {
  if (props.mode === 'edit' && props.user) {
    form.value = {
      id: props.user.id,
      username: props.user.username || '',
      email: props.user.email || '',
      password: '',
      full_name: props.user.full_name || '',
      role: props.user.role || 'editor',
      is_active: props.user.is_active !== undefined ? props.user.is_active : true,
      permissions: {
        projects: {
          read: props.user.permissions?.projects?.read || false,
          create: props.user.permissions?.projects?.create || false,
          update: props.user.permissions?.projects?.update || false,
          delete: props.user.permissions?.projects?.delete || false
        },
        about_content: {
          read: props.user.permissions?.about_content?.read || false,
          update: props.user.permissions?.about_content?.update || false
        },
        header_content: {
          read: props.user.permissions?.header_content?.read || false,
          update: props.user.permissions?.header_content?.update || false
        },
        contacts_content: {
          read: props.user.permissions?.contacts_content?.read || false,
          update: props.user.permissions?.contacts_content?.update || false
        },
        admin_users: {
          read: props.user.permissions?.admin_users?.read || false,
          create: props.user.permissions?.admin_users?.create || false,
          update: props.user.permissions?.admin_users?.update || false,
          delete: props.user.permissions?.admin_users?.delete || false
        },
        admin_backup: {
          read: props.user.permissions?.admin_backup?.read || false,
          create: props.user.permissions?.admin_backup?.create || false
        }
      }
    }
  } else {
    // Сброс формы для создания
    form.value = {
      username: '',
      email: '',
      password: '',
      full_name: '',
      role: 'editor',
      is_active: true,
      permissions: {
        projects: {
          read: false,
          create: false,
          update: false,
          delete: false
        },
        about_content: {
          read: false,
          update: false
        },
        header_content: {
          read: false,
          update: false
        },
        contacts_content: {
          read: false,
          update: false
        },
        admin_users: {
          read: false,
          create: false,
          update: false,
          delete: false
        },
        admin_backup: {
          read: false,
          create: false
        }
      }
    }
  }
}

// Обработка отправки формы
const handleSubmit = async () => {
  loading.value = true
  error.value = ''
  
  try {
    const data = {
      ...form.value,
      permissions: form.value.permissions
    }
    
    if (props.mode === 'create') {
      const response = await axios.post('/api/admin_users.php', data)
      if (response.data.success) {
        emit('saved', response.data.user)
      } else {
        error.value = response.data.error || 'Ошибка при создании пользователя'
      }
    } else {
      const response = await axios.put('/api/admin_users.php', data)
      if (response.data.success) {
        emit('saved', response.data.user)
      } else {
        error.value = response.data.error || 'Ошибка при обновлении пользователя'
      }
    }
  } catch (err) {
    error.value = err.response?.data?.error || 'Произошла ошибка при сохранении'
  } finally {
    loading.value = false
  }
}

// Инициализация при монтировании
onMounted(() => {
  initForm()
})

// Следим за изменениями props
watch(() => props.user, () => {
  initForm()
}, { immediate: true })
</script>
