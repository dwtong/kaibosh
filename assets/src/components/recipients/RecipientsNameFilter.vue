<template>
  <div class="field">
    <div class="control">
      <input
        id="name-filter"
        :value="filteredName"
        type="text"
        class="input"
        placeholder="Recipient Name"
        @input="updateNameFilter($event.target.value)"
      />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import AllRecipients from "@/store/modules/all-recipients";

export default defineComponent({
  computed: {
    filteredName(): string {
      return AllRecipients.filteredName;
    }
  },
  methods: {
    updateNameFilter(name: string): void {
      AllRecipients.updateNameFilter(name);
    }
  }
});
</script>
