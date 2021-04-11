<template>
  <div class="box">
    <h2 class="title is-4">Primary Contact</h2>

    <InfoField label="Name">
      {{ name }}
    </InfoField>
    <InfoField label="Email">
      {{ email }}
    </InfoField>
    <InfoField label="Mobile">
      {{ phoneMobile }}
    </InfoField>
    <InfoField label="Landline">
      {{ phoneLandline }}
    </InfoField>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import InfoField from "@/components/ui/InfoField.vue";
import ActiveRecipient from "@/store/modules/active-recipient";
import { IContact } from "@/types";

export default defineComponent({
  components: {
    InfoField
  },
  computed: {
    contact(): IContact {
      return ActiveRecipient.details?.contact;
    },

    name(): string {
      return this.contact?.name ?? "";
    },

    email(): string {
      return this.contact?.email ?? "";
    },

    phoneMobile(): string {
      return this.contact?.phoneMobile ?? "";
    },

    phoneLandline(): string {
      return this.contact?.phoneLandline ?? "";
    }
  }
});
</script>
