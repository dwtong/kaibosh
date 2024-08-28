<script setup lang="ts">
import {
  type Notification,
  listNotifications,
  createNotification,
  deleteNotification,
} from "@/api/user-notification"
import { ref } from "vue"
import CheckBox from "../ui/CheckBox.vue"

const notifications = ref<Notification[]>()
listNotifications().then((values) => (notifications.value = values))

function toggleValue(checked: boolean, id: string) {
  checked ? createNotification(id) : deleteNotification(id)
}
</script>

<template>
  <CheckBox
    v-for="notification in notifications"
    :key="notification.id"
    :value="notification.enabled"
    :label="notification.name"
    @input="(value: boolean) => toggleValue(value, notification.id)"
  />
</template>
