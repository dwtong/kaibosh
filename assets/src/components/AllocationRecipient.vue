<template>
  <div @click="viewRecipient" class="allocation-recipient">
    <span
      v-if="allocation && !recipientOnHold(recipient)"
      class="tag is-pulled-right is-rounded"
    >
      {{ allocation.quantity > 0 ? allocation.quantity_label : "no max" }}
    </span>
    <span
      :class="{ inactive: recipientOnHold(recipient) }"
      class="button is-text"
    >
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

  viewRecipient() {
    this.$router.push(`/recipients/${this.recipient.id}`);
  }
}
</script>

<style lang="scss" scoped>
.allocation-recipient {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;

  @media print {
    margin-bottom: 0.2rem;
  }

  .tag {
    font-weight: 800;
    margin-left: 0.1rem;

    @media print {
      font-size: 12px;
      padding-top: 2px;
      font-weight: 600;
    }
  }
}

.is-text {
  margin-bottom: 0rem !important;
  text-decoration: none !important;
}

.inactive {
  text-decoration-line: line-through !important;
  color: darkgray !important;

  @media print {
    color: #4a4a4a;
  }
}
</style>
