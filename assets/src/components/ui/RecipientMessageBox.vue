<template>
  <transition name="fade">
    <b-message v-if="status === 'pending'" title="Pending" type="is-info" has-icon aria-close-label="Close message">
      <p>
        {{ name }} is currently pending. For a recipient to become active, they must:<br /><br />
        &nbsp;&nbsp;&nbsp;&nbsp;1. Have their start date set to today or earlier.<br />
        &nbsp;&nbsp;&nbsp;&nbsp;2. Have all 'Onboarding' items checked off.<br />
        &nbsp;&nbsp;&nbsp;&nbsp;3. Have at least one sorting session set.<br />
      </p>
    </b-message>

    <b-message
      v-if="status === 'archived'"
      title="Archived"
      type="is-warning"
      has-icon
      aria-close-label="Close message"
    >
      <p>{{ name }} is currently archived. <a @click="reactivate">Click here</a> to reactivate them.</p>
    </b-message>
  </transition>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";
import ActiveRecipient from "@/store/modules/active-recipient";
import App from "@/store/modules/app";

@Component
export default class RecipientMessageBox extends Vue {
  @Prop({ default: "" }) readonly status!: string;

  get name() {
    return ActiveRecipient.details.name;
  }

  async reactivate() {
    if (ActiveRecipient.details.id) {
      App.enableLoading();
      await ActiveRecipient.updateRecipient({
        id: ActiveRecipient.details.id,
        archivedAt: null
      });

      App.disableLoading();
    }
  }
}
</script>
