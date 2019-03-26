<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm @submit="validateAndSubmitForm" />
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from "vuex";
import { capitalize } from "lodash";
import RecipientForm from "@/components/RecipientForm";
export default {
  components: { RecipientForm },

  computed: {
    ...mapState("recipients", ["activeRecipient"])
  },

  methods: {
    ...mapActions("recipients", ["createRecipient"]),

    async validateAndSubmitForm(recipientParams) {
      const formIsValid = await this.$validator.validateAll();

      if (formIsValid) {
        await this.createRecipient(recipientParams);

        if (this.activeRecipient.errors) {
          this.addApiErrorsToForm(this.activeRecipient.errors);
          this.toastError("Unable to create recipient.", this.errors.items);
        } else {
          this.toastSuccess("Successfully created recipient.");
          this.$router.push("/recipients");
        }
      } else {
        this.toastError("Unable to create recipient.", this.errors.items);
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
