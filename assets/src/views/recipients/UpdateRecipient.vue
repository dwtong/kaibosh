<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm :recipientId="id" />
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import RecipientForm from "@/components/RecipientForm.vue";

@Component({ components: { RecipientForm } })
export default class UpdateRecipient extends Vue {
  @Prop(String) readonly id!: string;
}
</script>
