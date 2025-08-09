<template>
  <div class="space-y-20 animate-fadein">
    <About />
    <Gallery />
    <Steps />
    <Reviews />
    <Contacts />
  </div>
</template>

<script setup>
import About from './About.vue'
import Gallery from './Gallery.vue'
import Steps from './Steps.vue'
import Reviews from './Reviews.vue'
import Contacts from './Contacts.vue'
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
