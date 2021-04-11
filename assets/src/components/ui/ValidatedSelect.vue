<template>
  <ValidationProvider v-slot="{ errors }" :vid="name" :name="name" :rules="rules">
    <b-field v-bind="$attrs" :type="{ 'is-danger': errors[0] }" :message="errors.length > 0 ? errors : help">
      <b-select
        :value="value"
        :name="name"
        :placeholder="placeholder"
        expanded
        :disabled="disabled"
        @input="$emit('input', $event)"
      >
        <slot />
      </b-select>
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
    name: {
      type: String,
      required: true
    },
    rules: {
      type: Object,
      required: true
    },
    value: {
      type: String,
      required: true
    },
    disabled: {
      type: Boolean,
      default: false
    },
    placeholder: {
      type: String,
      default: ""
    },
    help: {
      type: String,
      default: ""
    }
  },
  emits: ["input"]
});
</script>
