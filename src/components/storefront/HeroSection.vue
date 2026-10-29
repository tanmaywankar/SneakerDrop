<script setup>
const scrollToCollection = () => {
  const collectionSection = document.getElementById('collection')
  if (collectionSection) {
    collectionSection.scrollIntoView({ behavior: 'smooth' })
  }
}
</script>

<template>
  <section class="w-full bg-black">
    <!-- MOBILE / ANDROID LAYOUT (< md) -->
    <!-- Nav is on top -> Image maintaining aspect ratio -> Text with max 10px margin top & button below -->
    <div class="block md:hidden bg-black">
      <!-- Full Image maintaining natural aspect ratio -->
      <div class="w-full bg-black">
        <picture>
          <source media="(max-width: 768px)" srcset="/images/HeroImageMobile.webp" />
          <img
            src="/images/HeroImage.webp"
            alt="Be the change you want to see"
            class="w-full h-auto block object-contain"
          />
        </picture>
      </div>

      <!-- Text & CTA button right below image with max 10px margin-top -->
      <div class="w-full bg-black text-white px-6 mt-[10px] pb-10 flex flex-col items-start">
        <h1 class="font-newake text-white text-4xl sm:text-5xl leading-[0.95] uppercase select-none drop-shadow-md">
          Be the<br />
          change you<br />
          want to see
        </h1>

        <!-- Neo-Brutalist Stroke-Hover Button: Stroke stays down & right consistently on touch -->
        <div class="mt-6 relative inline-block group cursor-pointer select-none" @click="scrollToCollection">
          <div 
            class="absolute inset-0 translate-x-1.5 translate-y-1.5 border-2 border-brand-volt pointer-events-none transition-transform duration-150 ease-out"
          ></div>

          <button
            type="button"
            class="relative z-10 px-8 py-3.5 bg-brand-volt text-brand-black font-calsans font-semibold text-sm tracking-widest uppercase transition-transform duration-150 ease-out active:translate-x-1 active:translate-y-1"
          >
            Shop Now
          </button>
        </div>
      </div>
    </div>

    <!-- DESKTOP LAYOUT (>= md) -->
    <!-- Right-aligned 16:9 image preserving aspect ratio with seamless pure black space -->
    <div class="hidden md:block relative w-full bg-black overflow-hidden">
      <!-- Right-anchored image with variable height up to viewport fold -->
      <div class="w-full flex justify-end bg-black">
        <img
          src="/images/HeroImage.webp"
          alt="Be the change you want to see"
          class="h-auto max-h-[calc(100vh-3.5rem)] w-auto object-contain object-right block select-none"
        />
      </div>

      <!-- Gradient blend to guarantee seamless transition to black on wide viewports -->
      <div class="absolute inset-y-0 left-0 w-1/2 bg-gradient-to-r from-black via-black/80 to-transparent pointer-events-none z-[5]"></div>

      <!-- Text & Button positioned over the dark left zone (no max-w limits) -->
      <div class="absolute inset-0 z-10 w-full h-full px-8 lg:px-12 flex flex-col justify-center items-start pointer-events-none">
        <div class="pointer-events-auto">
          <h1 class="font-newake text-white text-5xl lg:text-7xl xl:text-8xl leading-[0.95] uppercase select-none drop-shadow-md">
            Be the<br />
            change you<br />
            want to see
          </h1>

          <!-- Neo-Brutalist Stroke-Hover Button: Stroke reveals only on hover on PC -->
          <div class="mt-8 relative inline-block group cursor-pointer select-none" @click="scrollToCollection">
            <div 
              class="absolute inset-0 translate-x-0 translate-y-0 opacity-0 group-hover:opacity-100 group-hover:translate-x-2 group-hover:translate-y-2 border-2 border-brand-volt pointer-events-none transition-all duration-200 ease-out"
            ></div>

            <button
              type="button"
              class="relative z-10 px-8 py-3.5 bg-brand-volt text-brand-black font-calsans font-semibold text-sm tracking-widest uppercase transition-transform duration-150 ease-out active:translate-x-1 active:translate-y-1"
            >
              Shop Now
            </button>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
