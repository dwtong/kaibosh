<template>
  <div>
    <ValidatedInput
      label="Password"
      :value="value"
      @input="input"
      type="password"
      :validation="{ min: 8, required: true }"
    />
    <ValidatedInput
      v-if="withConfirmation"
      v-model="confirmationValue"
      label="Password confirmation"
      type="password"
      :validation="{ is: this.value, required: true }"
    />
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Emit, Prop } from "vue-property-decorator";
import ValidatedInput from "@/components/ui/ValidatedInput.vue";

@Component({ components: { ValidatedInput } })
export default class PasswordField extends Vue {
  @Prop({ default: false }) readonly withConfirmation!: boolean;
  @Prop() readonly value!: string;
  confirmationValue = "";

  @Emit()
  input(event: Event) {
    return event;
  }
}
</script>
