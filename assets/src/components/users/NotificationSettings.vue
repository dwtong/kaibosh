<template>
  <div>
    <Checkbox
      v-for="notification in notifications"
      :key="notification.id"
      :label="notification.name"
      :value="notification.enabled"
      @input="toggleValue(notification.id, $event)"
    />
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import Checkbox from "@/components/ui/Checkbox.vue";
import App from "@/store/modules/app";
import UserNotificationService from "@/services/user-notification-service"

@Component({ components: { Checkbox } })
export default class NotificationSettings extends Vue {
  notifications = []
  isEnabled(baseId: string) {
    // Is member of list from API
    return true;
  }

  async created() {
    this.notifications = await UserNotificationService.list()
  }

  toggleValue(id: string, value: boolean) {
    if (value) {
      UserNotificationService.create(id);
    } else {
      UserNotificationService.delete(id);
    }
  }
}
</script>
