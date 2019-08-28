<template>
  <form @submit.prevent="">
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">
          {{ this.session ? "Edit " : "Add" }} Sorting Session
        </p>
      </header>

      <section class="modal-card-body">
        <div class="columns">
          <div class="column">
            <p class="subtitle">Select session time and day</p>
            <b-field class="form-field">
              <b-select
                name="session"
                placeholder="Select an option"
                expanded
                v-model="selectedSessionSlotId"
              >
                <option
                  v-for="slot in sessionSlots"
                  :key="slot.id"
                  :value="slot.id"
                  >{{ slot.day }} - {{ slot.time }}</option
                >
              </b-select>
            </b-field>
          </div>
        </div>

        <div v-if="selectedSessionSlotId" class="columns">
          <div class="column">
            <p class="subtitle">Choose food categories</p>
            <AllocationQuantitiesInput v-model="allocations" />
          </div>
        </div>
      </section>

      <footer class="modal-card-foot">
        <div class="buttons">
          <button class="button is-light" type="button" @click="$emit('close')">
            Cancel
          </button>
          <button type="submit" class="button is-info" @click="saveSession">
            Save
          </button>
        </div>
      </footer>
    </div>
  </form>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IScheduledSession, IAllocation, ISessionSlot } from "../types";
import { ActiveRecipientModule } from "../store/modules/active-recipient";
import { BasesModule } from "../store/modules/bases";
import AllocationQuantitiesInput from "@/components/AllocationQuantitiesInput.vue";
import toast from "@/helpers/toast";

@Component({ components: { AllocationQuantitiesInput } })
export default class ScheduledSessionModal extends Vue {
  @Prop() readonly recipientId!: string;
  @Prop() readonly baseId: string | undefined;
  @Prop() readonly session?: IScheduledSession;
  loading: boolean = true;
  allocations: IAllocation[] = [];
  sessionSlots: ISessionSlot[] = [];
  selectedSessionSlotId: string = "";

  created() {
    if (this.session) {
      this.allocations = this.session.allocations
        ? [...this.session.allocations]
        : [];

      this.selectedSessionSlotId = this.session.session_slot!.id;
    }

    this.sessionSlots = BasesModule.sessionSlots;
  }

  async saveSession() {
    const params = {
      recipient_id: this.recipientId,
      session_slot_id: this.selectedSessionSlotId,
      allocations_attributes: this.allocations
    };

    if (this.session) {
      await ActiveRecipientModule.updateScheduledSession({
        ...params,
        ...this.session
      });
    } else {
      await ActiveRecipientModule.createScheduledSession(params);
    }

    this.$emit("close");
    toast.success("Scheduled session created.");
  }
}
</script>

<style lang="scss" scoped>
.modal-card {
  width: 400px;
}

.modal-card-foot {
  justify-content: right;
}
</style>
