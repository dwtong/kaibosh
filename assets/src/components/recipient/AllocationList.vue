<template>
  <table>
    <tr v-for="allocation in sortedAllocations" :key="allocation.id" :allocation="allocation">
      <td>{{ allocation.category }}</td>
      <td>{{ allocation.quantityLabel }}</td>
    </tr>
  </table>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IAllocation } from "@/types";
import App from "@/store/modules/app";
import { sortBy } from "lodash";

@Component
export default class AllocationList extends Vue {
  @Prop() readonly allocations!: IAllocation[];

  get sortedAllocations() {
    const allocations = this.allocations.map(allocation => {
      return {
        quantityLabel: this.allocationQuantityLabel(allocation),
        category: this.categoryName(allocation),
        id: allocation.id
      };
    });
    return sortBy(allocations, ["category"]);
  }

  allocationQuantityLabel(allocation: IAllocation) {
    const quantity = parseFloat(allocation.quantity);

    if (quantity === 1.0) {
      return "1 box (max)";
    } else if (quantity > 1.0) {
      return `${parseInt(allocation.quantity)} boxes (max)`;
    } else if (quantity > 0.0 && quantity < 1.0) {
      return `1/${parseInt(`${1.0 / quantity}`)} box (max)`;
    } else {
      return "no limit";
    }
  }

  categoryName(allocation: IAllocation) {
    const fc = App.categoryById(allocation.categoryId);

    if (fc) {
      return fc.name;
    } else {
      return "";
    }
  }
}
</script>
