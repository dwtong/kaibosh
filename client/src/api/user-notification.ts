import api from "./api"

// FIXME Currently API ignores user ID but it is still required
const resource = "users/1/notifications"

export type Notification = {
  id: string
  name: string
  enabled: boolean
}

export async function listNotifications(): Promise<Notification[]> {
  return api.get<Notification[]>(resource).then(({ data }) => data)
}
export async function createNotification(baseId: string): Promise<void> {
  return api.post(`${resource}/`, { baseId: baseId })
}

export async function deleteNotification(
  notificationId: string,
): Promise<void> {
  return api.delete(`${resource}/${notificationId}`)
}
