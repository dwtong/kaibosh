<template>
  <div>
    <div class="columns">
      <div class="column is-narrow">
        <div class="box">
          <h1 class="title">Organisation Details</h1>

          <InfoField label="Name" :value="recipient.name" />
          <InfoField label="Base" :value="recipient.base" />
        </div>

        <div class="box">
          <h1 class="title">Primary Contact</h1>

          <InfoField label="Name" :value="recipient.contact.name" />
          <InfoField label="Email" :value="recipient.contact.email" />
          <InfoField label="Mobile" :value="recipient.contact.mobile" />
          <InfoField label="Landline" :value="recipient.contact.landline" />
        </div>
      </div>

      <div class="column">
        <div class="box">
          <h1 class="title">Food Allocations</h1>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import InfoField from "@/components/form/InfoField";
import { mapActions, mapState } from "vuex";

export default {
  components: { InfoField },

  computed: {
    ...mapState("recipients", ["activeRecipient"]),
    recipient() {
      let contact = {
        name: "",
        email: "",
        mobile: "",
        landline: ""
      };

      if (this.activeRecipient.data.primary_contact) {
        contact.name = this.activeRecipient.data.primary_contact.name;
        contact.email = this.activeRecipient.data.primary_contact.email;
        contact.mobile = this.activeRecipient.data.primary_contact.phone_mobile;
        contact.landline = this.activeRecipient.data.primary_contact.phone_landline;
      }

      return {
        name: this.activeRecipient.data.name,
        base: this.activeRecipient.data.base
          ? this.activeRecipient.data.base.name
          : null,
        contact: contact
      };
    }
  },

  async created() {
    await this.getRecipient(this.id);
  },

  methods: {
    ...mapActions("recipients", ["getRecipient"])
  },

  props: ["id"]
};
</script>

<style lang="scss" scoped>
.loading {
  height: 100%;
  width: 100%;
}
</style>
