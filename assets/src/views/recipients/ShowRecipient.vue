<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">
        {{ name }}
      </h1>

      <div v-if="status !== 'archived'" class="field buttons is-pulled-right">
        <p class="control">
          <router-link :to="`/recipients/update/${id}`" class="button is-info">
            Edit Recipient
          </router-link>
        </p>
        <p class="control">
          <a class="button is-danger" @click="archiveRecipient">
            Archive Recipient
          </a>
        </p>
      </div>
    </div>

    <div class="columns">
      <div class="column">
        <RecipientMessageBox :status="status" />
      </div>
    </div>

    <div v-if="status !== 'archived'" class="columns">
      <div class="column is-half">
        <RecipientOrganisationDetails />
        <RecipientOnboardingChecks />
      </div>

      <div class="column">
        <RecipientContactDetails />
        <RecipientSortingSessions />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import RecipientMessageBox from "@/components/ui/RecipientMessageBox.vue";
import RecipientOrganisationDetails from "@/components/recipient/RecipientOrganisationDetails.vue";
import RecipientOnboardingChecks from "@/components/recipient/RecipientOnboardingChecks.vue";
import RecipientContactDetails from "@/components/recipient/RecipientContactDetails.vue";
import RecipientSortingSessions from "@/components/recipient/RecipientSortingSessions.vue";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import RecipientSessions from "@/store/modules/recipient-sessions";
import App from "@/store/modules/app";
import SessionSlots from "@/store/modules/session-slots";
import LoadRecipient from "@/mixins/load-recipient";

@Component({
  components: {
    RecipientMessageBox,
    RecipientOrganisationDetails,
    RecipientOnboardingChecks,
    RecipientContactDetails,
    RecipientSortingSessions
  },
  mixins: [LoadRecipient]
})
export default class ShowRecipient extends Vue {
  @Prop(String) readonly id!: string;

  get baseId() {
    return ActiveRecipientModule.details?.baseId;
  }

  get status() {
    return ActiveRecipientModule.status;
  }

  get name() {
    return ActiveRecipientModule.details?.name;
  }

  async created() {
    await RecipientSessions.fetchSessions(this.id);

    if (this.baseId) {
      await SessionSlots.fetchSessionSlots({
        baseId: this.baseId
      });
    }
  }

  async archiveRecipient() {
    if (ActiveRecipientModule.details.id) {
      App.enableLoading();
      await ActiveRecipientModule.archiveRecipient(ActiveRecipientModule.details.id);
      await ActiveRecipientModule.fetchRecipientStatus(this.id);
      App.disableLoading();
    }
  }
}
</script>

<style lang="scss" scoped>
.title-box {
  height: 60px;
}
</style>
