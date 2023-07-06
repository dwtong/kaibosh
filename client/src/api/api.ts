import Axios from 'axios'
import camelCaseKeys from 'camelcase-keys'
import snakeCaseKeys from 'snakecase-keys'
import {
  deleteAuthToken,
  loadAuthToken,
  saveAuthToken,
} from '@/utils/local-storage'
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'
// import toast from "@/helpers/toast"
// import { UserModule } from "@/store/modules/user"

const baseURL = 'http://localhost:4000/api'

const api = Axios.create({
  baseURL,
  headers: { 'Content-Type': 'application/json' },
})

api.defaults.transformResponse = [
  (data, headers) => {
    if (data && headers?.['content-type'].includes('application/json')) {
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
      headers.get('Content-Type')?.toString().includes('application/json')
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
    console.log(error)
    const authToken = error.response.headers.authorization
    const authStore = useAuthStore()

    if (error.response?.status === 401) {
      authStore.logout()
      deleteAuthToken()
    } else if (authToken && error.response?.headers.client) {
      saveAuthToken(authToken)
    }
    return error
  },
)

export default api
