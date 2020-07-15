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
import Vue from "vue";
import { Component } from "vue-property-decorator";
import InfoField from "@/components/ui/InfoField.vue";
import RecipientStatusTag from "@/components/recipient/RecipientStatusTag.vue";
import ActiveRecipient from "@/store/modules/active-recipient";
import { IContact } from "@/types";

@Component({ components: { InfoField, RecipientStatusTag } })
export default class RecipientContactDetails extends Vue {
  get contact(): IContact {
    return ActiveRecipient.details?.contact;
  }

  get name() {
    return this.contact?.name;
  }

  get email() {
    return this.contact?.email;
  }

  get phoneMobile() {
    return this.contact?.phoneMobile;
  }

  get phoneLandline() {
    return this.contact?.phoneLandline;
  }
}
</script>
