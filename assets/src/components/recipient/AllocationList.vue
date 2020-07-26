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
import AllocationHelper from "@/helpers/allocations";

@Component
export default class AllocationList extends Vue {
  @Prop() readonly allocations!: IAllocation[];

  get sortedAllocations() {
    const allocations = this.allocations.map(allocation => {
      return {
        quantityLabel: AllocationHelper.quantityLabel(allocation.quantity),
        category: this.categoryName(allocation),
        id: allocation.id
      };
    });
    return sortBy(allocations, ["category"]);
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
