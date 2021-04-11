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
import { defineComponent } from "vue";
import vClickOutside from "v-click-outside";
import { today } from "@/helpers/date";

export default defineComponent({
  directives: {
    clickOutside: vClickOutside.directive
  },
  props: {
    value: {
      type: Date,
      required: true
    }
  },
  emits: ["input"],
  data() {
    return {
      isVisible: false,
      today: today
    };
  },
  methods: {
    toggleDatePicker() {
      this.isVisible = !this.isVisible;
    },

    onClickOutside() {
      this.isVisible = false;
    },

    setDate(value: Date) {
      this.$emit("input", value);
    }
  }
});
</script>

<style lang="scss" scoped>
.datepicker {
  position: absolute;
  right: 0;
  top: 1.2rem;
  z-index: 999;
}
</style>
