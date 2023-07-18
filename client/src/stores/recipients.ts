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
  const initialFilters = {
    base: '0',
    name: '',
    status: [
      { label: 'Active', name: 'active', enabled: false },
      { label: 'Pending', name: 'pending', enabled: false },
      { label: 'On Hold', name: 'on_hold', enabled: false },
      { label: 'Archived', name: 'archived', enabled: false },
    ],
  }

  const filteredBase = ref(initialFilters.base)
  const filteredName = ref(initialFilters.name)
  const filteredStatus: Status[] = reactive(initialFilters.status)

  const filteredStatusNames = computed(() => {
    return filteredStatus
      .filter((s: Status) => s.enabled)
      .map((s: Status) => s.name)
  })

  function resetFilters() {
    filteredName.value = initialFilters.name
    filteredBase.value = initialFilters.base
    filteredStatus.forEach((s) => (s.enabled = false))
  }

  function setFilteredName(value: string): void {
    filteredName.value = value
  }

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

  function sortRecipients(a: RecipientSummary, b: RecipientSummary): number {
    const dir = sortDir.value
    const key = sortField.value

    if (dir === 'asc') {
      return a[key].localeCompare(b[key])
    } else {
      return b[key].localeCompare(a[key])
    }
  }

  function filterRecipients(recipient: RecipientSummary): boolean {
    const matchesFilter = recipient.name
      .toLowerCase()
      .includes(filteredName.value.toLowerCase())

    return matchesFilter
  }

  const recipients = computed(() => {
    return rawRecipients.value.sort(sortRecipients).filter(filterRecipients)
  })

  return {
    fetchRecipients,
    filteredBase,
    filteredName,
    filteredStatus,
    filteredStatusNames,
    recipients,
    resetFilters,
    setFilteredName,
    setSort,
    sortDir,
    sortField,
  }
})
