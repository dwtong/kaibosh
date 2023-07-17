import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { getRecipients, type RecipientSummary } from '@/api/recipients'

type SortDir = 'asc' | 'desc'
type SortField = keyof RecipientSummary

export const useRecipientsStore = defineStore('recipients', () => {
  const rawRecipients = ref<RecipientSummary[]>([])
  const sortField = ref<SortField>('name')
  const sortDir = ref<SortDir>('asc')

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

  return { fetchRecipients, recipients, setSort, sortDir, sortField }
})
