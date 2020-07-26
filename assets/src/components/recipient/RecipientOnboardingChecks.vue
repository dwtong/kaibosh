<template>
  <div class="box">
    <h2 class="title is-4">Onboarding</h2>
    <OnboardingCheckbox
      :id="recipient.id"
      label="Terms and conditions are signed"
      name="hasSignedTerms"
      :value="recipient.hasSignedTerms"
    />
    <OnboardingCheckbox
      :id="recipient.id"
      label="Have met Kaibosh in person"
      name="hasMetKaibosh"
      :value="recipient.hasMetKaibosh"
    />
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import OnboardingCheckbox from "@/components/ui/OnboardingCheckbox.vue";
import ActiveRecipient from "@/store/modules/active-recipient";

@Component({ components: { OnboardingCheckbox } })
export default class RecipientOnboardingChecks extends Vue {
  get recipient() {
    return ActiveRecipient.details;
  }
}
</script>
