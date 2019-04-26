<template>
  <b-field
    :label="label"
    :type="{ 'is-danger': errors.has('base') }"
    :message="errors.first('base')"
    class="form-field"
  >
    <b-select
      :value="value"
      @input="$emit('input', $event)"
      name="base"
      placeholder="Select an option"
      v-validate="'required'"
      expanded
    >
      <option v-if="all" :value="allValue">All</option>
      <option v-for="base in list" :key="base.id" :value="base.id">{{
        base.name
      }}</option>
    </b-select>
  </b-field>
</template>

<script>
import { mapActions, mapState } from "vuex";

export default {
  computed: {
    ...mapState("bases", ["list"])
  },

  async created() {
    await this.getBases();
  },

  data() {
    return {
      allValue: 0
    };
  },

  inject: ["$validator"],

  methods: {
    ...mapActions("bases", ["getBases"])
  },

  props: {
    all: Boolean,
    label: String,
    value: Number
  }
};
</script>
