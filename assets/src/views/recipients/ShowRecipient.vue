<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">
        {{ name }}
      </h1>

      <div v-if="status !== 'archived'" class="field buttons is-pulled-right">
        <p class="control">
          <router-link :to="`/recipients/update/${id}`" class="button is-info"> Edit Recipient </router-link>
        </p>
        <p class="control">
          <a class="button is-danger" @click="archiveRecipient"> Archive Recipient </a>
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
import { defineComponent } from "vue";
import RecipientMessageBox from "@/components/ui/RecipientMessageBox.vue";
import RecipientOrganisationDetails from "@/components/recipient/RecipientOrganisationDetails.vue";
import RecipientOnboardingChecks from "@/components/recipient/RecipientOnboardingChecks.vue";
import RecipientContactDetails from "@/components/recipient/RecipientContactDetails.vue";
import RecipientSortingSessions from "@/components/recipient/RecipientSortingSessions.vue";
import ActiveRecipient from "@/store/modules/active-recipient";
import App from "@/store/modules/app";
import Sessions from "@/store/modules/sessions";
import LoadRecipient from "@/mixins/load-recipient";

export default defineComponent({
  components: {
    RecipientMessageBox,
    RecipientOrganisationDetails,
    RecipientOnboardingChecks,
    RecipientContactDetails,
    RecipientSortingSessions
  },
  mixins: [LoadRecipient],
  setup() {
    const baseId = ActiveRecipient.details?.baseId ?? "0";
    Promise.all([App.fetchCategories(), Sessions.fetchList(baseId)]);

    return {
      baseId
    };
  },
  computed: {
    status() {
      return ActiveRecipient.status;
    },

    name() {
      return ActiveRecipient.details?.name;
    }
  },
  methods: {
    async archiveRecipient() {
      if (ActiveRecipient.details.id) {
        App.enableLoading();
        await ActiveRecipient.archiveRecipient(ActiveRecipient.details.id);
        App.disableLoading();
      }
    }
  }
});
</script>

<style lang="scss" scoped>
.title-box {
  height: 60px;
}
</style>
