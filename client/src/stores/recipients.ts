import { computed, reactive, ref } from "vue"
import { defineStore } from "pinia"
import {
  destroyRecipient,
  getRecipient,
  getRecipients,
  putRecipient,
  type Recipient,
  type RecipientSummary,
} from "@/api/recipients"

type SortDir = "asc" | "desc"
type SortField = keyof RecipientSummary

export type Status = {
  name: string
  label: string
  enabled: boolean
}

export const useRecipientsStore = defineStore("recipients", () => {
  const rawRecipients = ref<RecipientSummary[]>([])
  const recipient = ref<Recipient>()
  const sortField = ref<SortField>("name")
  const sortDir = ref<SortDir>("asc")
  const initialFilters = {
    base: "0",
    name: "",
    status: [
      { label: "Active", name: "active", enabled: false },
      { label: "Pending", name: "pending", enabled: false },
      { label: "On Hold", name: "on_hold", enabled: false },
      { label: "Archived", name: "archived", enabled: false },
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

  function setFilteredStatus(name: string, value: boolean) {
    const index = filteredStatus.findIndex((s) => s.name === name)
    filteredStatus[index].enabled = value
  }

  function setFilteredBase(value: number): void {
    filteredBase.value = value.toString()
  }

  function setFilteredName(value: string): void {
    filteredName.value = value
  }

  function setSort(field: SortField): void {
    if (field !== sortField.value) {
      sortField.value = field
      sortDir.value = "asc"
      return
    }

    if (sortDir.value === "asc") {
      sortDir.value = "desc"
    } else {
      sortDir.value = "asc"
    }
  }

  async function fetchRecipient(id: string) {
    await getRecipient(id).then((data) => (recipient.value = data))
  }

  async function archiveRecipient(id: string) {
    await destroyRecipient(id).then((data) => (recipient.value = data))
  }

  async function updateRecipient(id: string, params: Partial<Recipient>) {
    await putRecipient(id, params).then((data) => (recipient.value = data))
  }

  async function fetchRecipients() {
    await getRecipients().then((data) => (rawRecipients.value = data))
  }

  function sortRecipients(a: RecipientSummary, b: RecipientSummary): number {
    const dir = sortDir.value
    const key = sortField.value
    const valA = a[key].toString()
    const valB = b[key].toString()

    if (dir === "asc") {
      return valA.localeCompare(valB)
    } else {
      return valB.localeCompare(valA)
    }
  }

  function filterRecipients(recipient: RecipientSummary): boolean {
    const matchesName = recipient.name
      .toLowerCase()
      .includes(filteredName.value.toLowerCase())

    const matchesBase =
      filteredBase.value === "0" ||
      recipient.baseId.toString() === filteredBase.value

    const matchesStatus =
      filteredStatusNames.value.length === 0 ||
      filteredStatusNames.value.includes(recipient.status)

    return matchesName && matchesBase && matchesStatus
  }

  const recipients = computed(() => {
    return rawRecipients.value.sort(sortRecipients).filter(filterRecipients)
  })

  const recipientStatus = computed(() => recipient.value?.status)

  return {
    archiveRecipient,
    fetchRecipient,
    fetchRecipients,
    filteredBase,
    filteredName,
    filteredStatus,
    filteredStatusNames,
    recipient,
    recipientStatus,
    recipients,
    resetFilters,
    setFilteredBase,
    setFilteredName,
    setFilteredStatus,
    setSort,
    sortDir,
    sortField,
    updateRecipient,
  }
})
