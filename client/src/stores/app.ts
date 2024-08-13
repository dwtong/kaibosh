import { ref } from "vue"
import { defineStore } from "pinia"
import { getBases } from "@/api/bases"

export type Base = {
  id: string
  name: string
}

export const useAppStore = defineStore("app", () => {
  const bases = ref<Base[]>()

  async function fetchBases() {
    await getBases().then((data) => (bases.value = data))
  }

  return { bases, fetchBases }
})
