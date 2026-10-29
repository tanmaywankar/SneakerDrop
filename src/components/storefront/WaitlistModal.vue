<script setup>
import { ref } from 'vue'
import { supabase } from '../../lib/supabase'

const props = defineProps({
  sneaker: {
    type: Object,
    required: true,
  },
})

const emit = defineEmits(['close'])

const email = ref('')
const loading = ref(false)
const errorMessage = ref('')
const isSuccess = ref(false)

const handleSubmit = async () => {
  errorMessage.value = ''

  const trimmedEmail = email.value.trim().toLowerCase()

  if (!trimmedEmail || !trimmedEmail.includes('@') || !trimmedEmail.includes('.')) {
    errorMessage.value = 'Please enter a valid email address.'
    return
  }

  try {
    loading.value = true
    const { error } = await supabase.from('waitlist').insert({
      sneaker_id: props.sneaker.id,
      email: trimmedEmail,
    })

    if (error) {
      if (error.code === '23505') {
        errorMessage.value = "You're already on the waitlist for this drop!"
        return
      }
      throw error
    }

    isSuccess.value = true
  } catch (err) {
    errorMessage.value = err.message || 'Failed to join waitlist. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs">
    <div class="relative w-full max-w-md bg-white border-2 border-brand-black p-6 shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
      <!-- Close Button -->
      <button 
        @click="emit('close')" 
        class="absolute top-4 right-4 text-brand-black hover:opacity-60 transition-opacity"
        aria-label="Close modal"
      >
        <i class="ri-close-line text-2xl"></i>
      </button>

      <!-- Success State -->
      <div v-if="isSuccess" class="text-center py-6">
        <div class="w-12 h-12 bg-brand-volt border-2 border-brand-black flex items-center justify-center mx-auto mb-4">
          <i class="ri-check-line text-2xl text-brand-black font-bold"></i>
        </div>
        <h3 class="font-calsans text-2xl font-bold uppercase tracking-tight text-brand-black mb-2">
          You're On The List
        </h3>
        <p class="font-satoshi text-xs text-brand-gray-muted max-w-xs mx-auto mb-6">
          We'll email you the moment <strong class="text-brand-black">{{ sneaker.name }}</strong> drops.
        </p>
        <button 
          @click="emit('close')"
          class="w-full bg-brand-black text-white font-satoshi font-semibold py-3 text-xs uppercase tracking-widest hover:bg-neutral-800 transition-colors"
        >
          Back to Drops
        </button>
      </div>

      <!-- Form State -->
      <div v-else>
        <!-- Product Snippet -->
        <div class="flex items-center gap-4 border-b border-brand-gray-border pb-4 mb-4">
          <div class="w-16 h-16 bg-brand-gray-card flex items-center justify-center p-2 border border-brand-gray-border shrink-0">
            <img :src="sneaker.image_url" :alt="sneaker.name" class="max-h-full w-auto object-contain" />
          </div>
          <div>
            <span class="inline-block bg-brand-volt text-brand-black font-satoshi text-[10px] font-bold px-1.5 py-0.5 uppercase tracking-wider mb-1">
              {{ sneaker.status }}
            </span>
            <h4 class="font-calsans text-base font-bold text-brand-black leading-tight line-clamp-1">
              {{ sneaker.name }}
            </h4>
            <p class="font-satoshi text-xs text-brand-gray-muted">{{ sneaker.brand }}</p>
          </div>
        </div>

        <h3 class="font-calsans text-xl font-bold uppercase tracking-tight text-brand-black mb-1">
          Priority Access
        </h3>
        <p class="font-satoshi text-xs text-brand-gray-muted mb-4">
          Enter your email to receive direct drop alerts and early purchase links.
        </p>

        <form @submit.prevent="handleSubmit" class="space-y-4">
          <div>
            <label class="block font-satoshi text-xs font-semibold uppercase tracking-wider text-brand-black mb-1">
              Email Address
            </label>
            <input
              v-model="email"
              type="email"
              required
              placeholder="you@domain.com"
              :disabled="loading"
              class="w-full bg-brand-gray-light border border-brand-black px-3.5 py-2.5 font-satoshi text-sm text-brand-black placeholder:text-neutral-400 focus:outline-none focus:ring-2 focus:ring-brand-volt transition-all disabled:opacity-50"
            />
          </div>

          <p v-if="errorMessage" class="text-xs font-satoshi text-red-600 font-medium">
            {{ errorMessage }}
          </p>

          <button
            type="submit"
            :disabled="loading"
            class="w-full bg-brand-volt border-2 border-brand-black text-brand-black font-calsans font-bold py-3 text-xs uppercase tracking-widest hover:bg-black hover:text-white transition-all disabled:opacity-50"
          >
            <span v-if="loading">Securing Spot...</span>
            <span v-else>Join Priority Waitlist</span>
          </button>
        </form>
      </div>
    </div>
  </div>
</template>