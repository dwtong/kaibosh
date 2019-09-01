<template>
  <div class="field">
    <Checkbox :label="label" :value="value" @input="toggleValue" />
  </div>
</template>

<script lang="ts">
import { Component, Inject, Prop } from "vue-property-decorator";
import Checkbox from "@/components/form/Checkbox.vue";
import Vue from "vue";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";

@Component({ components: { Checkbox } })
export default class OnboardingCheckbox extends Vue {
  @Prop() readonly id!: string;
  @Prop() readonly name!: string;
  @Prop() readonly value!: boolean;
  @Prop({ default: "" }) readonly label!: string;

  async toggleValue(event: any) {
    await ActiveRecipientModule.updateRecipient({
      id: this.id,
      [this.name]: !this.value
    });
  }
}
</script>
