<template>
  <table>
    <tr
      v-for="allocation in sortedAllocations"
      :key="allocation.id"
      :allocation="allocation"
    >
      <td>{{ allocation.foodCategory }}</td>
      <td>{{ allocation.quantityLabel }}</td>
    </tr>
  </table>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IAllocation } from "../types";
import { BasesModule } from "@/store/modules/bases";
import { sortBy } from "lodash";

@Component
export default class AllocationsTable extends Vue {
  @Prop() readonly allocations!: IAllocation[];

  get sortedAllocations() {
    const allocations = this.allocations.map(allocation => {
      return {
        quantityLabel: this.allocationQuantityLabel(allocation),
        foodCategory: this.foodCategoryName(allocation),
        ...allocation
      };
    });
    return sortBy(allocations, ["foodCategory"]);
  }

  allocationQuantityLabel(allocation: IAllocation) {
    if (parseFloat(allocation.quantity)) {
      return `${allocation.quantity_label} (max)`;
    } else {
      return "no limit";
    }
  }

  foodCategoryName(allocation: IAllocation) {
    const fc = BasesModule.foodCategoryById(allocation.food_category_id);

    if (fc) {
      return fc.name;
    } else {
      return "";
    }
  }
}
</script>
