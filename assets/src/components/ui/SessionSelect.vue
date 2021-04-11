<template>
  <ValidatedSelect
    :rules="{ required: required }"
    :value="value"
    name="Session"
    placeholder="Select an option"
    expanded
    @input="$emit('input', $event)"
  >
    <option v-for="session in sessions" :key="session.id" :value="session.id">
      <SessionLabel :session="session" />
    </option>
  </ValidatedSelect>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Sessions from "@/store/modules/sessions";
import SessionLabel from "@/components/ui/SessionLabel.vue";
import ValidatedSelect from "@/components/ui/ValidatedSelect.vue";

export default defineComponent({
  components: {
    SessionLabel,
    ValidatedSelect
  },
  props: {
    required: {
      type: Boolean,
      default: false
    },
    label: {
      type: String,
      default: ""
    },
    recipientSessions: {
      type: Array,
      required: true
    },
    value: {
      type: String,
      required: true
    }
  },
  emits: ["input"],
  data() {
    return {
      sessions: Sessions.sortedList
    };
  }
});
</script>
