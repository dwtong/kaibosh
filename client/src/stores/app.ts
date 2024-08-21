import { ref } from "vue"
import { defineStore } from "pinia"
import { getBases, type Base } from "@/api/bases"
import { getCategories, type Category } from "@/api/categories"
import { sortBy } from "es-toolkit"

export const useAppStore = defineStore("app", () => {
  const bases = ref<Base[]>()
  const categories = ref<Category[]>()
  const isLoading = ref(false)

  async function fetchBases() {
    if (bases.value?.length) return
    await getBases().then((data) => (bases.value = data))
  }

  async function fetchCategories() {
    if (categories.value?.length) return
    await getCategories().then((data) => {
      const sortedCategories = sortBy(data, [(c) => c.name])
      categories.value = sortedCategories
    })
  }

  function getBaseName(baseId?: number | string): string {
    if (!baseId || !bases.value || bases.value.length === 0) return ""
    return bases.value.find((b) => b.id == baseId)?.name || ""
  }

  function getCategoryName(categoryId?: number | string): string {
    if (!categoryId || !categories.value || categories.value.length === 0) {
      return ""
    }
    return categories.value.find((c) => c.id == categoryId)?.name || ""
  }

  function getCategoryUnit(categoryId?: number | string): string {
    if (!categoryId || !categories.value || categories.value.length === 0) {
      return ""
    }
    return categories.value.find((c) => c.id == categoryId)?.unit || ""
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
    getCategoryUnit,
    setIsLoading,
    isLoading,
  }
})
