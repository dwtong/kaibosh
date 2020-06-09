<template>
  <ValidatedForm @submit="submit">
    <div class="box">
      <h1 class="title">Organisation Details</h1>

      <ValidatedInput label="name" v-model="recipientDetails.name" :rules="{ required: true }" />
      <BaseSelect v-model="recipientDetails.baseId" label="Kaibosh base" required="true" />
      <AddressField v-model="recipientDetails.physicalAddress" label="Physical address" />
      <DateField name="start date" v-model="recipientDetails.startedAt" />
      <ValidatedInput label="description" v-model="recipientDetails.description" type="textarea" />
    </div>

    <div class="box">
      <h1 class="title">Primary Contact Details</h1>

      <ValidatedInput label="contact name" v-model="recipientDetails.primaryContact.name" />
      <ValidatedInput label="contact email" v-model="recipientDetails.primaryContact.email" :rules="{ email: true }" />
      <ValidatedInput label="contact landline" v-model="recipientDetails.primaryContact.phoneLandline" />
      <ValidatedInput label="contact mobile" v-model="recipientDetails.primaryContact.phoneMobile" />
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
import DateField from "@/components/ui/DateField.vue";
import ValidatedInput from "@/components/ui/ValidatedInput.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";
import { IRecipient } from "@/types";
import { defaultRecipientDetails } from "@/store/modules/active-recipient";

@Component({ components: { AddressField, BaseSelect, DateField, ValidatedForm, ValidatedInput } })
export default class RecipientForm extends Vue {
  @Prop(Object) readonly recipient!: IRecipient;
  recipientDetails!: IRecipient;

  @Emit()
  submit(): IRecipient {
    return this.recipientDetails;
  }

  async created() {
    this.recipientDetails = this.recipient ? { ...this.recipient } : { ...defaultRecipientDetails };
  }
}
</script>
