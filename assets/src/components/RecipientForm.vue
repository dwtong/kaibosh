<template>
  <form @submit.prevent="submit">
    <div class="box">
      <h1 class="title">Organisation Details</h1>

      <b-field
        label="Organisation name"
        :type="{ 'is-danger': errors.has('name') }"
        :message="errors.first('name')"
        class="form-field"
      >
        <b-input v-model="recipient.name" name="name" v-validate="'required'" />
      </b-field>

      <BaseSelect v-model="recipient.base_id" label="Kaibosh base" />
    </div>

    <div class="box">
      <h1 class="title">Primary Contact Details</h1>

      <b-field
        label="Contact name"
        :type="{ 'is-danger': errors.has('contact-name') }"
        :message="errors.first('contact-name')"
      >
        <b-input
          v-model="recipient.primary_contact.name"
          data-vv-as="contact name"
          name="contact-name"
        />
      </b-field>

      <b-field
        label="Contact email"
        :type="{ 'is-danger': errors.has('primary_contact.email') }"
        :message="errors.first('primary_contact.email')"
      >
        <b-input
          data-vv-as="contact email"
          v-model="recipient.primary_contact.email"
          name="contact-email"
        />
      </b-field>

      <b-field label="Contact landline">
        <b-input
          v-model="recipient.primary_contact.phone_landline"
          name="contact-landline"
        />
      </b-field>

      <b-field label="Contact mobile">
        <b-input v-model="recipient.primary_contact.phone_mobile" name="name" />
      </b-field>
    </div>

    <button type="submit" class="button is-primary is-pulled-right">
      Save Recipient
    </button>
  </form>
</template>

<script>
import BaseSelect from "@/components/form/BaseSelect";

export default {
  components: {
    BaseSelect
  },

  inject: ["$validator"],

  methods: {
    async submit() {
      this.$emit("submit", this.recipient);
    }
  },

  props: {
    recipient: {
      type: Object,
      default() {
        return {
          name: null,
          base_id: null,
          primary_contact: {
            name: null,
            email: null,
            phone_landline: null,
            phone_mobile: null
          }
        };
      }
    }
  }
};
</script>
