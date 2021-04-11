<template>
  <table>
    <tr v-for="allocation in sortedAllocations" :key="allocation.id" :allocation="allocation">
      <td>{{ allocation.category }}</td>
      <td>{{ allocation.quantityLabel }}</td>
    </tr>
  </table>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import App from "@/store/modules/app";
import { sortBy } from "lodash";
import AllocationHelper from "@/helpers/allocations";
import { IAllocation } from "@/types";

export default defineComponent({
  props: {
    allocations: {
      type: Array,
      required: true
    }
  },
  computed: {
    sortedAllocations(): any {
      const allocations = this.allocations.map((allocation: any) => {
        return {
          quantityLabel: AllocationHelper.quantityLabel(allocation.quantity),
          category: this.categoryName(allocation),
          id: allocation.id
        };
      });
      return sortBy(allocations, ["category"]);
    }
  },
  methods: {
    categoryName(allocation: IAllocation) {
      const fc = App.categoryById(allocation.categoryId);

      if (fc) {
        return fc.name;
      } else {
        return "";
      }
    }
  }
});
</script>
