<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../lib/supabase'

const router = useRouter()

const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')

const handleLogin = async () => {
  errorMessage.value = ''

  if (!email.value || !password.value) {
    errorMessage.value = 'Please enter both email and password.'
    return
  }

  try {
    loading.value = true
    const { data, error } = await supabase.auth.signInWithPassword({
      email: email.value.trim(),
      password: password.value,
    })

    if (error) throw error

    if (data.session) {
      router.push({ name: 'AdminDashboard' })
    }
  } catch (err) {
    errorMessage.value = err.message || 'Invalid login credentials.'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="relative min-h-screen bg-brand-gray-light font-satoshi flex flex-col justify-between p-8 sm:p-12 overflow-hidden">
    <div 
      v-if="loading"
      class="fixed top-0 left-0 h-1.5 w-full bg-brand-volt border-b border-brand-black z-50 animate-pulse"
    ></div>

    <!-- Brand Header -->
    <header class="pt-2">
      <RouterLink 
        to="/" 
        class="font-newake text-3xl tracking-tight text-brand-black hover:opacity-80 transition-opacity inline-block"
      >
        SneakerDrop
      </RouterLink>
    </header>

    <!-- Centered Login Box -->
    <main class="w-full flex items-center justify-center py-10">
      <div class="w-full max-w-md bg-white p-8 sm:p-10 shadow-sm border border-neutral-200">
        <h1 class="font-calsans text-3xl font-bold text-brand-black mb-8">
          Admin Login
        </h1>

        <form @submit.prevent="handleLogin" class="space-y-6">
          <!-- Email Field -->
          <div>
            <label class="block font-calsans font-bold text-base text-brand-black mb-2">
              Email
            </label>
            <input
              v-model="email"
              type="email"
              required
              placeholder="Email"
              :disabled="loading"
              class="w-full bg-white border border-brand-black px-4 py-3 font-satoshi text-sm text-brand-black placeholder:text-neutral-400 focus:outline-none focus:ring-1 focus:ring-brand-black disabled:opacity-50"
            />
          </div>

          <!-- Password Field -->
          <div>
            <label class="block font-calsans font-bold text-base text-brand-black mb-2">
              Password
            </label>
            <input
              v-model="password"
              type="password"
              required
              placeholder="Password"
              :disabled="loading"
              class="w-full bg-white border border-brand-black px-4 py-3 font-satoshi text-sm text-brand-black placeholder:text-neutral-400 focus:outline-none focus:ring-1 focus:ring-brand-black disabled:opacity-50"
            />
          </div>

          <!-- Error Alert -->
          <p v-if="errorMessage" class="text-xs font-satoshi text-red-600 font-semibold">
            {{ errorMessage }}
          </p>

          <!-- Authenticate Button -->
          <button
            type="submit"
            :disabled="loading"
            class="w-full bg-brand-volt border border-brand-black text-brand-black font-calsans font-bold py-3 text-sm tracking-wider uppercase hover:brightness-95 active:translate-y-0.5 transition-all disabled:opacity-50 cursor-pointer"
          >
            <span v-if="loading">Authenticating...</span>
            <span v-else>AUTHENTICATE</span>
          </button>
        </form>
      </div>
    </main>

    <!-- Bottom Spacing Anchor -->
    <div class="h-6"></div>
  </div>
</template>