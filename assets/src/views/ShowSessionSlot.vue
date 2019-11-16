<template>
  <div class="print">
    <div class="title-box">
      <h1 class="title is-inline-block">Session {{ id }}</h1>

      <link media="print" rel="Alternate" href="print.pdf" />

      <div class="columns is-multiline">
        <div
          v-for="category in foodCategories"
          :key="category.id"
          class="column is-one-third"
        >
          <div class="box">
            <h2 class="title is-4">{{ category.food_category.name }}</h2>
            <div v-for="allocation in category.allocations" :key="allocation.id">
              <div>{{allocation.recipient.name}} {{quantity(allocation)}}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { SessionSlotsModule } from "@/store/modules/session-slots";

@Component
export default class ShowSessionSlot extends Vue {
  @Prop(String) readonly id!: string;
  async created() {
    await SessionSlotsModule.fetchAllocationsForSlot(this.id);
  }

  quantity(allocation: any) {
    if (parseInt(allocation.quantity, 10) > 0) {
      return `(${allocation.quantity_label})`
    } else {
      return ""
    }
  }

  get foodCategories() {
    const result = SessionSlotsModule.allocationsByFoodCategory;
    return result;
  }
}
</script>

<style lang="scss" scoped>
.box {
  padding: 1rem 0.2rem;
}

.print {
  @media print {
    @page {
      size: landscape;
    }
  }
}

.title-box {
  height: 60px;
}
</style>
