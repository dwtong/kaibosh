<template>
  <ValidatedSelect
    name="base"
    :rules="{ required: required }"
    :value="value"
    :label="label"
    placeholder="Select a base..."
    :help="help"
    @input="$emit('input', $event)"
  >
    <option v-if="all" :value="allValue">All</option>
    <option v-for="base in list" :key="base.id" :value="base.id">{{ base.name }}</option>
  </ValidatedSelect>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import App from "@/store/modules/app";
import ValidatedSelect from "@/components/ui/ValidatedSelect.vue";

export default defineComponent({
  components: {
    ValidatedSelect
  },
  props: {
    all: {
      type: Boolean,
      default: false
    },
    required: {
      type: Boolean,
      default: false
    },
    label: {
      type: String,
      default: ""
    },
    help: {
      type: String,
      default: ""
    },
    value: {
      type: String,
      required: true
    }
  },
  emits: ["input"],
  setup() {
    App.fetchBases();
  },
  data() {
    return {
      allValue: 0
    };
  },
  computed: {
    list() {
      return App.bases;
    }
  }
});
</script>
