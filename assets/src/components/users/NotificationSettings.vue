<template>
  <div>
    <NotificationCheckbox
      v-for="notification in notifications"
      :key="notification.id"
      :id="notification.id"
      :label="notification.name"
      :value="notification.enabled"
    />
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import NotificationCheckbox from "@/components/ui/NotificationCheckbox.vue";
import App from "@/store/modules/app";
import UserNotificationService from "@/services/user-notification-service"

@Component({ components: { NotificationCheckbox } })
export default class NotificationSettings extends Vue {
  notifications = []
  isEnabled(baseId: string) {
    // Is member of list from API
    return true;
  }

  async created() {
    this.notifications = await UserNotificationService.list()
  }
}
</script>
