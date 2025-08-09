<template>
  <!-- Hero секция -->
  <section id="about" class="relative mb-20 overflow-hidden">
    <!-- Фоновая секция -->
    <div class="relative bg-gradient-to-br from-blue-50 via-white to-blue-100 rounded-3xl p-8 md:p-16 shadow-xl">
      <!-- Декоративные элементы -->
      <div class="absolute top-0 right-0 w-64 h-64 bg-blue-200 rounded-full opacity-10 transform translate-x-32 -translate-y-32"></div>
      <div class="absolute bottom-0 left-0 w-48 h-48 bg-blue-300 rounded-full opacity-10 transform -translate-x-24 translate-y-24"></div>
      
      <div class="relative z-10 max-w-4xl mx-auto">
        <!-- Главный заголовок -->
        <div class="text-center mb-12">
          <div class="inline-flex items-center justify-center w-24 h-24 bg-blue-600 rounded-full mb-6 shadow-lg">
            <svg class="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
            </svg>
          </div>
          <h1 class="text-4xl md:text-6xl font-bold text-gray-900 mb-6 leading-tight">
            Иван Иванов
          </h1>
          <p class="text-xl md:text-2xl text-gray-600 font-light mb-8">
            Архитектор современности
          </p>
        </div>

        <!-- Основной контент -->
        <div class="grid md:grid-cols-2 gap-12 items-center">
          <div class="space-y-6">
            <div class="prose prose-lg text-gray-700 leading-relaxed">
              <p class="text-xl font-medium text-gray-900 mb-4">
                Создаю пространства, которые вдохновляют
              </p>
              <p class="mb-4">
                Я — архитектор с опытом более 10 лет, специализирующийся на современных жилых и общественных зданиях. В каждом проекте стремлюсь найти баланс между эстетикой, функциональностью и устойчивостью.
              </p>
              <p>
                Мой подход основан на глубоком понимании потребностей клиента, внимании к деталям и использовании передовых технологий в архитектуре.
              </p>
            </div>

            <!-- Ключевые преимущества -->
            <div class="grid grid-cols-2 gap-4 mt-8">
              <div class="flex items-center space-x-3">
                <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                  <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                  </svg>
                </div>
                <span class="font-medium text-gray-900">10+ лет опыта</span>
              </div>
              <div class="flex items-center space-x-3">
                <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                  <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                  </svg>
                </div>
                <span class="font-medium text-gray-900">Инновационный подход</span>
              </div>
              <div class="flex items-center space-x-3">
                <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                  <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                  </svg>
                </div>
                <span class="font-medium text-gray-900">Точность в сроках</span>
              </div>
              <div class="flex items-center space-x-3">
                <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                  <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path>
                  </svg>
                </div>
                <span class="font-medium text-gray-900">Индивидуальный подход</span>
              </div>
            </div>
          </div>

          <!-- Статистика -->
          <div class="bg-white rounded-2xl p-8 shadow-lg border border-gray-100">
            <div class="grid grid-cols-2 gap-6">
              <div class="text-center">
                <div class="text-3xl font-bold text-blue-600 mb-2">50+</div>
                <div class="text-sm text-gray-600 font-medium">Реализованных проектов</div>
              </div>
              <div class="text-center">
                <div class="text-3xl font-bold text-blue-600 mb-2">10</div>
                <div class="text-sm text-gray-600 font-medium">Лет опыта</div>
              </div>
              <div class="text-center">
                <div class="text-3xl font-bold text-blue-600 mb-2">100%</div>
                <div class="text-sm text-gray-600 font-medium">Довольных клиентов</div>
              </div>
              <div class="text-center">
                <div class="text-3xl font-bold text-blue-600 mb-2">5</div>
                <div class="text-sm text-gray-600 font-medium">Наград</div>
              </div>
            </div>
          </div>
        </div>

        <!-- CTA кнопка -->
        <div class="text-center mt-12">
          <a href="#contacts" class="inline-flex items-center px-8 py-4 bg-blue-600 text-white font-medium rounded-xl shadow-lg hover:bg-blue-700 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-3.582 8-8 8a8.13 8.13 0 01-2.906-.515L7 21l1.515-3.094A8.002 8.002 0 013 12c0-4.418 3.582-8 8-8s8 3.582 8 8z"></path>
            </svg>
            Обсудить проект
          </a>
        </div>
      </div>
    </div>
  </section>
</template>
