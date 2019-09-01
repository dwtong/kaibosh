<template>
  <div class="columns">
    <div class="column">
      <b-message
        v-if="status === 'pending'"
        title="Pending"
        type="is-info"
        has-icon
        aria-close-label="Close message"
      >
        <p>
          {{ name }} is currently pending. For a recipient to become active,
          they must:<br /><br />
          &nbsp;&nbsp;&nbsp;&nbsp;1. Have their start date set to today or
          earlier.<br />
          &nbsp;&nbsp;&nbsp;&nbsp;2. Have all 'Onboarding' items checked off.<br />
          &nbsp;&nbsp;&nbsp;&nbsp;3. Have at least one scheduled session set.<br />
        </p>
      </b-message>

      <b-message
        v-if="status === 'archived'"
        title="Archived"
        type="is-warning"
        has-icon
        aria-close-label="Close message"
      >
        <p>
          {{ name }} is currently archived.
          <a @click="reactivate">Click here</a> to reactivate them.
        </p>
      </b-message>
    </div>
  </div>
</template>

<script lang="ts">
import { Component } from "vue-property-decorator";
import Vue from "vue";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";

@Component
export default class RecipientMessageBox extends Vue {
  get status() {
    return ActiveRecipientModule.details.status;
  }

  get name() {
    return ActiveRecipientModule.details.name;
  }

  reactivate() {
    if (ActiveRecipientModule.details.id) {
      ActiveRecipientModule.updateRecipient({
        id: ActiveRecipientModule.details.id,
        archived_at: null
      });
    }
  }
}
</script>
