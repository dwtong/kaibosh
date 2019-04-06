<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm @submit="validateAndSubmitForm" />
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from "vuex";
import helpers from "@/helpers/form-validation";
import toast from "@/helpers/toast";
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
          helpers.addErrorsToForm(this.activeRecipient.errors, this.errors);
          toast.error("Unable to create recipient.", this.errors.items);
        } else {
          toast.success("Successfully created recipient.");
          this.$router.push(`/recipients/${this.activeRecipient.data.id}`);
        }
      } else {
        toast.error("Unable to create recipient.", this.errors.items);
      }
    }
  }
};
</script>
