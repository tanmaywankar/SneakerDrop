<script setup>
import { useRouter } from 'vue-router'
import { supabase } from '../../lib/supabase'

const router = useRouter()

const handleSignOut = async () => {
  await supabase.auth.signOut()
  router.push({ name: 'AdminLogin' })
}
</script>

<template>
  <header class="sticky top-0 z-40 bg-white border-b border-brand-black">
    <div class="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
      <div class="flex items-center gap-4">
        <RouterLink to="/" class="font-newake text-2xl tracking-tight text-brand-black hover:opacity-80">
          SneakerDrop
        </RouterLink>
        <span class="bg-brand-volt text-brand-black text-[11px] font-calsans uppercase tracking-widest px-2 py-0.5 border border-brand-black">
          Console
        </span>
      </div>

      <div class="flex items-center gap-6">
        <RouterLink to="/" class="text-xs font-calsans font-semibold uppercase tracking-wider hover:opacity-60 hidden sm:inline-block">
          View Storefront
        </RouterLink>
        <button
          @click="handleSignOut"
          type="button"
          class="inline-flex items-center gap-1.5 px-3 py-1.5 border border-brand-black text-xs font-calsans font-bold uppercase tracking-wider hover:bg-black hover:text-white transition-colors cursor-pointer"
        >
          <span>Sign Out</span>
          <i class="ri-logout-box-r-line"></i>
        </button>
      </div>
    </div>
  </header>
</template>