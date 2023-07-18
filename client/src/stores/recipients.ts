import { computed, reactive, ref } from 'vue'
import { defineStore } from 'pinia'
import { getRecipients, type RecipientSummary } from '@/api/recipients'

type SortDir = 'asc' | 'desc'
type SortField = keyof RecipientSummary

export type Status = {
  name: string
  label: string
  enabled?: boolean
}

export const useRecipientsStore = defineStore('recipients', () => {
  const rawRecipients = ref<RecipientSummary[]>([])
  const sortField = ref<SortField>('name')
  const sortDir = ref<SortDir>('asc')
  const filteredBase = ref('0')
  const filteredName = ref('')
  const filteredStatus: Status[] = reactive([
    { label: 'Active', name: 'active', enabled: false },
    { label: 'Pending', name: 'pending', enabled: false },
    { label: 'On Hold', name: 'on_hold', enabled: false },
    { label: 'Archived', name: 'archived', enabled: false },
  ])
  const filteredStatusNames = computed(() => {
    return filteredStatus
      .filter((s: Status) => s.enabled)
      .map((s: Status) => s.name)
  })

  function resetFilters() {}

  function setSort(field: SortField): void {
    if (field !== sortField.value) {
      sortField.value = field
      sortDir.value = 'asc'
      return
    }

    if (sortDir.value === 'asc') {
      sortDir.value = 'desc'
    } else {
      sortDir.value = 'asc'
    }
  }

  async function fetchRecipients() {
    await getRecipients().then((data) => (rawRecipients.value = data))
  }

  function sortRecipients(a: RecipientSummary, b: RecipientSummary) {
    const dir = sortDir.value
    const key = sortField.value

    if (dir === 'asc') {
      return a[key].localeCompare(b[key])
    } else {
      return b[key].localeCompare(a[key])
    }
  }

  const recipients = computed(() => rawRecipients.value.sort(sortRecipients))

  return {
    fetchRecipients,
    filteredBase,
    filteredName,
    filteredStatus,
    filteredStatusNames,
    recipients,
    resetFilters,
    setSort,
    sortDir,
    sortField,
  }
})
