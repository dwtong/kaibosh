<template>
  <div>
    <div class="print-only" :class="{ inactive: recipientOnHold(recipient) }">
      {{ recipient.name }}
      <span v-if="allocation && !recipientOnHold(recipient)">
        <strong>({{ quantityLabel(allocation) }})</strong>
      </span>
    </div>
    <div class="is-hidden-print">
      <div @click="viewRecipient" class="allocation-recipient">
        <span
          v-if="allocation && !recipientOnHold(recipient)"
          class="tag is-pulled-right is-rounded"
        >
          {{ quantityLabel(allocation) }}
        </span>
        <span
          :class="{ inactive: recipientOnHold(recipient) }"
          class="button is-text"
        >
          {{ recipient.name }}
        </span>
      </div>
    </div>
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

  viewRecipient() {
    this.$router.push(`/recipients/${this.recipient.id}`);
  }

  quantityLabel(allocation: any) {
    return allocation.quantity > 0 ? allocation.quantity_label : "no max";
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
