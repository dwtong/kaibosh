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
import Bases from "@/store/modules/bases";
import { formatDate } from "@/helpers/date";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";

@Component({ components: { InfoField, RecipientStatusTag }, filters: { formatDate } })
export default class RecipientOrganisationDetails extends Vue {
  get status() {
    return ActiveRecipientModule?.status;
  }
  get name() {
    return ActiveRecipientModule.details?.name;
  }
  get descriptionHtml() {
    return ActiveRecipientModule.details?.descriptionHtml;
  }
  get address() {
    return ActiveRecipientModule.details?.physicalAddress;
  }

  get baseName() {
    return ActiveRecipientModule.details?.baseId ? Bases.baseNameById(ActiveRecipientModule.details.baseId) : "";
  }

  get startDate() {
    const date = ActiveRecipientModule.details?.startedAt;
    return date ? formatDate(new Date(date), "dd/MM/yyyy") : null;
  }
}
</script>
