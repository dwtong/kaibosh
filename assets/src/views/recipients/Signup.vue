<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <div class="box">
        <div class="logo">
          <img src="@/assets/images/kaibosh-green.png" alt />
        </div>
        <p class="description is-medium">
          Welcome to the Kaibosh Food Rescue signup form. Please fill in the details below and one of our staff will be
          in touch.
        </p>
      </div>
      <ValidatedForm v-if="!success" @submit="createRecipient">
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
        <button type="submit" class="button is-primary is-pulled-right">Sign up</button>
      </ValidatedForm>
      <div v-if="success" class="box">
        <h1 class="title">Success</h1>
        <p>Thanks for signing up! Kaibosh will be in touch with next steps.</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import AddressField from "@/components/ui/AddressField.vue";
import BaseSelect from "@/components/ui/BaseSelect.vue";
import ValidatedInput from "@/components/ui/ValidatedInput.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";
import { defaultRecipientDetails } from "@/store/modules/active-recipient";
import SignupService from "@/services/signup-service";

export default defineComponent({
  components: {
    AddressField,
    BaseSelect,
    ValidatedInput,
    ValidatedForm
  },
  data() {
    return {
      //success: false
      recipientDetails: {
        ...defaultRecipientDetails,
        contact: { ...defaultRecipientDetails.contact }
      }
    };
  },
  methods: {
    async createRecipient() {
      //try {
      await SignupService.create(this.recipientDetails);
      // this.success = true;
      //} catch (e) {
      //this.success = false;
      //}
    }
  }
});
</script>

<style lang="scss" scoped>
.description {
  text-align: center;
}

.logo {
  padding: 1rem;
  margin-bottom: 2rem;

  img {
    height: auto;
    max-width: 100%;
    margin: auto;
    display: block;
    max-height: 100px;
  }
}
</style>
