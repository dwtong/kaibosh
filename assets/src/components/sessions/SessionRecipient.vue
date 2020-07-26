<template>
  <div>
    <div class="print-only" :class="{ inactive: recipientOnHold(recipient) }">
      {{ recipient.name }}
      <span v-if="quantity && !recipientOnHold(recipient)">
        <strong>({{ quantityLabel(quantity) }})</strong>
      </span>
    </div>
    <div class="is-hidden-print">
      <div class="allocation-recipient" @click="viewRecipient">
        <span v-if="quantity && !recipientOnHold(recipient)" class="tag is-pulled-right is-rounded">
          {{ quantityLabel(quantity) }}
        </span>
        <span :class="{ inactive: recipientOnHold(recipient) }" class="button is-text">
          {{ recipient.name }}
        </span>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import AllocationHelper from "@/helpers/allocations";

@Component
export default class SessionRecipient extends Vue {
  @Prop(Object) readonly quantity!: any;
  @Prop(Object) readonly recipient!: any;

  recipientOnHold(recipient: any) {
    return recipient.status === "on_hold";
  }

  viewRecipient() {
    this.$router.push(`/recipients/${this.recipient.id}`);
  }

  get quantityLabel() {
    return AllocationHelper.quantityLabel(this.quantity);
  }
}
</script>

<style lang="scss" scoped>
.print-only {
  font-size: 12px;
}

.allocation-recipient {
  @media print {
    margin-bottom: 0.2rem;
    font-size: 12px !important;
  }

  .tag {
    font-weight: 800;
    margin-left: 0.1rem;
    margin-top: 0.4rem;
  }
}

.is-text {
  margin-bottom: 0rem !important;
  text-decoration: none !important;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis !important;
  display: block;
  text-align: left;
}

.inactive {
  text-decoration-line: line-through !important;
  color: darkgray !important;
}
</style>
