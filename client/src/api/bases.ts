import api from "./api"

export type Base = {
  id: string
  name: string
}

export async function getBases(): Promise<Base[]> {
  return api.get<Base[]>("bases").then(({ data }) => data)
}
