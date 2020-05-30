<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm />
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import RecipientForm from "@/components/RecipientForm.vue";

@Component({ components: { RecipientForm } })
export default class CreateRecipient extends Vue {}
</script>
