<template>
  <div>
    <b-field class="datepicker" v-if="isVisible">
      <b-datepicker
        ref="datepicker"
        :value="value"
        @input="setDate($event)"
        :first-day-of-week="1"
        position="is-bottom-left"
        inline
        v-click-outside="onClickOutside"
      >
        <button class="button" @click="setDate(today)" :disabled="value === today">
          <span>Today</span>
        </button>
      </b-datepicker>
    </b-field>
    <button @click="toggleDatePicker" class="button">
      Choose date
    </button>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import vClickOutside from "v-click-outside";
import { today } from "@/helpers/date";

@Component({ directives: { clickOutside: vClickOutside.directive } })
export default class WeekDatePicker extends Vue {
  @Prop(Date) readonly value!: Date;
  isVisible = false;
  today = today;

  toggleDatePicker() {
    this.isVisible = !this.isVisible;
  }

  onClickOutside() {
    this.isVisible = false;
  }

  setDate(value: Date) {
    this.$emit("input", value);
  }
}
</script>

<style lang="scss" scoped>
.datepicker {
  position: absolute;
  right: 0;
  top: 1.2rem;
  z-index: 999;
}
</style>
