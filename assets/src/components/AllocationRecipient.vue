<template>
  <div class="allocation-recipient">
    <span
      v-if="allocation && !recipientOnHold(recipient)"
      class="tag is-pulled-right is-rounded"
    >
      {{ allocation.quantity > 0 ? allocation.quantity_label : "no max" }}
    </span>
    <span :class="{ inactive: recipientOnHold(recipient) }">
      {{ recipient.name }}
    </span>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class AllocationRecipient extends Vue {
  @Prop(Object) readonly allocation!: any;
  @Prop(Object) readonly recipient!: any;

  recipientOnHold(recipient: any) {
    return recipient.status === "on_hold";
  }
}
</script>

<style lang="scss" scoped>
.allocation-recipient {
  margin-bottom: 0.8rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;

  .tag {
    font-weight: 800;
    margin-left: 0.1rem;
  }
}

.inactive {
  text-decoration-line: line-through;
  color: darkgray;
}
</style>
