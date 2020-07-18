<template>
  <ValidatedForm @submit="submit">
    <div class="box">
      <h1 class="title">Organisation Details</h1>

      <ValidatedInput v-model="recipientDetails.name" label="name" :rules="{ required: true }" />
      <BaseSelect v-model="recipientDetails.baseId" label="Kaibosh base" required="true" />
      <AddressField v-model="recipientDetails.physicalAddress" label="Physical address" />
      <ValidatedDate v-model="recipientDetails.startedAt" label="start date" />
      <ValidatedInput v-model="recipientDetails.description" label="description" type="textarea" />
    </div>

    <div class="box">
      <h1 class="title">Primary Contact Details</h1>

      <ValidatedInput v-model="recipientDetails.contact.name" label="contact name" />
      <ValidatedInput v-model="recipientDetails.contact.email" label="contact email" :rules="{ email: true }" />
      <ValidatedInput v-model="recipientDetails.contact.phoneLandline" label="contact landline" />
      <ValidatedInput v-model="recipientDetails.contact.phoneMobile" label="contact mobile" />
    </div>
    <button type="submit" class="button is-primary is-pulled-right">
      Save Recipient
    </button>
  </ValidatedForm>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Emit, Prop } from "vue-property-decorator";
import AddressField from "@/components/ui/AddressField.vue";
import BaseSelect from "@/components/ui/BaseSelect.vue";
import ValidatedDate from "@/components/ui/ValidatedDate.vue";
import ValidatedInput from "@/components/ui/ValidatedInput.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";
import { IRecipient } from "@/types";
import { defaultRecipientDetails } from "@/store/modules/active-recipient";

@Component({ components: { AddressField, BaseSelect, ValidatedDate, ValidatedForm, ValidatedInput } })
export default class RecipientForm extends Vue {
  @Prop(Object) readonly recipient!: IRecipient;
  recipientDetails: IRecipient = { ...defaultRecipientDetails, contact: { ...defaultRecipientDetails.contact } };

  @Emit()
  submit(): IRecipient {
    return this.recipientDetails;
  }

  async created() {
    if (this.recipient) {
      this.recipientDetails = { ...this.recipient, contact: { ...this.recipient.contact } };
    }
  }
}
</script>
