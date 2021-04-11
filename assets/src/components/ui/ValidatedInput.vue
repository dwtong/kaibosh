<template>
  <ValidationProvider v-slot="{ errors }" :vid="name" :name="name" :rules="rules">
    <b-field v-bind="$attrs" :type="{ 'is-danger': errors[0] }" :message="errors.length > 0 ? errors : help">
      <b-input :value="value" v-bind="$attrs" :type="type" @input="$emit('input', $event)" />
    </b-field>
  </ValidationProvider>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { ValidationProvider } from "vee-validate";

export default defineComponent({
  components: {
    ValidationProvider
  },
  props: {
    value: {
      type: String,
      required: true
    },
    type: {
      type: String,
      default: "text"
    },
    help: {
      type: String,
      default: ""
    },
    rules: {
      type: Object,
      required: true
    }
  },
  emits: ["input"],
  computed: {
    label(): string {
      return this.name.replace(/-/g, " ");
    },

    name(): any {
      return this.$attrs.name || this.$attrs.label;
    }
  }
});
</script>
