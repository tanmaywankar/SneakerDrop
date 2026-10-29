<script setup>
import { ref } from "vue";
import Navbar from "../components/layout/Navbar.vue";
import HeroSection from "../components/storefront/HeroSection.vue";
import SneakerGrid from "../components/storefront/SneakerGrid.vue";
import Footer from "../components/layout/Footer.vue";
import WaitlistModal from "../components/storefront/WaitlistModal.vue";

const selectedSneaker = ref(null);
const isWaitlistOpen = ref(false);

const handleOpenWaitlist = (sneaker) => {
  selectedSneaker.value = sneaker;
  isWaitlistOpen.value = true;
};

const handleCloseWaitlist = () => {
  isWaitlistOpen.value = false;
  selectedSneaker.value = null;
};
</script>

<template>
  <div class="min-h-screen bg-white font-satoshi text-brand-black">
    <div>
      <Navbar />
      <HeroSection />

      <!-- Collection Section Anchor -->
      <section id="collection" class="w-full px-6 py-10">
        <h2
          class="font-calsans text-3xl uppercase tracking-wider font-bold mb-8"
        >
          Top Collection
        </h2>
        <SneakerGrid @open-waitlist="handleOpenWaitlist" />
      </section>
    </div>
    <Footer />
    <WaitlistModal
      v-if="isWaitlistOpen"
      :sneaker="selectedSneaker"
      @close="handleCloseWaitlist"
    />
  </div>
</template>
