import api from "./api"

export type LoginParams = {
  email: string
  password: string
}

export type ResetPasswordParams = {
  email: string
}

export type UpdatePasswordParams = {
  password: string
  token: string
}

export type AuthResponse = {
  message: string
}

export type UpdatePasswordResponse = AuthResponse & {
  email: string
}

export async function signIn(params: LoginParams): Promise<AuthResponse> {
  return api.post<AuthResponse>("auth/sign_in", params).then(({ data }) => data)
}

export async function signOut(): Promise<void> {
  return api.delete("auth/sign_out")
}

export async function resetPassword(
  params: ResetPasswordParams,
): Promise<AuthResponse> {
  return api
    .post<AuthResponse>("auth/reset_password", params)
    .then(({ data }) => data)
}

export async function updatePassword(
  params: UpdatePasswordParams,
): Promise<UpdatePasswordResponse> {
  return api
    .put<UpdatePasswordResponse>("auth/update_password", params)
    .then(({ data }) => data)
}
