<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">{{ details.name }}</h1>
      <div class="buttons is-pulled-right">
        <button class="button is-light ">
          Edit Recipient
        </button>
        <button
          @click="isScheduledSessionModalActive = true"
          class="button is-light"
        >
          Add Sorting Session
        </button>
        <button class="button is-primary ">
          Add Hold Date
        </button>
      </div>
    </div>

    <div class="columns">
      <div class="column is-two-fifths">
        <div class="box">
          <h2 class="title is-4">Organisation Details</h2>

          <InfoField label="Full Legal Name" :value="details.name" />
          <InfoField label="Base" :value="details.base.name" />
          <InfoField label="Status" :value="details.status" />
        </div>

        <div class="box">
          <h2 class="title is-4">Primary Contact</h2>

          <InfoField label="Name" :value="details.primary_contact.name" />
          <InfoField label="Email" :value="details.primary_contact.email" />
          <InfoField label="Mobile" :value="details.primary_contact.mobile" />
          <InfoField
            label="Landline"
            :value="details.primary_contact.landline"
          />
        </div>
        <div class="box">
          <h2 class="title is-4">Onboarding</h2>
          <div class="field">
            <b-checkbox type="is-info"
              >Terms and conditions are signed</b-checkbox
            >
          </div>
          <div class="field">
            <b-checkbox type="is-info">Have met Kaibosh in person</b-checkbox>
          </div>
        </div>

        <div class="box">
          <h2 class="title is-4">Files</h2>
          <b-field class="file">
            <b-upload>
              <a class="button is-primary">
                <b-icon icon="upload"></b-icon>
                <span>Click to upload</span>
              </a>
            </b-upload>
          </b-field>
        </div>
      </div>

      <div class="column">
        <div class="box">
          <h2 class="title is-4 is-inline-block">Sorting Sessions</h2>

          <div v-for="session in scheduledSessions" :key="session.id">
            <div class="card">
              <header class="card-header">
                <p class="card-header-title">
                  {{ session.session_slot.day }}
                  {{ session.session_slot.time }}
                </p>
              </header>
              <div class="card-content">
                <div class="content">
                  <div
                    class="level"
                    v-for="allocation in session.allocations"
                    :key="allocation.id"
                  >
                    <div class="level-left">
                      <div class="level-item">
                        {{ foodCategoryName(allocation.food_category_id) }}
                      </div>
                    </div>
                    <div class="level-right">
                      <div class="level-item">
                        <div class="field has-addons">
                          <p class="control">
                            <button class="button is-static">
                              {{ allocationQuantityLabel(allocation.quantity) }}
                            </button>
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <footer class="card-footer">
                <a href="#" class="card-footer-item">Edit</a>
                <a
                  @click="confirmSessionDeletion(session.id)"
                  class="card-footer-item"
                  >Remove</a
                >
              </footer>
            </div>
          </div>
        </div>

        <b-modal :active.sync="isScheduledSessionModalActive" has-modal-card>
          <ScheduledSessionModal
            :baseId="details.base.id"
            :recipientId="details.id"
            @close="isScheduledSessionModalActive = false"
          />
        </b-modal>
      </div>
    </div>
  </div>
</template>

<script>
import ScheduledSessionModal from "@/components/ScheduledSessionModal";
import InfoField from "@/components/form/InfoField";
import { mapActions, mapGetters, mapState } from "vuex";
import toast from "@/helpers/toast";

export default {
  components: { ScheduledSessionModal, InfoField },

  computed: {
    ...mapState("recipients", ["details", "scheduledSessions"]),
    ...mapGetters("bases", ["foodCategoryById"])
  },

  async created() {
    await Promise.all([this.getFoodCategories(), this.getRecipient(this.id)]);
    await this.getScheduledSessions(this.details.id);
  },

  data() {
    return {
      isScheduledSessionModalActive: false
    };
  },

  methods: {
    ...mapActions("recipients", [
      "getRecipient",
      "getScheduledSessions",
      "deleteScheduledSession"
    ]),
    ...mapActions("bases", ["getFoodCategories"]),
    allocationQuantityLabel(quantity) {
      if (parseInt(quantity.charAt(0))) {
        return quantity + " (max)";
      } else {
        return "no limit";
      }
    },
    confirmSessionDeletion(sessionId) {
      this.$dialog.confirm({
        message: "Are you sure you wish to remove this session?",
        type: "is-danger",
        onConfirm: () => {
          this.deleteScheduledSession(sessionId);
          toast.success("Deleted session.");
        }
      });
    },
    foodCategoryName(id) {
      return this.foodCategoryById(id).name || "";
    }
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
