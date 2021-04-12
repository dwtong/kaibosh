<template>
  <div>
    <div class="print-only" :class="{ inactive: recipientOnHold(recipient) }">
      {{ recipient.name }}
      <span v-if="quantity && !recipientOnHold(recipient)">
        <strong>({{ quantityLabel }})</strong>
      </span>
    </div>
    <div class="is-hidden-print">
      <div class="allocation-recipient" @click="viewRecipient">
        <span v-if="quantity && !recipientOnHold(recipient)" class="tag is-pulled-right is-rounded">
          {{ quantityLabel }}
        </span>
        <span :class="{ inactive: recipientOnHold(recipient) }" class="button is-text">
          {{ recipient.name }}
        </span>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import AllocationHelper from "@/helpers/allocations";

export default defineComponent({
  props: {
    quantity: {
      type: String,
      required: true
    },
    recipient: {
      type: Object,
      required: true
    }
  },
  data() {
    return {};
  },
  computed: {
    quantityLabel(): string {
      return AllocationHelper.quantityLabel(this.quantity);
    }
  },
  methods: {
    recipientOnHold(recipient: any) {
      return recipient.status === "on_hold";
    },

    viewRecipient() {
      this.$router.push(`/recipients/${this.recipient.id}`);
    }
  }
});
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
