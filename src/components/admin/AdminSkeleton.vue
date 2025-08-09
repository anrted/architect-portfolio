<template>
  <div class="space-y-6 animate-pulse">
    <!-- Заголовок скелетон -->
    <div class="flex justify-between items-center">
      <div class="h-8 bg-gray-200 rounded w-64"></div>
      <div class="h-10 bg-gray-200 rounded w-40"></div>
    </div>

    <!-- Основной контент скелетон -->
    <div class="bg-white rounded-lg shadow p-6">
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Левая колонка -->
        <div class="space-y-6">
          <div class="h-6 bg-gray-200 rounded w-48"></div>
          
          <!-- Поля ввода -->
          <div class="space-y-4">
            <div>
              <div class="h-4 bg-gray-200 rounded w-32 mb-2"></div>
              <div class="h-10 bg-gray-200 rounded w-full"></div>
              <div class="h-3 bg-gray-200 rounded w-48 mt-1"></div>
            </div>
            
            <div>
              <div class="h-4 bg-gray-200 rounded w-24 mb-2"></div>
              <div class="h-10 bg-gray-200 rounded w-full"></div>
              <div class="h-3 bg-gray-200 rounded w-56 mt-1"></div>
            </div>
          </div>
        </div>

        <!-- Правая колонка -->
        <div class="space-y-6">
          <div class="h-6 bg-gray-200 rounded w-40"></div>
          
          <!-- Ссылки -->
          <div class="space-y-4">
            <div v-for="i in 3" :key="i" class="p-4 border border-gray-200 rounded-lg">
              <div class="flex items-center justify-between mb-3">
                <div class="h-4 bg-gray-200 rounded w-20"></div>
                <div class="h-4 w-4 bg-gray-200 rounded"></div>
              </div>
              
              <div class="grid grid-cols-2 gap-3">
                <div>
                  <div class="h-3 bg-gray-200 rounded w-16 mb-1"></div>
                  <div class="h-8 bg-gray-200 rounded w-full"></div>
                </div>
                <div>
                  <div class="h-3 bg-gray-200 rounded w-8 mb-1"></div>
                  <div class="h-8 bg-gray-200 rounded w-full"></div>
                </div>
              </div>
              
              <div class="mt-3">
                <div class="h-3 bg-gray-200 rounded w-20 mb-1"></div>
                <div class="h-8 bg-gray-200 rounded w-full"></div>
              </div>
            </div>
            
            <div class="h-12 bg-gray-200 rounded-lg border-2 border-dashed border-gray-300"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Предварительный просмотр скелетон -->
    <div class="bg-white rounded-lg shadow p-6">
      <div class="h-6 bg-gray-200 rounded w-48 mb-4"></div>
      <div class="bg-gradient-to-br from-blue-50 via-white to-blue-100 rounded-lg p-6">
        <div class="bg-white/80 backdrop-blur shadow-md border-b border-gray-200 rounded-lg">
          <div class="max-w-6xl mx-auto px-4 py-3 flex justify-between items-center">
            <div>
              <div class="h-8 bg-gray-200 rounded w-64"></div>
              <div class="h-4 bg-gray-200 rounded w-32 mt-1"></div>
            </div>
            <div class="hidden md:flex gap-8">
              <div v-for="i in 3" :key="i" class="h-6 bg-gray-200 rounded w-16"></div>
            </div>
            <div class="md:hidden">
              <div class="h-7 w-7 bg-gray-200 rounded"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// Компонент скелетона для загрузки
</script>
