<template>
  <b-collapse aria-id="contentIdForA11y3" :open="isOpen" class="recipientSession-card">
    <template #trigger>
      <div aria-controls="contentIdForA11y3" class="level box header">
        <div class="level-left">
          <div class="level-item">
            <p>
              <span class="has-text-weight-semibold is-size-5 day-text">{{ sessionDay }} </span>
              <span class="is-size-5">{{ sessionTime }}</span>
            </p>
          </div>
        </div>
        <div class="level-item"></div>
        <div class="level-right">
          <div class="level-item">
            <HoldStatusTag :status="recipientSession.status" />
          </div>
        </div>
      </div>
    </template>

    <div class="box">
      <div class="card-content">
        <div v-if="recipientSession.holds && recipientSession.holds.length > 0" class="content">
          <p class="label">Session Holds</p>
          <HoldsList :holds="recipientSession.holds" :recipient-id="recipientId" />
        </div>

        <div class="content">
          <p class="label">Food Allocations</p>
          <AllocationList :allocations="recipientSession.allocations" />
        </div>

        <div class="buttons">
          <SessionModal
            v-slot="{ open }"
            :session="recipientSession"
            :base-id="baseId"
            :recipient-id="recipientId"
            :sessions="recipientSessions"
          >
            <a class="button is-primary" @click="open">Edit</a>
          </SessionModal>
          <a class="button is-danger" @click="confirmSessionDeletion">Delete</a>
        </div>
      </div>
    </div>
  </b-collapse>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import HoldsList from "@/components/recipient/HoldsList.vue";
import AllocationList from "@/components/recipient/AllocationList.vue";
import HoldStatusTag from "@/components/ui/HoldStatusTag.vue";
import RecipientSessions from "@/store/modules/recipient-sessions";
import SessionModal from "@/components/recipient/SessionModal.vue";
import toast from "@/helpers/toast";
import { formatTime } from "@/helpers/date";
import { capitalize } from "lodash";

export default defineComponent({
  components: {
    HoldsList,
    AllocationList,
    HoldStatusTag,
    SessionModal
  },
  props: {
    recipientSession: {
      type: Object,
      required: true
    },
    recipientSessions: {
      type: Array,
      required: true
    },
    baseId: {
      type: String,
      required: true
    },
    recipientId: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      isOpen: false
    };
  },
  computed: {
    sessionDay(): string {
      const day = this.recipientSession.day;
      return day ? capitalize(day) : "";
    },

    sessionTime(): string {
      const time = this.recipientSession.time;
      return time ? formatTime(time) : "";
    }
  },
  methods: {
    toggleIsOpen() {
      this.isOpen = !this.isOpen;
    },

    confirmSessionDeletion() {
      // TODO: replace buefy dialog
      // this.$buefy.dialog.confirm({
      //   message: "Are you sure you wish to remove this session?",
      //   type: "is-danger",
      //   onConfirm: async () => {
      //     if (this.recipientSession.id) {
      //       await RecipientSessions.deleteSession({
      //         recipientId: this.recipientId,
      //         sessionId: this.recipientSession.id
      //       });
      //       toast.success("Deleted session.");
      //     }
      //   }
      // });
    }
  }
});
</script>

<style lang="scss" scoped>
.box {
  border-radius: 0px;
  border-color: black;
  padding: 1rem;
  box-shadow: 0;
}

.buttons {
  margin-top: 2rem;
}

.content {
  margin-bottom: 2.5rem !important;
}

.header {
  background-color: #e6e6e6;
}

.day-text {
  margin-right: 0.5rem;
}

.recipientSession-card {
  margin-bottom: 1rem;
}
</style>
