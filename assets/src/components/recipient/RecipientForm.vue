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
    <button type="submit" class="button is-primary is-pulled-right">Save Recipient</button>
  </ValidatedForm>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import AddressField from "@/components/ui/AddressField.vue";
import BaseSelect from "@/components/ui/BaseSelect.vue";
import ValidatedDate from "@/components/ui/ValidatedDate.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";
import ValidatedInput from "@/components/ui/ValidatedInput.vue";
import { defaultRecipientDetails } from "@/store/modules/active-recipient";

export default defineComponent({
  components: {
    AddressField,
    BaseSelect,
    ValidatedDate,
    ValidatedForm,
    ValidatedInput
  },
  props: {
    recipient: {
      type: Object,
      required: true
    }
  },
  emits: ["submit"],
  data() {
    return {
      recipientDetails: { ...defaultRecipientDetails, contact: { ...defaultRecipientDetails.contact } }
    };
  },
  methods: {
    async created() {
      if (this.recipient) {
        // TODO: Correct typing for contact
        // @ts-ignore
        this.recipientDetails = { ...this.recipient, contact: { ...this.recipient.contact } };
      }
    },
    submit() {
      this.$emit("submit", this.recipientDetails);
    }
  }
});
</script>
