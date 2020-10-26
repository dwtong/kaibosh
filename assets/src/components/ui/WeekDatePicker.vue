<template>
  <div>
    <b-field v-if="isVisible" class="datepicker">
      <b-datepicker
        ref="datepicker"
        v-click-outside="onClickOutside"
        :value="value"
        :first-day-of-week="1"
        position="is-bottom-left"
        inline
        @input="setDate($event)"
      >
        <button class="button" :disabled="value === today" @click="setDate(today)">
          <span>Today</span>
        </button>
      </b-datepicker>
    </b-field>
    <button class="button" @click="toggleDatePicker">Choose date</button>
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
