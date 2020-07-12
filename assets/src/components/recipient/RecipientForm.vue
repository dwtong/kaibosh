<template>
  <form @submit.prevent="submit">
    <b-loading :active.sync="isLoading"></b-loading>
    <div class="box">
      <h1 class="title">Organisation Details</h1>

      <InputField name="name" v-model="recipient.name" required="true" />
      <BaseSelect v-model="recipient.baseId" label="Kaibosh base" required="true" />
      <AddressField v-model="recipient.physicalAddress" label="Physical address" />
      <DateField name="start date" v-model="startedAt" />
      <InputField name="description" v-model="recipient.description" type="textarea" />
    </div>

    <div class="box">
      <h1 class="title">Primary Contact Details</h1>

      <InputField name="contact-name" v-model="contact.name" />
      <InputField name="contact-email" v-model="contact.email" />
      <InputField name="contact-landline" v-model="contact.phoneLandline" />
      <InputField name="contact-mobile" v-model="contact.phoneMobile" />
    </div>
    <button type="submit" class="button is-primary is-pulled-right">
      Save Recipient
    </button>
  </form>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import AddressField from "@/components/ui/AddressField.vue";
import BaseSelect from "@/components/ui/BaseSelect.vue";
import DateField from "@/components/ui/DateField.vue";
import InputField from "@/components/ui/InputField.vue";
import { IContact, IRecipient } from "@/types";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import toast from "@/helpers/toast";

@Component({
  components: { AddressField, BaseSelect, DateField, InputField },
  // eslint-disable-next-line @typescript-eslint/camelcase
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
    phoneLandline: "",
    phoneMobile: ""
  };

  startedAt: Date = new Date();
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

      if (ActiveRecipientModule.details.contact) {
        this.contact = { ...ActiveRecipientModule.details.contact };
      }

      if (ActiveRecipientModule.details.startedAt) {
        this.startedAt = ActiveRecipientModule.details.startedAt;
      }
    }

    this.isLoading = false;
  }

  async saveRecipient() {
    const params = {
      recipient: {
        ...this.recipient,
        contact: this.contact
      }
    };

    if (this.startedAt) {
      params.recipient.startedAt = this.startedAt;
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
