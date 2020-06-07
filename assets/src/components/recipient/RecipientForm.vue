<template>
  <ValidatedForm @submit="submit">
    <div class="box">
      <h1 class="title">Organisation Details</h1>

      <ValidatedInput label="name" v-model="recipient.name" :rules="{ required: true }" />
      <BaseSelect v-model="recipient.baseId" label="Kaibosh base" required="true" />
      <AddressField v-model="recipient.physicalAddress" label="Physical address" />
      <DateField name="start date" v-model="startedAt" />
      <ValidatedInput label="description" v-model="recipient.description" type="textarea" />
    </div>

    <div class="box">
      <h1 class="title">Primary Contact Details</h1>

      <ValidatedInput label="contact name" v-model="contact.name" />
      <ValidatedInput label="contact email" v-model="contact.email" />
      <ValidatedInput label="contact landline" v-model="contact.phoneLandline" />
      <ValidatedInput label="contact mobile" v-model="contact.phoneMobile" />
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
import { IContact, IRecipient } from "@/types";

@Component({ components: { AddressField, BaseSelect, DateField, ValidatedForm, ValidatedInput } })
export default class RecipientForm extends Vue {
  @Prop(String) readonly recipientId!: string;

  recipient: IRecipient = {
    name: ""
  };

  contact: IContact = {
    name: "",
    email: "",
    phoneLandline: "",
    phoneMobile: ""
  };

  startedAt: Date = new Date();

  @Emit()
  submit(): IRecipient {
    return { primaryContact: this.contact, startedAt: this.startedAt, ...this.recipient };
  }

  async created() {
    if (this.recipient.primaryContact) {
      this.contact = { ...this.recipient.primaryContact };
    }

    if (this.recipient.startedAt) {
      this.startedAt = this.recipient.startedAt;
    }
  }
}
</script>
