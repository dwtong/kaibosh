<template>
  <div class="page">
    <div class="field buttons is-pulled-right with-margins is-hidden-print">
      <p class="control">
        <b-checkbox class="with-margins" type="is-info" v-model="includeOnHold"
          >Include recipients that are on hold</b-checkbox
        >
      </p>
      <p class="control">
        <button class="button is-primary" @click="goBack">
          Back to session
        </button>
      </p>
      <p class="control">
        <PrintButton label="Print Descriptions" />
      </p>
    </div>

    <h1 class="title with-margins" v-if="sessionDate">
      {{ sessionDate | moment("dddd h:mma") }}
    </h1>

    <div class="recipient with-margins" v-for="recipient in recipients" :key="recipient.id">
      <h2 class="subtitle">{{ recipient.name }}</h2>
      <div v-html="recipient.description"></div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { SessionSlotsModule } from "@/store/modules/session-slots";
import PrintButton from "@/components/PrintButton.vue";
import Router from "@/router";

@Component({ components: { PrintButton } })
export default class GenerateDescriptionsButton extends Vue {
  @Prop(String) readonly id!: string;
  includeOnHold = false;

  get recipients() {
    if (this.includeOnHold) {
      return SessionSlotsModule.orderedRecipients;
    } else {
      return SessionSlotsModule.orderedRecipients.filter(r => r.status !== "on_hold");
    }
  }

  get sessionDate() {
    return SessionSlotsModule.details.date;
  }

  async created() {
    await SessionSlotsModule.fetchSessionSlot(this.id);
  }

  goBack() {
    Router.go(-1);
  }

  print() {
    window.print();
  }
}
</script>

<style lang="scss" scoped>
.buttons {
  margin-top: 2rem;
}

.checkbox {
  font-size: 1rem;
}

.with-margins {
  margin-left: 2rem;
  margin-right: 2rem;
}

.page {
  position: fixed;
  z-index: 999;
  height: 100%;
  width: 100%;
  left: 0;
  top: 0;
  background-color: white;
  font-size: 16px;
  color: black;
}

.title {
  margin-top: 2rem;
  font-size: 24px;
  color: black;
}

.subtitle {
  margin-top: 35px;
  margin-bottom: 5px !important;
  font-weight: 600;
  font-size: 18px;
  color: black;
}
</style>
