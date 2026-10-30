<script setup>
const props = defineProps({
  waitlist: {
    type: Array,
    required: true,
  },
})

const formatDate = (isoStr) => {
  if (!isoStr) return '-'
  return new Date(isoStr).toLocaleDateString('en-IN', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  })
}
</script>

<template>
  <div class="bg-white border border-brand-black overflow-x-auto shadow-sm">
    <table class="w-full text-left border-collapse min-w-[600px]">
      <thead>
        <tr class="border-b border-brand-black bg-brand-gray-light font-calsans text-xs uppercase tracking-wider text-brand-black">
          <th class="p-4">User Email</th>
          <th class="p-4">Drop Interested In</th>
          <th class="p-4">Registered Date</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-neutral-200 text-sm">
        <tr v-if="waitlist.length === 0">
          <td colspan="3" class="p-8 text-center text-brand-gray-muted text-xs">
            No waitlist registrations recorded yet.
          </td>
        </tr>
        <tr v-for="entry in waitlist" :key="entry.id" class="hover:bg-neutral-50 transition-colors">
          <td class="p-4 font-satoshi font-semibold text-brand-black">{{ entry.email }}</td>
          <td class="p-4 font-calsans text-xs text-brand-black font-bold">
            {{ entry.sneakers?.name || 'Unknown / Deleted Drop' }}
          </td>
          <td class="p-4 font-satoshi text-xs text-brand-gray-muted">
            {{ formatDate(entry.created_at) }}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>