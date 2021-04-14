<template>
  <div>
    <div v-for="category in allocationCategories" :key="category.categoryId">
      <div class="level box" :class="{ disabled: category.enabled == false }">
        <div class="level-left">
          <div class="level-item">
            <b-checkbox v-model="category.enabled" type="is-info">
              <p class="category-label">{{ category.name }}</p></b-checkbox
            >
          </div>
        </div>
        <div class="level-right">
          <div class="level-item">
            <div class="field allocation-field has-addons">
              <p class="control">
                <AllocationQuantitesSelect
                  :value="getCategoryQuantity(category)"
                  :disabled="!category.enabled"
                  @input="setCategoryQuantity(category, $event)"
                />
              </p>
              <p class="control">
                <button class="button is-static">{{ category.unit }} (max)</button>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
:w
import { IAllocationCategory } from "@/types";
import App from "@/store/modules/app";
import { sortBy } from "lodash";
import AllocationQuantitesSelect from "@/components/ui/AllocationQuantitesSelect.vue";

export default defineComponent({
  components: {
    AllocationQuantitesSelect
  },
  props: {
    value: {
      type: Array,
      required: true
    }
  },
  setup(props) {
    const unsortedAllocationCategories = App.categories.map(fc => {
      const allocation: any = props.value.find((a: any) => a.categoryId === fc.id);

      if (allocation) {
        return {
          id: allocation.id,
          enabled: true,
          quantity: allocation.quantity,
          categoryId: fc.id,
          name: fc.name
        };
      } else {
        return {
          id: null,
          enabled: false,
          quantity: "0.0",
          quantityLabel: "",
          categoryId: fc.id,
          name: fc.name
        };
      }
    });

    const allocationCategories = sortBy(unsortedAllocationCategories, ["name"]);

    // TODO how to emit/watch?
    watch(
      () => allocationCategories,
      (allocationCategories: any) => {
        const allocations = allocationCategories
          .filter((allocation: IAllocationCategory) => allocation.enabled)
          .map((allocation: IAllocationCategory) => {
            return {
              categoryId: allocation.categoryId,
              quantity: allocation.quantity,
              id: allocation.id
            };
          });
        this.$emit("input", allocations);
      },
      { immediate: true, deep: true }
    );

    return {
      allocationCategories
    };
  },
  methods: {
    setCategoryQuantity(category: IAllocationCategory, quantity: string) {
      category.quantity = quantity;
    },

    getCategoryQuantity(category: IAllocationCategory): string {
      if (category.quantity === "0.0") {
        return "";
      } else {
        return category.quantity;
      }
    }
  }
});
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
  .category-label {
    color: gray;
  }
}

.category-label {
  margin-left: 0.5rem;
}

.category-quantity {
  width: 5rem;
}
</style>
