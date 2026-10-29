<script setup>
const props = defineProps({
  sneaker: {
    type: Object,
    required: true,
  },
})

const emit = defineEmits(['open-waitlist', 'add-to-cart'])

const formatPrice = (price) => {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 0,
  }).format(price)
}
</script>

<template>
  <div class="w-full max-w-[320px] bg-white border border-transparent hover:border-black transition-colors duration-150 flex flex-col">
    <!-- 1:1 ratio box covering full card width -->
    <div class="w-full aspect-square bg-primary flex items-center justify-center overflow-hidden">
      <img
        :src="sneaker.image_url"
        :alt="sneaker.name"
        class="w-full h-full object-contain"
        loading="lazy"
      />
    </div>

    <!-- Product Details & Pricing / Action Row (below the 1:1 square) -->
    <div class="p-3.5 flex flex-col justify-between flex-1">
      <div>
        <h3 class="font-calsans text-base font-bold text-brand-black leading-snug">
          {{ sneaker.name }}
        </h3>
        <p class="font-satoshi text-xs text-brand-gray-muted mt-0.5">
          {{ sneaker.description }}
        </p>
      </div>

      <!-- Pricing & Button Row (no lines or divider borders) -->
      <div class="mt-4 flex items-center justify-between">
        <span class="font-satoshi font-semibold text-base text-brand-black">
          {{ formatPrice(sneaker.price) }}
        </span>

        <!-- Available -> Add to Cart -->
        <div v-if="sneaker.status === 'AVAILABLE'" class="relative inline-block group/btn cursor-pointer select-none">
          <div 
            class="absolute inset-0 translate-x-0 translate-y-0 opacity-0 group-hover/btn:opacity-100 group-hover/btn:translate-x-1.5 group-hover/btn:translate-y-1.5 border-2 border-brand-black pointer-events-none transition-all duration-150 ease-out"
          ></div>
          <button
            type="button"
            @click="emit('add-to-cart', sneaker)"
            class="relative z-10 w-[132px] h-[36px] inline-flex items-center justify-center gap-2 bg-brand-black text-white text-xs font-calsans font-medium tracking-wider uppercase transition-transform duration-150 ease-out active:translate-x-0.5 active:translate-y-0.5"
          >
            <span>Add to Cart</span>
            <i class="ri-shopping-bag-line text-sm"></i>
          </button>
        </div>

        <!-- Upcoming -> Join Waitlist -->
        <div v-else-if="sneaker.status === 'UPCOMING'" class="relative inline-block group/btn cursor-pointer select-none">
          <div 
            class="absolute inset-0 translate-x-0 translate-y-0 opacity-0 group-hover/btn:opacity-100 group-hover/btn:translate-x-1.5 group-hover/btn:translate-y-1.5 border-2 border-brand-volt pointer-events-none transition-all duration-150 ease-out"
          ></div>
          <button
            type="button"
            @click="emit('open-waitlist', sneaker)"
            class="relative z-10 w-[132px] h-[36px] inline-flex items-center justify-center gap-1.5 bg-brand-volt text-brand-black text-xs font-calsans font-medium tracking-wider uppercase transition-transform duration-150 ease-out active:translate-x-0.5 active:translate-y-0.5"
          >
            <span>Join Waitlist</span>
            <i class="ri-calendar-line text-sm"></i>
          </button>
        </div>

        <!-- Sold Out / Notify -->
        <div v-else class="relative inline-block group/btn cursor-pointer select-none">
          <div 
            class="absolute inset-0 translate-x-0 translate-y-0 opacity-0 group-hover/btn:opacity-100 group-hover/btn:translate-x-1.5 group-hover/btn:translate-y-1.5 border-2 border-black pointer-events-none transition-all duration-150 ease-out"
          ></div>
          <button
            type="button"
            @click="emit('open-waitlist', sneaker)"
            class="relative z-10 w-[132px] h-[36px] inline-flex items-center justify-center gap-2 bg-white text-brand-black border-2 border-black text-xs font-calsans font-medium tracking-wider uppercase transition-transform duration-150 ease-out active:translate-x-0.5 active:translate-y-0.5"
          >
            <span>Notify</span>
            <i class="ri-shopping-bag-line text-sm"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
