import { ref } from "vue"
import { defineStore } from "pinia"
import { getBases, type Base } from "@/api/bases"
import { getCategories } from "@/api/categories"

export const useAppStore = defineStore("app", () => {
  const bases = ref<Base[]>()
  const categories = ref<Base[]>()
  const isLoading = ref(false)

  async function fetchBases() {
    if (bases.value?.length) return
    await getBases().then((data) => (bases.value = data))
  }

  async function fetchCategories() {
    if (categories.value?.length) return
    await getCategories().then((data) => (categories.value = data))
  }

  function getBaseName(baseId?: number | string): string {
    if (!baseId || !bases.value || bases.value.length === 0) return ""
    return bases.value.find((b) => b.id == baseId)?.name || ""
  }

  function getCategoryName(categoryId?: number | string): string {
    if (!categoryId || !categories.value || categories.value.length === 0) {
      return ""
    }
    const name = categories.value.find((c) => c.id == categoryId)?.name || ""
    return name
  }

  function setIsLoading(value: boolean) {
    isLoading.value = value
  }

  return {
    bases,
    categories,
    fetchBases,
    fetchCategories,
    getBaseName,
    getCategoryName,
    setIsLoading,
    isLoading,
  }
})
