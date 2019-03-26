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

      <b-field
        label="Kaibosh base"
        :type="{ 'is-danger': errors.has('base') }"
        :message="errors.first('base')"
        class="form-field"
      >
        <b-select
          v-model="recipient.base_id"
          name="base"
          placeholder="Select an option"
          v-validate="'required'"
        >
          <option v-for="base in bases.data" :key="base.id" :value="base.id">{{
            base.name
          }}</option>
        </b-select>
      </b-field>
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
import { mapActions, mapState } from "vuex";

export default {
  async created() {
    await this.getBases();
  },

  computed: {
    ...mapState("bases", ["bases"])
  },

  inject: ["$validator"],

  methods: {
    ...mapActions("bases", ["getBases"]),
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
