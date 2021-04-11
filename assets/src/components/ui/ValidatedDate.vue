<template>
  <ValidationProvider v-slot="{ errors }" :vid="name" :name="name" :rules="rules">
    <b-field v-bind="$attrs" :type="{ 'is-danger': errors[0] }" :message="errors">
      <b-datepicker
        placeholder="Click to select..."
        :value="dateValue"
        icon-pack="fas"
        :name="name"
        :disabled="disabled"
        @input="$emit('input', $event)"
      />
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
      default: ""
    },
    disabled: {
      type: Boolean,
      default: false
    },
    rules: {
      type: Object,
      required: true
    }
  },
  emits: ["input"],
  computed: {
    dateValue(): Date | null {
      if (!this.value || this.value === "") {
        return null;
      } else {
        return new Date(this.value);
      }
    },

    label(): string {
      return this.name.replace(/-/g, " ");
    },

    name(): any {
      return this.$attrs.name || this.$attrs.label;
    }
  }
});
</script>
