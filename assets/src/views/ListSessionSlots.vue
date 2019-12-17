<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">Session Schedule</h1>
    </div>
    <BaseSelect
      v-model="baseId"
      label="Kaibosh base"
      required="true"
      @input="onBaseSelect"
      />
    <SessionSlotSelect v-if="showSessionOptions" v-model="sessionSlotId" label="Session day and time"/>
    <a class="button is-primary" v-if="showSubmitButton" :href="sessionSlotLink">Show Session</a>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import { BasesModule } from "../store/modules/bases";
import BaseSelect from "@/components/form/BaseSelect.vue";
import SessionSlotSelect from "@/components/form/SessionSlotSelect.vue";

@Component({ components: { BaseSelect, SessionSlotSelect } })
export default class ListSessionSlots extends Vue {
  baseId: string = "0";
  sessionSlotId: string = "0";
  showSessionOptions = false;

  async onBaseSelect() {
    await BasesModule.fetchSessionSlots(this.baseId);
    this.showSessionOptions = true;
  }

  get sessionSlotLink() {
    return `sessions/${this.sessionSlotId}`
  }

  get showSubmitButton() {
    return this.baseId !== "0" && this.sessionSlotId !== "0";
  }
}
</script>
