<template>
  <div>
    <div v-for="food in allocationCategories" :key="food.foodCategoryId">
      <div class="level box" :class="{ disabled: food.enabled == false }">
        <div class="level-left">
          <div class="level-item">
            <b-checkbox v-model="food.enabled" type="is-info">
              <p class="food-label">{{ food.name }}</p></b-checkbox
            >
          </div>
        </div>
        <div class="level-right">
          <div class="level-item">
            <div class="field allocation-field has-addons">
              <p class="control">
                <AllocationQuantitesSelect
                  :value="getFoodQuantity(food)"
                  :disabled="!food.enabled"
                  @input="setFoodQuantity(food, $event)"
                />
              </p>
              <p class="control">
                <button class="button is-static">{{ food.unit }} (max)</button>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop, Watch } from "vue-property-decorator";
import { IAllocation, IAllocationCategory } from "@/types";
import App from "@/store/modules/app";
import { sortBy } from "lodash";
import AllocationQuantitesSelect from "@/components/ui/AllocationQuantitesSelect.vue";

@Component({ components: { AllocationQuantitesSelect } })
export default class AllocationQuantitiesInput extends Vue {
  @Prop() readonly value!: IAllocation[];
  allocationCategories: any = [];

  created() {
    const allocations = this.value;

    const allocationCategories = App.foodCategories.map(fc => {
      const allocation = allocations.find(a => a.foodCategoryId === fc.id);

      if (allocation) {
        return {
          id: allocation.id,
          enabled: true,
          quantity: allocation.quantity,
          quantityLabel: allocation.quantityLabel,
          foodCategoryId: fc.id,
          name: fc.name
        };
      } else {
        return {
          id: null,
          enabled: false,
          quantity: "0.0",
          quantityLabel: "",
          foodCategoryId: fc.id,
          name: fc.name
        };
      }
    });

    this.allocationCategories = sortBy(allocationCategories, ["name"]);
  }

  @Watch("allocationCategories", { immediate: true, deep: true })
  onAllocationChange() {
    const allocations = this.allocationCategories
      .map((allocation: IAllocationCategory) => {
        if (allocation.enabled) {
          return {
            foodCategoryId: allocation.foodCategoryId,
            quantity: allocation.quantity,
            id: allocation.id
          };
        } else if (!allocation.enabled && allocation.id) {
          return { id: allocation.id, _destroy: true };
        } else {
          return null;
        }
      })
      .filter((a: IAllocationCategory | null) => a !== null);
    this.$emit("input", allocations);
  }

  setFoodQuantity(food: IAllocationCategory, quantity: string) {
    food.quantity = quantity;
  }

  getFoodQuantity(food: IAllocationCategory): string {
    if (food.quantity === "0.0") {
      return "";
    } else {
      return food.quantity;
    }
  }
}
</script>

<style lang="scss" scoped>
.allocation-field {
  padding-top: 0.4rem;
  padding-bottom: 0;
  margin-bottom: 0;
}
.box {
  padding: 0 0 0 0.5rem;
}

.field {
  margin-bottom: 0;
}

.disabled {
  .food-label {
    color: gray;
  }
}

.food-label {
  margin-left: 0.5rem;
}

.food-quantity {
  width: 5rem;
}
</style>
