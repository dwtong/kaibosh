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
      <span class="is-multi-line">{{ description }}</span>
    </InfoField>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import InfoField from "@/components/ui/InfoField.vue";
import RecipientStatusTag from "@/components/recipient/RecipientStatusTag.vue";
import App from "@/store/modules/app";
import { formatDate } from "@/helpers/date";
import ActiveRecipient from "@/store/modules/active-recipient";

export default defineComponent({
  components: {
    InfoField,
    RecipientStatusTag
  },
  computed: {
    status() {
      return ActiveRecipient?.status;
    },

    name() {
      return ActiveRecipient.details?.name;
    },

    description() {
      return ActiveRecipient.details?.description;
    },

    address() {
      return ActiveRecipient.details?.physicalAddress;
    },

    baseName() {
      return ActiveRecipient.details?.baseId ? App.baseNameById(ActiveRecipient.details.baseId) : "";
    },

    startDate() {
      const date = ActiveRecipient.details?.startedAt;
      return date ? formatDate(new Date(date)) : null;
    }
  }
});
</script>
