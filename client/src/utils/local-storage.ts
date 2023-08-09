export function authTokenIsPresent(): boolean {
  return !!window.localStorage.getItem("authorization")
}

export function saveAuthTokenFromUrlParams(): void {
  const urlParams = new URLSearchParams(window.location.search)
  const authorization = urlParams.get("authorization")

  if (authorization) {
    localStorage.setItem("authorization", authorization)
  }
}

export function saveAuthToken(authToken: string) {
  localStorage.setItem("authorization", authToken)
}

export function loadAuthToken(): string {
  return window.localStorage.getItem("authorization") ?? ""
}

export function deleteAuthToken(): void {
  localStorage.removeItem("authorization")
}
