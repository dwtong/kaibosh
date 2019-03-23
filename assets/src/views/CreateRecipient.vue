<template>
  <div class="columns">
    <div class="column is-half is-offset-one-fifth  ">
      <div class="box">
        <form @submit.prevent="validateBeforeSubmit">
          <b-field
            label="Organisation name"
            :type="{ 'is-danger': errors.has('name') }"
            :message="errors.first('name')"
          >
            <b-input
              v-model="recipient.name"
              name="name"
              v-validate="'required'"
            />
          </b-field>
          <button type="submit" class="button is-primary">Submit</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from "vuex";
import { capitalize } from "lodash";
export default {
  computed: {
    ...mapState("recipients", ["activeRecipient"])
  },
  data() {
    return {
      recipient: { name: null, base_id: 1 }
    };
  },

  methods: {
    ...mapActions("recipients", ["createRecipient"]),
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
            this.errors.add({
              field: field,
              msg: `${capitalize(field)} ${error}.`
            });
          });
        }
      }
    }
  }
};
</script>

<style lang="scss" scoped></style>
