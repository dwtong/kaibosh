<template>
  <div class="page">
    <div class="field buttons is-pulled-right with-margins is-hidden-print">
      <p class="control">
        <b-checkbox v-model="includeOnHold" class="with-margins" type="is-info"
          >Include recipients that are on hold</b-checkbox
        >
      </p>
      <p class="control">
        <button class="button is-primary" @click="goBack">Back to session</button>
      </p>
      <p class="control">
        <PrintButton label="Print Descriptions" />
      </p>
    </div>

    <h1 v-if="sessionDate" class="title with-margins">
      {{ sessionDate | formatDate("EEEE h:mma") }}
    </h1>

    <div v-for="recipient in recipients" :key="recipient.id" class="recipient with-margins">
      <h2 class="subtitle">{{ recipient.name }}</h2>
      <div class="is-multi-line">{{ recipient.description }}</div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import SessionPlans from "@/store/modules/session-plans";
import PrintButton from "@/components/ui/PrintButton.vue";
import { formatDate } from "@/helpers/date";
import Router from "@/router";

@Component({ components: { PrintButton }, filters: { formatDate } })
export default class GenerateDescriptionsButton extends Vue {
  @Prop(String) readonly id!: string;
  includeOnHold = false;

  get recipients() {
    if (this.includeOnHold) {
      return SessionPlans.orderedRecipients;
    } else {
      return SessionPlans.orderedRecipients.filter(r => r.status !== "on_hold");
    }
  }

  get sessionDate() {
    return SessionPlans.planDetails?.session.date;
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
  overflow-y: auto;
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
