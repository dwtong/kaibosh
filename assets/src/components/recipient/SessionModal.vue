<template>
  <div>
    <slot :open="openModal"></slot>
    <ModalForm v-model="isOpen" @submit="saveSession">
      <template #title>{{ isExistingSession ? "Edit " : "Add" }} Sorting Session</template>

      <div class="columns">
        <div class="column">
          <p class="subtitle">Select session time and day</p>
          <SessionSelect v-model="selectedSessionId" :sessions="sessions" required="true" />
          <p v-if="sessionExists" class="error-msg">Selected session already exists.</p>
        </div>
      </div>

      <div v-if="showCategories" class="columns">
        <div class="column">
          <p class="subtitle">Choose category categories</p>
          <AllocationQuantitiesInput v-model="allocations" :base-id="baseId" />
        </div>
      </div>
    </ModalForm>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { IRecipientSession, IAllocation } from "@/types";
import RecipientSessions from "@/store/modules/recipient-sessions";
import AllocationQuantitiesInput from "@/components/recipient/AllocationQuantitiesInput.vue";
import toast from "@/helpers/toast";
import SessionSelect from "@/components/ui/SessionSelect.vue";
import ModalForm from "@/components/ui/ModalForm.vue";

export default defineComponent({
  components: {
    SessionSelect,
    AllocationQuantitiesInput,
    ModalForm
  },
  props: {
    recipientId: {
      type: String,
      required: true
    },
    baseId: {
      type: String,
      required: true
    },
    sessions: {
      type: Array,
      required: true
    },
    session: {
      type: Object,
      required: false
    }
  },
  emits: ["close"],
  setup(props) {
    let allocations: IAllocation[] = [];
    let selectedSessionId = "";

    if (props.session) {
      allocations = props.session.allocations ? [...props.session.allocations] : [];
      selectedSessionId = props.session.sessionId ?? "";
    }

    return {
      allocations,
      selectedSessionId
    };
  },
  data() {
    return {
      isOpen: false
    };
  },
  computed: {
    isExistingSession(): boolean {
      return !!this.session;
    },

    showCategories(): boolean {
      return this.selectedSessionId !== "" && !this.sessionExists;
    },

    sessionExists(): boolean {
      return !!this.sessions.find(
        (s: any) => s.sessionId === this.selectedSessionId && s.sessionId !== this.session?.sessionId
      );
    }
  },
  methods: {
    openModal() {
      this.isOpen = true;
    },

    async saveSession() {
      const params = {
        recipientId: this.recipientId,
        sessionId: this.selectedSessionId,
        allocations: this.allocations
      };

      if (this.session) {
        await RecipientSessions.updateSession({
          ...this.session,
          ...params
        });
      } else {
        await RecipientSessions.createSession(params);
      }

      this.$emit("close");
      this.allocations = [];
      this.selectedSessionId = "";
      toast.success(`Session ${this.isExistingSession ? "updated" : "created"}.`);
    }
  }
});
</script>

<style lang="scss" scoped>
.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
