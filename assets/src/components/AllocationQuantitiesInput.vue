<template>
  <div>
    <div v-for="food in allocationCategories" :key="food.food_category_id">
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
            <div class="field has-addons">
              <p class="control">
                <input
                  class="input food-quantity"
                  :value="getFoodQuantity(food)"
                  @input="setFoodQuantity(food, $event.target.value)"
                  :disabled="!food.enabled"
                  type="text"
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
import { IAllocation, IAllocationCategory, IFoodCategory } from "../types";
import { BasesModule } from "../store/modules/bases";
import { sortBy } from "lodash";

@Component
export default class AllocationQuantitiesInput extends Vue {
  @Prop() readonly value!: IAllocation[];
  allocationCategories: any = [];

  created() {
    const allocations = this.value;

    const allocationCategories = BasesModule.foodCategories.map(fc => {
      const allocation = allocations.find(a => a.food_category_id === fc.id);

      if (allocation) {
        return {
          id: allocation.id,
          enabled: true,
          quantity: allocation.quantity,
          quantity_label: allocation.quantity_label,
          food_category_id: fc.id,
          name: fc.name
        };
      } else {
        return {
          id: null,
          enabled: false,
          quantity: 0,
          quantity_label: "",
          food_category_id: fc.id,
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
            food_category_id: allocation.food_category_id,
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
    if (food.quantity == "0.0") {
      return "";
    } else {
      return food.quantity;
    }
  }
}
</script>

<style lang="scss" scoped>
.box {
  padding: 0.5rem;
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
