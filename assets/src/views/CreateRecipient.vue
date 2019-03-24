<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <form @submit.prevent="validateBeforeSubmit">
        <div class="box">
          <h1 class="title">Organisation Details</h1>

          <b-field
            label="Organisation name"
            :type="{ 'is-danger': errors.has('name') }"
            :message="errors.first('name')"
            class="form-field"
          >
            <b-input
              v-model="recipient.name"
              name="name"
              v-validate="'required'"
            />
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
              <option
                v-for="base in bases.data"
                :key="base.id"
                :value="base.id"
                >{{ base.name }}</option
              >
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
              v-model="recipient.contact.name"
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
              v-model="recipient.contact.email"
              name="contact-email"
            />
          </b-field>

          <b-field label="Contact landline">
            <b-input
              v-model="recipient.contact.phone_landline"
              name="contact-landline"
            />
          </b-field>

          <b-field label="Contact mobile">
            <b-input v-model="recipient.contact.phone_mobile" name="name" />
          </b-field>
        </div>

        <button type="submit" class="button is-primary is-pulled-right">
          Create Recipient
        </button>
      </form>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from "vuex";
import { capitalize } from "lodash";
export default {
  computed: {
    ...mapState("recipients", ["activeRecipient"]),
    ...mapState("bases", ["bases"])
  },

  async created() {
    await this.getBases();
  },

  data() {
    return {
      recipient: {
        name: null,
        base_id: null,
        contact: {
          name: null,
          email: null,
          phone_landline: null,
          phone_mobile: null
        }
      }
    };
  },

  methods: {
    ...mapActions("recipients", ["createRecipient"]),
    ...mapActions("bases", ["getBases"]),

    async validateBeforeSubmit() {
      const formIsValid = await this.$validator.validateAll();
      if (formIsValid) {
        await this.createRecipient(this.recipient);
      }
      if (this.activeRecipient.errors || this.errors.items.length > 0) {
        this.addApiErrorsToForm(this.activeRecipient.errors);
        this.toastError("Unable to create recipient.", this.errors.items);
      } else {
        this.toastSuccess("Successfully created recipient.");
        this.$router.push("/recipients");
      }
    },

    toastError(errorMsg, items) {
      this.$toast.open({
        message: `${errorMsg} ${
          items && items.length > 0
            ? "Please see form errors."
            : "Please try again later or contact support."
        }`,
        type: "is-danger",
        position: "is-bottom"
      });
    },

    toastSuccess(msg) {
      this.$toast.open({
        message: msg,
        type: "is-success",
        position: "is-top"
      });
    },

    addApiErrorsToForm(apiErrors) {
      if (typeof apiErrors == "object") {
        for (const field in apiErrors) {
          apiErrors[field].forEach(error => {
            const humanisedField = capitalize(field.split(".").pop());
            this.errors.add({
              field: field,
              msg: `${capitalize(humanisedField)} ${error}.`
            });
          });
        }
      }
    }
  }
};
</script>
