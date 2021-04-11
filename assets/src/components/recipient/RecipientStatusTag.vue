<template>
  <div>
    <div v-if="withLabel" class="field">
      <label class="label">Status</label>
      <transition name="fade">
        <b-tag rounded :type="type" :size="size">{{ label }}</b-tag>
      </transition>
    </div>
    <b-tag v-else rounded :size="size" :type="type">{{ label }}</b-tag>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { IStatusLabelGroup } from "@/types";

export default defineComponent({
  props: {
    status: {
      type: String,
      default: ""
    },
    size: {
      type: String,
      default: "is-small"
    },
    withLabel: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    label(): string {
      return this.status?.replace("_", " ");
    },

    type(): string {
      const types: IStatusLabelGroup = {
        on_hold: "is-warning",
        active: "is-primary",
        archived: "is-gray-darker",
        pending: "is-info"
      };

      return this.status ? types[this.status] : "is-gray-darker";
    }
  }
});
</script>
