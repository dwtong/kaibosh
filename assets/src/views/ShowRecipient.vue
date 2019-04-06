<template>
  <div>
    <div class="columns">
      <div class="column is-narrow">
        <div class="box">
          <h1 class="title">Organisation Details</h1>

          <InfoField label="Name" :value="recipient.name" />
          <InfoField label="Base" :value="base.name" />
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
          <h1 class="title is-inline-block">Sorting Sessions</h1>
          <button
            @click="isFoodAllocationModalActive = true"
            class="button is-primary is-pulled-right"
          >
            Add Sorting Session
          </button>

          <b-modal :active.sync="isFoodAllocationModalActive" has-modal-card>
            <FoodAllocationModal
              :sessions="base.sessions"
              :foodCategories="base.foodCategories"
            />
          </b-modal>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import FoodAllocationModal from "@/components/FoodAllocationModal";
import InfoField from "@/components/form/InfoField";
import { mapActions, mapGetters, mapState } from "vuex";
import toast from "@/helpers/toast";

export default {
  components: { FoodAllocationModal, InfoField },

  computed: {
    ...mapState("recipients", ["activeRecipient"]),
    ...mapState("bases", ["bases"]),
    ...mapGetters("bases", ["getBaseById"])
  },

  async created() {
    await Promise.all([this.getRecipient(this.id), this.getBases()]);

    if (this.activeRecipient.data && this.activeRecipient.data.base) {
      const base = this.getBaseById(this.activeRecipient.data.base.id);

      this.base = {
        sessions: base.sessions,
        foodCategories: base.food_categories,
        name: base.name
      };

      this.recipient.name = this.activeRecipient.data.name;

      if (this.activeRecipient.data.primary_contact) {
        this.recipient.contact = {
          name: this.activeRecipient.data.primary_contact.name,
          email: this.activeRecipient.data.primary_contact.email,
          mobile: this.activeRecipient.data.primary_contact.phone_mobile,
          landline: this.activeRecipient.data.primary_contact.phone_landline
        };
      }
    } else {
      toast.error("Failed to fetch data from server.");
    }
  },

  data() {
    return {
      isFoodAllocationModalActive: false,
      base: {
        foodCategories: [],
        sessions: []
      },
      recipient: {
        name: "",
        id: this.id,
        contact: {
          name: "",
          email: "",
          mobile: "",
          landline: ""
        }
      }
    };
  },

  methods: {
    ...mapActions("recipients", ["getRecipient"]),
    ...mapActions("bases", ["getBases"])
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
