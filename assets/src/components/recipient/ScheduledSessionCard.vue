<template>
  <b-collapse aria-id="contentIdForA11y3" :open="isOpen" class="session-card">
    <div slot="trigger" aria-controls="contentIdForA11y3" class="level box header">
      <div class="level-left">
        <div class="level-item">
          <p v-if="session.sessionSlot">
            <span class="has-text-weight-semibold is-size-5 day-text">{{ session.sessionSlot.day }} </span>
            <span class="is-size-5">{{ session.sessionSlot.time }}</span>
          </p>
        </div>
      </div>
      <div class="level-item"></div>
      <div class="level-right">
        <div class="level-item">
          <HoldStatusTag :status="session.holdStatus" />
        </div>
      </div>
    </div>
    <div class="box">
      <div class="card-content">
        <div v-if="session.holds && session.holds.length > 0" class="content">
          <p class="label">Session Holds</p>
          <HoldsList :holds="session.holds" :session-id="session.id" />
        </div>

        <div class="content">
          <p class="label">Food Allocations</p>
          <AllocationList :allocations="session.allocations" />
        </div>

        <div class="buttons">
          <a class="button is-primary" @click="$emit('edit')">Edit</a>
          <a class="button is-danger" @click="$emit('remove')">Delete</a>
        </div>
      </div>
    </div>
  </b-collapse>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IScheduledSession } from "@/types";
import HoldsList from "@/components/recipient/HoldsList.vue";
import AllocationList from "@/components/recipient/AllocationList.vue";
import HoldStatusTag from "@/components/ui/HoldStatusTag.vue";

@Component({ components: { HoldsList, AllocationList, HoldStatusTag } })
export default class ScheduledSessionCard extends Vue {
  @Prop(Object) readonly session!: IScheduledSession;
  isOpen = false;

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
