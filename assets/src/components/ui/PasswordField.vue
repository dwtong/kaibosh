<template>
  <div>
    <ValidatedInput
      label="Password"
      :value="value"
      type="password"
      :rules="{ min: 8, required: true }"
      @input="$emit('input', $event)"
    />
    <ValidatedInput
      v-if="withConfirmation"
      v-model="confirmationValue"
      label="Password confirmation"
      type="password"
      :rules="{ is: value, required: true }"
    />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import ValidatedInput from "@/components/ui/ValidatedInput.vue";

export default defineComponent({
  components: {
    ValidatedInput
  },
  props: {
    withConfirmation: {
      type: Boolean,
      default: false
    },
    value: {
      type: String,
      required: true
    }
  },
  emits: ["input"],
  data() {
    return {
      confirmationValue: ""
    };
  }
});
</script>
