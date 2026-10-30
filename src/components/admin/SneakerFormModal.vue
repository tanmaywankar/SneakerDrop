<script setup>
import { reactive, watch } from 'vue'

const props = defineProps({
  sneaker: {
    type: Object,
    default: null,
  },
  loading: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits(['close', 'save'])

const form = reactive({
  name: '',
  brand: '',
  price: '',
  description: '',
  status: 'AVAILABLE',
  image_url: '',
})

watch(
  () => props.sneaker,
  (val) => {
    if (val) {
      form.name = val.name || ''
      form.brand = val.brand || ''
      form.price = val.price ?? ''
      form.description = val.description || ''
      form.status = val.status || 'AVAILABLE'
      form.image_url = val.image_url || ''
    } else {
      form.name = ''
      form.brand = ''
      form.price = ''
      form.description = ''
      form.status = 'AVAILABLE'
      form.image_url = ''
    }
  },
  { immediate: true }
)

const handleSubmit = () => {
  emit('save', {
    ...form,
    price: Number(form.price),
  })
}
</script>

<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs overflow-y-auto">
    <div class="relative w-full max-w-lg bg-white border-2 border-brand-black p-6 sm:p-8 shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] my-8">
      <button 
        type="button" 
        @click="emit('close')" 
        class="absolute top-5 right-5 text-brand-black hover:opacity-60 transition-opacity"
      >
        <i class="ri-close-line text-2xl"></i>
      </button>

      <h2 class="font-calsans text-2xl font-bold uppercase tracking-tight text-brand-black mb-6">
        {{ sneaker ? 'Edit Sneaker Drop' : 'New Sneaker Drop' }}
      </h2>

      <form @submit.prevent="handleSubmit" class="space-y-4">
        <div>
          <label class="block font-calsans font-bold text-xs uppercase tracking-wider text-brand-black mb-1">
            Sneaker Name
          </label>
          <input
            v-model="form.name"
            type="text"
            required
            placeholder="e.g. Travis Scott x Air Jordan 1"
            class="w-full bg-brand-gray-light border border-brand-black px-3.5 py-2 font-satoshi text-sm focus:outline-none focus:ring-1 focus:ring-brand-black"
          />
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block font-calsans font-bold text-xs uppercase tracking-wider text-brand-black mb-1">
              Brand
            </label>
            <input
              v-model="form.brand"
              type="text"
              required
              placeholder="e.g. Nike"
              class="w-full bg-brand-gray-light border border-brand-black px-3.5 py-2 font-satoshi text-sm focus:outline-none focus:ring-1 focus:ring-brand-black"
            />
          </div>

          <div>
            <label class="block font-calsans font-bold text-xs uppercase tracking-wider text-brand-black mb-1">
              Price (₹)
            </label>
            <input
              v-model="form.price"
              type="number"
              min="0"
              required
              placeholder="25000"
              class="w-full bg-brand-gray-light border border-brand-black px-3.5 py-2 font-satoshi text-sm focus:outline-none focus:ring-1 focus:ring-brand-black"
            />
          </div>
        </div>

        <div>
          <label class="block font-calsans font-bold text-xs uppercase tracking-wider text-brand-black mb-1">
            Availability Status
          </label>
          <select
            v-model="form.status"
            class="w-full bg-brand-gray-light border border-brand-black px-3.5 py-2 font-satoshi text-sm focus:outline-none focus:ring-1 focus:ring-brand-black"
          >
            <option value="AVAILABLE">AVAILABLE</option>
            <option value="UPCOMING">UPCOMING</option>
            <option value="SOLD OUT">SOLD OUT</option>
          </select>
        </div>

        <div>
          <label class="block font-calsans font-bold text-xs uppercase tracking-wider text-brand-black mb-1">
            Image URL
          </label>
          <input
            v-model="form.image_url"
            type="url"
            required
            placeholder="https://images.unsplash.com/..."
            class="w-full bg-brand-gray-light border border-brand-black px-3.5 py-2 font-satoshi text-sm focus:outline-none focus:ring-1 focus:ring-brand-black"
          />
        </div>

        <div>
          <label class="block font-calsans font-bold text-xs uppercase tracking-wider text-brand-black mb-1">
            Description
          </label>
          <textarea
            v-model="form.description"
            rows="3"
            placeholder="Key product story, materials, and drop notes..."
            class="w-full bg-brand-gray-light border border-brand-black px-3.5 py-2 font-satoshi text-sm focus:outline-none focus:ring-1 focus:ring-brand-black"
          ></textarea>
        </div>

        <div class="pt-3 flex justify-end gap-3">
          <button
            type="button"
            @click="emit('close')"
            class="px-5 py-2.5 bg-white border border-brand-black font-calsans text-xs uppercase tracking-wider hover:bg-neutral-100"
          >
            Cancel
          </button>
          <button
            type="submit"
            :disabled="loading"
            class="px-6 py-2.5 bg-brand-volt border border-brand-black font-calsans font-bold text-xs uppercase tracking-wider hover:brightness-95 disabled:opacity-50 cursor-pointer"
          >
            <span v-if="loading">Saving...</span>
            <span v-else>{{ sneaker ? 'Save Changes' : 'Create Drop' }}</span>
          </button>
        </div>
      </form>
    </div>
  </div>
</template>