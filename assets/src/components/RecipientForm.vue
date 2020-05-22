<template>
  <form @submit.prevent="submit">
    <b-loading :active.sync="isLoading"></b-loading>
    <div class="box">
      <h1 class="title">Organisation Details</h1>

      <InputField name="name" v-model="recipient.name" required="true" />
      <BaseSelect v-model="recipient.base_id" label="Kaibosh base" required="true" />
      <AddressField v-model="recipient.physical_address" label="Physical address" />
      <DateField name="start date" v-model="startedAt" />
      <InputField name="description" v-model="recipient.description" type="textarea" />
    </div>

    <div class="box">
      <h1 class="title">Primary Contact Details</h1>

      <InputField name="contact-name" v-model="contact.name" />
      <InputField name="contact-email" v-model="contact.email" />
      <InputField name="contact-landline" v-model="contact.phone_landline" />
      <InputField name="contact-mobile" v-model="contact.phone_mobile" />
    </div>
    <button type="submit" class="button is-primary is-pulled-right">
      Save Recipient
    </button>
  </form>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import AddressField from "@/components/form/AddressField.vue";
import BaseSelect from "@/components/form/BaseSelect.vue";
import DateField from "@/components/form/DateField.vue";
import InputField from "@/components/form/InputField.vue";
import { IContact, IRecipient } from "@/types";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import toast from "@/helpers/toast";

@Component({
  components: { AddressField, BaseSelect, DateField, InputField },
  $_veeValidate: { validator: "new" }
})
export default class RecipientForm extends Vue {
  @Prop(String) readonly recipientId!: string;

  recipient: IRecipient = {
    name: ""
  };

  contact: IContact = {
    name: "",
    email: "",
    phone_landline: "",
    phone_mobile: ""
  };

  startedAt: Date | null = null;
  isLoading = true;

  async submit() {
    const formIsValid = await this.$validator.validateAll();

    if (formIsValid) {
      this.saveRecipient();
    } else {
      toast.error("Failed to save recipient.", true);
    }
  }

  async created() {
    if (this.recipientId) {
      await ActiveRecipientModule.fetchRecipient(this.recipientId);
      this.recipient = ActiveRecipientModule.details;

      if (ActiveRecipientModule.details.primary_contact) {
        this.contact = { ...ActiveRecipientModule.details.primary_contact };
      }

      if (ActiveRecipientModule.details.started_at) {
        // TODO: Handle date formatting consistently - either format in backend or frontend
        // @ts-ignore
        const dateValues = ActiveRecipientModule.details.started_at.split("/");
        this.startedAt = new Date(dateValues[2], dateValues[1] - 1, dateValues[0]);
      }
    }

    this.isLoading = false;
  }

  async saveRecipient() {
    const params = {
      primary_contact_attributes: this.contact,
      ...this.recipient
    };

    if (this.startedAt) {
      params.started_at = this.startedAt;
    }

    if (this.recipientId) {
      await ActiveRecipientModule.updateRecipient(params);
      this.$router.push(`/recipients/${this.recipientId}`);
      toast.success("Recipient updated.");
    } else {
      await ActiveRecipientModule.createRecipient(params);

      if (ActiveRecipientModule.details.id) {
        this.$router.push(`/recipients/${ActiveRecipientModule.details.id}`);
        toast.success("Recipient created.");
      }
    }
  }
}
</script>
