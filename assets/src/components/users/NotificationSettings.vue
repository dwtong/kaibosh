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
import { defineComponent } from "vue";
import Checkbox from "@/components/ui/Checkbox.vue";
import UserNotificationService from "@/services/user-notification-service";

export default defineComponent({
  components: {
    Checkbox
  },
  props: {},
  async setup() {
    const notifications = await UserNotificationService.list();

    return {
      notifications
    };
  },
  methods: {
    toggleValue(id: string, value: boolean) {
      if (value) {
        UserNotificationService.create(id);
      } else {
        UserNotificationService.delete(id);
      }
    }
  }
});
</script>
