import api from "./api"

export type Category = {
  id: string
  name: string
}

export async function getCategories(): Promise<Category[]> {
  return api.get<Category[]>("categories").then(({ data }) => data)
}
