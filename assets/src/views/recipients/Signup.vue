<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <ValidatedForm @submit="createRecipient">
        <div class="box">
          <h1 class="title">Organisation Details</h1>

          <ValidatedInput
            v-model="recipientDetails.name"
            label="name"
            :rules="{ required: true }"
            help="The legal name of your organisation."
          />
          <BaseSelect
            v-model="recipientDetails.baseId"
            label="Kaibosh base"
            required="true"
            help="The Kaibosh location that is closest to you."
          />
          <AddressField
            v-model="recipientDetails.physicalAddress"
            label="Physical address"
            help="Where your organisation premises are located."
          />
          <ValidatedInput
            v-model="recipientDetails.description"
            label="description"
            type="textarea"
            help="Tell us a bit about your organisation and who you serve."
          />
        </div>

        <div class="box">
          <h1 class="title">Primary Contact Details</h1>

          <ValidatedInput
            v-model="recipientDetails.contact.name"
            label="contact name"
            help="Name of the person that we can contact."
          />
          <ValidatedInput
            v-model="recipientDetails.contact.email"
            label="contact email"
            :rules="{ email: true }"
            help="Primary contact email for your organisation."
          />
          <ValidatedInput
            v-model="recipientDetails.contact.phoneLandline"
            label="contact landline"
            help="Contact landline for your organisation."
          />
          <ValidatedInput
            v-model="recipientDetails.contact.phoneMobile"
            label="contact mobile"
            help="Contact mobile for your primary point of contact."
          />
        </div>
        <button type="submit" class="button is-primary is-pulled-right">
          Save Recipient
        </button>
      </ValidatedForm>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import { IRecipient } from "@/types";
import { Route } from "vue-router/types/router";
import AddressField from "@/components/ui/AddressField.vue";
import BaseSelect from "@/components/ui/BaseSelect.vue";
import ValidatedDate from "@/components/ui/ValidatedDate.vue";
import ValidatedInput from "@/components/ui/ValidatedInput.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";
import { defaultRecipientDetails } from "@/store/modules/active-recipient";

@Component({ components: { AddressField, BaseSelect, ValidatedDate, ValidatedForm, ValidatedInput } })
export default class CreateRecipient extends Vue {
  recipientDetails: IRecipient = {
    ...defaultRecipientDetails,
    contact: { ...defaultRecipientDetails.contact }
  };

  async createRecipient(params: IRecipient) {}
}
</script>
