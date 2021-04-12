<template>
  <BaseSelect :value="filteredBase" all="true" @input="updateBaseFilter($event)" />
</template>
<script lang="ts">
import { defineComponent } from "vue";
import AllRecipients from "@/store/modules/all-recipients";
import BaseSelect from "@/components/ui/BaseSelect.vue";

export default defineComponent({
  components: {
    BaseSelect
  },
  props: {},
  data() {
    return {};
  },
  computed: {
    filteredBase(): string {
      return AllRecipients.filteredBase;
    }
  },
  methods: {
    updateBaseFilter(baseId: string): void {
      AllRecipients.updateBaseFilter(baseId);
    }
  }
});
</script>
