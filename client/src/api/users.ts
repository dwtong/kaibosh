import { get, post, put } from './api'

const resource = 'users'

export function getUsers() {
  return get(resource)
}

export function postUser(email: string) {
  return post(`${resource}/`, { user: { email } })
}

export function putUser(user: any) {
  return put(`${resource}/me`, { user })
}
