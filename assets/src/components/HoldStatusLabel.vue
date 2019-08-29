<template>
  <b-tag rounded :type="labelType" size="is-medium">{{ label }}</b-tag>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IHold } from "../types";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import { sortBy } from "lodash";

@Component
export default class HoldStatusLabel extends Vue {
  @Prop() readonly holds!: IHold;

  get hold() {
    return sortBy(this.holds, ["starts_at"])[0];
  }

  get label() {
    if (this.hold) {
      // @ts-ignore - lodash sortBy breaks check
      return `On hold from ${this.hold.starts_at}`;
    } else {
      return "active";
    }
  }

  get labelType() {
    if (this.hold) {
      return "is-warning";
    } else {
      return "is-primary";
    }
  }
}
</script>
