<script setup>
import { RouterLink } from 'vue-router'
</script>

<template>
  <footer class="w-full bg-black text-white">
    <div class="w-full px-6 py-4 flex flex-col sm:flex-row items-center justify-between gap-3 text-[10px] sm:text-[11px] font-satoshi uppercase tracking-wider">
      <!-- Left Copyright -->
      <span class="text-neutral-300">
        &copy; 2026 SNEAKERDROP. ALL RIGHTS RESERVED.
      </span>

      <!-- Center Admin Link -->
      <RouterLink 
        to="/admin/login" 
        class="text-neutral-300 hover:text-brand-volt transition-colors"
      >
        Admin Panel
      </RouterLink>

      <!-- Right Currency -->
      <span class="text-neutral-300">
        Currency: IN/INR
      </span>
    </div>
  </footer>
</template>
