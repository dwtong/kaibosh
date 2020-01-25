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
    <div v-if="showSessionOptions">
      <div class="box" v-for="day in days" :key="day">
        <h2 class="title is-4">{{ day }} 11th January</h2>
        <div class="columns">
          <div
            v-for="time in ['11:00am', '4:00pm']"
            :key="time"
            class="column is-half"
          >
            <div class="card">
              <header class="card-header">
                <p class="card-header-title">
                  {{ time }}
                </p>
                <a href="#" class="card-header-icon" aria-label="more options">
                  <span class="icon">
                    <i class="fas fa-angle-down" aria-hidden="true"></i>
                  </span>
                </a>
              </header>
              <div class="card-content">
                <div class="content">
                  <div>Bellyful</div>
                  <div>Salvation Army</div>
                  <div>Food Bank</div>
                  <div>Welly Food Group</div>
                  <div>Hutt Charities</div>
                </div>
              </div>
              <footer class="card-footer">
                <a href="#" class="card-footer-item">View Session</a>
              </footer>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import { BasesModule } from "../store/modules/bases";
import BaseSelect from "@/components/form/BaseSelect.vue";
import SessionSlotSelect from "@/components/form/SessionSlotSelect.vue";
import date from "@/helpers/date";

@Component({ components: { BaseSelect, SessionSlotSelect } })
export default class SessionSlotsForWeek extends Vue {
  baseId: string = "0";
  sessionSlotId: string = "0";
  showSessionOptions = true; // false;

  async onBaseSelect() {
    await BasesModule.fetchSessionSlots(this.baseId);
    this.showSessionOptions = true;
  }

  get sessionSlots() {
    return BasesModule.sessionSlots;
  }

  get showSubmitButton() {
    return this.baseId !== "0" && this.sessionSlotId !== "0";
  }

  get days() {
    return date.days;
  }

  get weekOfDate() {
    let weekOfDate;

    if (this.$route.query.date instanceof Date) {
      weekOfDate = new Date(this.$route.query.date);
    } else {
      weekOfDate = new Date();
    }

    return date.getMonday(weekOfDate);
  }
}
</script>
