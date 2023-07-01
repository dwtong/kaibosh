import api from './api'

export type User = {
  email: string
}

export type NewUserParams = User

export type UpdateUserParams = {
  password: string
}

export async function getUsers(): Promise<User[]> {
  return api.get<User[]>('users').then(({ data }) => data)
}

export async function postUser(user: NewUserParams): Promise<User> {
  return api.post<User>('users/', { user }).then(({ data }) => data)
}

export async function putUser(user: UpdateUserParams): Promise<User> {
  return api.put<User>('users/me', { user }).then(({ data }) => data)
}
