import api from "./api"

export type Category = {
  id: string
  name: string
  imageName: string
  unit: string
}

export async function getCategories(): Promise<Category[]> {
  return api.get<Category[]>("categories").then(({ data }) => data)
}
