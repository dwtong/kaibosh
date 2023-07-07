<script setup lang="ts">
import {
  type Notification,
  listNotifications,
  createNotification,
  deleteNotification,
} from '@/api/user-notification'
import { ref } from 'vue'

const notifications = ref<Notification[]>()
listNotifications().then((values) => (notifications.value = values))

function toggleValue(checked: boolean, id: string) {
  checked ? createNotification(id) : deleteNotification(id)
}
</script>

<template>
  <div>
    <label
      v-for="notification in notifications"
      :key="notification.id"
      class="checkbox"
    >
      <input
        :id="notification.id"
        v-model="notification.enabled"
        type="checkbox"
        @input="(e) => toggleValue((e.target as HTMLInputElement).checked,
          notification.id)"
      />
      {{ notification.name }}
    </label>
  </div>
</template>
