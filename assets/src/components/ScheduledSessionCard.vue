<template>
  <b-collapse aria-id="contentIdForA11y3" :open="isOpen" class="session-card">
    <div
      slot="trigger"
      aria-controls="contentIdForA11y3"
      class="level box header"
    >
      <div class="level-left">
        <div class="level-item">
          <p>
            <span class="has-text-weight-semibold is-size-5 day-text"
              >{{ session.session_slot.day }}
            </span>
            <span class="is-size-5">{{ session.session_slot.time }}</span>
          </p>
        </div>
      </div>
      <div class="level-item"></div>
      <div class="level-right">
        <div class="level-item">
          <HoldStatusLabel :status="session.hold_status" />
        </div>
      </div>
    </div>
    <div class="box">
      <div class="card-content">
        <div v-if="session.holds.length > 0" class="content">
          <p class="label">Session Holds</p>
          <HoldsTable :holds="session.holds" :sessionId="session.id" />
        </div>

        <div class="content">
          <p class="label">Food Allocations</p>
          <AllocationsTable :allocations="session.allocations" />
        </div>

        <div class="buttons">
          <a @click="$emit('edit')" class="button is-primary">Edit</a>
          <a @click="$emit('remove')" class="button is-danger">Delete</a>
        </div>
      </div>
    </div>
  </b-collapse>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IScheduledSession, IHold, IFoodCategory } from "@/types";
import { BasesModule } from "../store/modules/bases";
import HoldsTable from "@/components/HoldsTable.vue";
import AllocationsTable from "@/components/AllocationsTable.vue";
import HoldStatusLabel from "@/components/HoldStatusLabel.vue";

@Component({ components: { HoldsTable, AllocationsTable, HoldStatusLabel } })
export default class ScheduledSessionCard extends Vue {
  @Prop(Object) readonly session!: IScheduledSession;
  isOpen: boolean = false;

  toggleIsOpen() {
    this.isOpen = !this.isOpen;
  }
}
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

.session-card {
  margin-bottom: 1rem;
}
</style>
