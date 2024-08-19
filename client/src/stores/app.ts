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

  function setIsLoading(value: boolean) {
    isLoading.value = value
  }

  return { bases, fetchBases, setIsLoading, isLoading }
})
