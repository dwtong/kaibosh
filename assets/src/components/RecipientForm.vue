<template>
  <form @submit.prevent="submit">
    <div class="box">
      <h1 class="title">Organisation Details</h1>

      <InputField name="name" v-model="recipient.name" />
      <BaseSelect v-model="recipient.base_id" label="Kaibosh base" />
      <AddressField
        v-model="recipient.physical_address"
        label="Physical address"
      />
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
import InputField from "@/components/form/InputField.vue";
import { IContact, IRecipient } from "@/types";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import toast from "@/helpers/toast";

@Component({ components: { AddressField, BaseSelect, InputField } })
export default class RecipientForm extends Vue {
  @Prop(String) readonly recipientId!: string;

  recipient: IRecipient = {
    name: "",
    base_id: "0"
  };

  contact: IContact = {
    name: "",
    email: "",
    phone_landline: "",
    phone_mobile: ""
  };

  async submit() {
    const params = {
      primary_contact_attributes: this.contact,
      ...this.recipient
    };

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

  async created() {
    if (this.recipientId) {
      await ActiveRecipientModule.fetchRecipient(this.recipientId);
      this.recipient = ActiveRecipientModule.details;
      if (ActiveRecipientModule.details.primary_contact) {
        this.contact = { ...ActiveRecipientModule.details.primary_contact };
      }
    }
  }
}
</script>
