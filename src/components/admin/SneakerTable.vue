<script setup>
const props = defineProps({
  sneakers: {
    type: Array,
    required: true,
  },
})

const emit = defineEmits(['edit', 'delete'])

const formatPrice = (price) => {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 0,
  }).format(price)
}
</script>

<template>
  <div class="bg-white border border-brand-black overflow-x-auto shadow-sm">
    <table class="w-full text-left border-collapse min-w-[720px]">
      <thead>
        <tr class="border-b border-brand-black bg-brand-gray-light font-calsans text-xs uppercase tracking-wider text-brand-black">
          <th class="p-4">Drop</th>
          <th class="p-4">Brand</th>
          <th class="p-4">Price</th>
          <th class="p-4">Status</th>
          <th class="p-4 text-right">Actions</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-neutral-200 text-sm">
        <tr v-if="sneakers.length === 0">
          <td colspan="5" class="p-8 text-center text-brand-gray-muted text-xs">
            No sneakers found in database.
          </td>
        </tr>
        <tr v-for="item in sneakers" :key="item.id" class="hover:bg-neutral-50 transition-colors">
          <td class="p-4 flex items-center gap-3">
            <div class="w-12 h-12 bg-brand-gray-card border border-neutral-200 flex items-center justify-center p-1 shrink-0">
              <img :src="item.image_url" :alt="item.name" class="max-h-full max-w-full object-contain" />
            </div>
            <div>
              <div class="font-calsans font-bold text-brand-black leading-tight">{{ item.name }}</div>
              <div class="text-xs text-brand-gray-muted line-clamp-1 max-w-xs">{{ item.description }}</div>
            </div>
          </td>
          <td class="p-4 font-satoshi text-xs font-semibold uppercase text-brand-black">{{ item.brand }}</td>
          <td class="p-4 font-satoshi font-semibold text-brand-black">{{ formatPrice(item.price) }}</td>
          <td class="p-4">
            <span
              class="inline-block px-2 py-0.5 text-[10px] font-calsans font-bold uppercase tracking-wider border border-brand-black"
              :class="{
                'bg-white text-brand-black': item.status === 'AVAILABLE',
                'bg-brand-volt text-brand-black': item.status === 'UPCOMING',
                'bg-neutral-200 text-neutral-600 border-neutral-400': item.status === 'SOLD OUT'
              }"
            >
              {{ item.status }}
            </span>
          </td>
          <td class="p-4 text-right space-x-2">
            <button
              @click="emit('edit', item)"
              class="p-1.5 hover:bg-neutral-100 border border-transparent hover:border-black transition-colors cursor-pointer"
              title="Edit Drop"
            >
              <i class="ri-edit-line text-base text-brand-black"></i>
            </button>
            <button
              @click="emit('delete', item.id)"
              class="p-1.5 hover:bg-red-50 text-red-600 border border-transparent hover:border-red-600 transition-colors cursor-pointer"
              title="Delete Drop"
            >
              <i class="ri-delete-bin-line text-base"></i>
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>