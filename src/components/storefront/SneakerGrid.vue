<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../../lib/supabase'
import SneakerCard from './SneakerCard.vue'

const emit = defineEmits(['open-waitlist'])

const sneakers = ref([])
const loading = ref(true)
const error = ref(null)

const fetchSneakers = async () => {
  try {
    loading.value = true
    const { data, error: err } = await supabase
      .from('sneakers')
      .select('*')
      .order('created_at', { ascending: false })

    if (err) throw err
    sneakers.value = data || []
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

const handleAddToCart = (sneaker) => {
  alert(`Added ${sneaker.name} to bag!`)
}

onMounted(() => {
  fetchSneakers()
})
</script>

<template>
  <div>
    <div v-if="loading" class="grid grid-cols-[repeat(auto-fill,minmax(280px,320px))] gap-3 justify-center">
      <div 
        v-for="i in 4" 
        :key="i" 
        class="w-full max-w-[320px] bg-white border border-transparent animate-pulse flex flex-col"
      >
        <!-- 1:1 ratio image box -->
        <div class="w-full aspect-square bg-primary"></div>

        <!-- Details & Action Row placeholder matching exact loaded dimensions -->
        <div class="p-3.5 flex flex-col justify-between flex-1">
          <div>
            <div class="h-[18px] bg-brand-gray-card w-3/4"></div>
            <div class="h-3.5 bg-brand-gray-card/70 w-1/2 mt-1"></div>
          </div>

          <div class="mt-4 flex items-center justify-between">
            <div class="h-5 bg-brand-gray-card w-16"></div>
            <div class="h-[36px] bg-brand-gray-card w-[132px]"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="p-6 bg-red-50 border border-red-300 text-red-700 text-sm">
      Failed to load collection: {{ error }}
    </div>

    <div v-else-if="sneakers.length === 0" class="text-center py-12 text-brand-gray-muted text-sm">
      No sneakers available in the collection right now.
    </div>

    <!-- Cards Grid -->
    <div v-else class="grid grid-cols-[repeat(auto-fill,minmax(280px,320px))] gap-3 justify-center">
      <SneakerCard
        v-for="shoe in sneakers"
        :key="shoe.id"
        :sneaker="shoe"
        @open-waitlist="(s) => emit('open-waitlist', s)"
        @add-to-cart="handleAddToCart"
      />
    </div>
  </div>
</template>
