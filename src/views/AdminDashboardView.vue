
<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../lib/supabase'
import AdminNavbar from '../components/admin/AdminNavbar.vue'
import SneakerTable from '../components/admin/SneakerTable.vue'
import WaitlistTable from '../components/admin/WaitlistTable.vue'
import SneakerFormModal from '../components/admin/SneakerFormModal.vue'

const activeTab = ref('sneakers') // 'sneakers' | 'waitlist'
const sneakers = ref([])
const waitlist = ref([])
const loading = ref(true)

// Modal state
const isModalOpen = ref(false)
const editingSneaker = ref(null)
const modalLoading = ref(false)

const fetchData = async () => {
  try {
    loading.value = true
    const [sneakersRes, waitlistRes] = await Promise.all([
      supabase.from('sneakers').select('*').order('created_at', { ascending: false }),
      supabase.from('waitlist').select('*, sneakers(name)').order('created_at', { ascending: false }),
    ])

    if (sneakersRes.error) throw sneakersRes.error
    if (waitlistRes.error) throw waitlistRes.error

    sneakers.value = sneakersRes.data || []
    waitlist.value = waitlistRes.data || []
  } catch (err) {
    console.error('Failed to load dashboard data:', err)
  } finally {
    loading.value = false
  }
}

const handleOpenCreate = () => {
  editingSneaker.value = null
  isModalOpen.value = true
}

const handleOpenEdit = (sneaker) => {
  editingSneaker.value = sneaker
  isModalOpen.value = true
}

const handleCloseModal = () => {
  isModalOpen.value = false
  editingSneaker.value = null
}

const handleSaveSneaker = async (formData) => {
  try {
    modalLoading.value = true
    if (editingSneaker.value) {
      const { error } = await supabase
        .from('sneakers')
        .update(formData)
        .eq('id', editingSneaker.value.id)
      if (error) throw error
    } else {
      const { error } = await supabase.from('sneakers').insert(formData)
      if (error) throw error
    }

    handleCloseModal()
    await fetchData()
  } catch (err) {
    alert(err.message || 'Failed to save drop.')
  } finally {
    modalLoading.value = false
  }
}

const handleDeleteSneaker = async (id) => {
  if (!confirm('Are you sure you want to delete this drop?')) return
  try {
    const { error } = await supabase.from('sneakers').delete().eq('id', id)
    if (error) throw error
    await fetchData()
  } catch (err) {
    alert(err.message || 'Failed to delete sneaker.')
  }
}

onMounted(() => {
  fetchData()
})
</script>

<template>
  <div class="min-h-screen bg-brand-gray-light font-satoshi text-brand-black">
    <AdminNavbar />

    <main class="max-w-7xl mx-auto px-6 py-10">
      <!-- Top Action Bar -->
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
        <div>
          <h1 class="font-calsans text-3xl font-bold uppercase tracking-tight">Admin Console</h1>
          <p class="text-xs text-brand-gray-muted mt-1">Manage product drops, inventory status, and early-access waitlists.</p>
        </div>

        <button
          v-if="activeTab === 'sneakers'"
          @click="handleOpenCreate"
          type="button"
          class="inline-flex items-center gap-2 bg-brand-volt text-brand-black border border-brand-black px-4 py-2 text-xs font-calsans font-bold uppercase tracking-wider hover:brightness-95 transition-all shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] cursor-pointer"
        >
          <i class="ri-add-line text-base font-bold"></i>
          <span>Add New Drop</span>
        </button>
      </div>

      <!-- Tabs Navigation -->
      <div class="flex items-center gap-2 border-b border-brand-black mb-6">
        <button
          @click="activeTab = 'sneakers'"
          type="button"
          class="px-5 py-2.5 font-calsans text-xs uppercase tracking-wider font-bold border-t border-x transition-colors cursor-pointer"
          :class="activeTab === 'sneakers' ? 'bg-white border-brand-black -mb-[1px] text-brand-black' : 'border-transparent text-neutral-500 hover:text-black'"
        >
          Sneaker Drops ({{ sneakers.length }})
        </button>
        <button
          @click="activeTab = 'waitlist'"
          type="button"
          class="px-5 py-2.5 font-calsans text-xs uppercase tracking-wider font-bold border-t border-x transition-colors cursor-pointer"
          :class="activeTab === 'waitlist' ? 'bg-white border-brand-black -mb-[1px] text-brand-black' : 'border-transparent text-neutral-500 hover:text-black'"
        >
          Waitlist Signups ({{ waitlist.length }})
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="p-12 text-center text-xs font-satoshi text-brand-gray-muted">
        Loading console data...
      </div>

      <!-- Tab Views -->
      <div v-else>
        <SneakerTable
          v-if="activeTab === 'sneakers'"
          :sneakers="sneakers"
          @edit="handleOpenEdit"
          @delete="handleDeleteSneaker"
        />
        <WaitlistTable
          v-else-if="activeTab === 'waitlist'"
          :waitlist="waitlist"
        />
      </div>
    </main>

    <!-- Create / Edit Modal -->
    <SneakerFormModal
      v-if="isModalOpen"
      :sneaker="editingSneaker"
      :loading="modalLoading"
      @close="handleCloseModal"
      @save="handleSaveSneaker"
    />
  </div>
</template>