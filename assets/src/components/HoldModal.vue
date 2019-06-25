<template>
  <form @submit.prevent="">
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Set hold date</p>
      </header>

      <section class="modal-card-body">
        <div class="columns">
          <div class="column">
            <b-field label="Start date">
              <b-datepicker
                placeholder="Click to select..."
                v-model="startDate"
                icon-pack="fas"
              >
              </b-datepicker>
            </b-field>
            <b-field label="End date">
              <b-datepicker
                placeholder="Click to select..."
                :disabled="disableEndDate"
                v-model="endDate"
              >
              </b-datepicker>
            </b-field>

            <b-checkbox
              type="is-info"
              @input="toggleEndDate"
              class="end-date-checkbox"
              >No end date</b-checkbox
            >
          </div>
        </div>
        <p class="subtitle">Sessions</p>
        <b-checkbox
          type="is-info"
          :value="allSessions"
          @input="toggleAllSessions"
          class="end-date-checkbox"
          >All sessions</b-checkbox
        >

        <div v-for="session in sessions" :key="session.id">
          <b-checkbox
            type="is-info"
            class="end-date-checkbox"
            v-model="session.enabled"
            :disabled="allSessions"
          >
            {{ session.session_slot.day }}
            {{ session.session_slot.time }}
          </b-checkbox>
        </div>
      </section>

      <footer class="modal-card-foot">
        <div class="buttons">
          <button class="button is-light" type="button" @click="$emit('close')">
            Cancel
          </button>
          <button type="submit" class="button is-info" @click="saveHold">
            Save
          </button>
        </div>
      </footer>
    </div>
  </form>
</template>

<script>
import { mapActions } from "vuex";
import toast from "@/helpers/toast";

export default {
  created() {
    this.sessions = this.scheduledSessions.map(s => {
      return { enabled: false, ...s };
    });
  },

  data() {
    return {
      startDate: null,
      endDate: null,
      disableEndDate: false,
      allSessions: false,
      sessions: []
    };
  },

  methods: {
    ...mapActions("recipients", ["createSessionHold"]),
    toggleEndDate(isDisabled) {
      this.disableEndDate = isDisabled;
    },
    toggleAllSessions() {
      this.allSessions = !this.allSessions;
      this.sessions.forEach(s => (s.enabled = this.allSessions));
    },
    async saveHold() {
      const endDate = this.disableEndDate ? null : this.endDate;
      const sessions = this.sessions
        .filter(s => s.enabled)
        .map(s => {
          return {
            scheduled_session_id: s.id,
            starts_at: this.startDate,
            ends_at: endDate
          };
        });
      await sessions.forEach(s => this.createSessionHold(s));

      if (this.errors.length > 0) {
        toast.error("Unable to save session.");
      } else {
        this.$emit("close");
        toast.success("Session hold created.");
      }
    }
  },

  props: ["scheduledSessions"]
};
</script>

<style lang="scss" scoped>
.end-date-checkbox {
  margin-top: 0.5rem;
  margin-left: 0.1rem;
}

.modal-card {
  width: 400px;
}

.modal-card-body {
  height: 550px;
}

.subtitle {
  margin-top: 2rem;
}
</style>
