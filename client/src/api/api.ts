import Axios from "axios"
import camelCaseKeys from "camelcase-keys"
import snakeCaseKeys from "snakecase-keys"
import { loadAuthToken, saveAuthToken } from "@/utils/local-storage"
import { useAuthStore } from "@/stores/auth"

const baseURL = "http://localhost:4000/api"

const api = Axios.create({
  baseURL,
  headers: { "Content-Type": "application/json" },
})

api.defaults.transformResponse = [
  (data, headers) => {
    if (data && headers?.["content-type"].includes("application/json")) {
      return camelCaseKeys(JSON.parse(data), { deep: true })
    } else {
      return data
    }
  },
]

api.defaults.transformRequest = [
  (data, headers) => {
    if (
      data &&
      headers.get("Content-Type")?.toString().includes("application/json")
    ) {
      return JSON.stringify(snakeCaseKeys(data, { deep: true }))
    } else {
      return data
    }
  },
]

api.interceptors.request.use((config) => {
  config.headers.Authorization = loadAuthToken()

  if (config.params) {
    config.params = snakeCaseKeys(config.params, { deep: true })
  }

  return config
})

api.interceptors.response.use(
  (response) => {
    const authToken = response.headers.authorization
    if (authToken) {
      saveAuthToken(authToken)
    }
    return response
  },
  (error) => {
    console.error(error)
    const authToken = error.response.headers?.authorization
    const authStore = useAuthStore()

    if (error.response?.status === 401) {
      authStore.logout()
    } else if (authToken && error.response?.headers.client) {
      saveAuthToken(authToken)
    }
    return error
  },
)

export default api
