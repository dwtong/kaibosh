<template>
  <div class="box">
    <h2 class="title is-4">Organisation Details</h2>
    <RecipientStatusTag :status="status" with-label="true" size="is-medium" />

    <InfoField label="Full Legal Name">
      {{ name }}
    </InfoField>
    <InfoField label="Base">
      {{ baseName }}
    </InfoField>
    <InfoField label="Physical Address">
      {{ address }}
    </InfoField>
    <InfoField label="Start Date">
      {{ startDate }}
    </InfoField>
    <InfoField label="description">
      <!-- eslint-disable vue/no-v-html -->
      <span v-html="descriptionHtml"></span>
    </InfoField>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import InfoField from "@/components/ui/InfoField.vue";
import RecipientStatusTag from "@/components/recipient/RecipientStatusTag.vue";
import App from "@/store/modules/app";
import { formatDate } from "@/helpers/date";
import ActiveRecipient from "@/store/modules/active-recipient";

@Component({ components: { InfoField, RecipientStatusTag }, filters: { formatDate } })
export default class RecipientOrganisationDetails extends Vue {
  get status() {
    return ActiveRecipient?.status;
  }
  get name() {
    return ActiveRecipient.details?.name;
  }
  get descriptionHtml() {
    return ActiveRecipient.details?.descriptionHtml;
  }
  get address() {
    return ActiveRecipient.details?.physicalAddress;
  }

  get baseName() {
    return ActiveRecipient.details?.baseId ? App.baseNameById(ActiveRecipient.details.baseId) : "";
  }

  get startDate() {
    const date = ActiveRecipient.details?.startedAt;
    return date ? formatDate(new Date(date), "dd/MM/yyyy") : null;
  }
}
</script>
