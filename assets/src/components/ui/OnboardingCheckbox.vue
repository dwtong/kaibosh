<template>
  <div class="field">
    <Checkbox :label="label" :value="value" @input="toggleValue" />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Checkbox from "@/components/ui/Checkbox.vue";
import ActiveRecipient from "@/store/modules/active-recipient";

export default defineComponent({
  components: {
    Checkbox
  },
  props: {
    id: {
      type: String,
      required: true
    },
    name: {
      type: String,
      required: true
    },
    value: {
      type: Boolean,
      required: true
    },
    label: {
      type: String,
      default: ""
    }
  },
  methods: {
    async toggleValue() {
      await ActiveRecipient.updateRecipient({
        id: this.id,
        [this.name]: !this.value
      });
    }
  }
});
</script>
