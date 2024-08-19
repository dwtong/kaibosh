import { ref } from "vue"
import { defineStore } from "pinia"
import { getBases } from "@/api/bases"

export type Base = {
  id: string
  name: string
}

export const useAppStore = defineStore("app", () => {
  const bases = ref<Base[]>()
  const isLoading = ref(false)

  async function fetchBases() {
    await getBases().then((data) => (bases.value = data))
  }

  function getBaseName(id?: number | string): string {
    if (!id || !bases.value || bases.value.length === 0) return ""
    return bases.value.find((b) => b.id == id)?.name || ""
  }

  function setIsLoading(value: boolean) {
    isLoading.value = value
  }

  return { bases, fetchBases, getBaseName, setIsLoading, isLoading }
})
