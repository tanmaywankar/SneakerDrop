<script setup></script>

<template>
  <header class="sticky top-0 z-50 w-full bg-white">
    <div class="px-4 md:px-6 h-11 md:h-14 flex items-center justify-between">
      <RouterLink
        to="/"
        class="font-newake text-xl md:text-2xl font-normal text-brand-black hover:opacity-90 transition-opacity"
      >
        SneakerDrop
      </RouterLink>

      <RouterLink
        to="/admin/login"
        class="p-1.5 md:p-2 rounded-full hover:opacity-90 transition-colors text-brand-black flex items-center justify-center"
        title="Admin Login"
      >
        <i class="ri-user-line text-lg md:text-2xl leading-none"></i>
      </RouterLink>
    </div>
  </header>
</template>
