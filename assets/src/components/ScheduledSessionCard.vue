<template>
  <div class="card">
    <header class="card-header">
      <p class="card-header-title">
        {{ session.session_slot.day }}
        {{ session.session_slot.time }}
      </p>
    </header>
    <div class="card-content">
      <div class="content">
        <div
          class="level"
          v-for="allocation in sortedAllocations"
          :key="allocation.id"
        >
          <div class="level-left">
            <div class="level-item">
              {{ foodCategoryName(allocation.food_category_id) }}
            </div>
          </div>
          <div class="level-right">
            <div class="level-item">
              <div class="field has-addons">
                <p class="control">
                  <button class="button is-static">
                    {{ allocationQuantityLabel(allocation.quantity_label) }}
                  </button>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <footer class="card-footer">
      <a @click="$emit('edit')" class="card-footer-item">Edit</a>
      <a @click="$emit('remove')" class="card-footer-item">Remove</a>
    </footer>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import { sortBy } from "lodash";

export default {
  computed: {
    ...mapGetters("bases", ["foodCategoryById"]),
    sortedAllocations() {
      return sortBy(this.session.allocations, ["name"]);
    }
  },

  async created() {
    await this.getFoodCategories();
  },

  methods: {
    ...mapActions("bases", ["getFoodCategories"]),
    allocationQuantityLabel(quantity) {
      if (parseInt(quantity.charAt(0))) {
        return quantity + " (max)";
      } else {
        return "no limit";
      }
    },

    foodCategoryName(id) {
      const fc = this.foodCategoryById(id);

      if (fc) {
        return this.foodCategoryById(id).name;
      } else {
        return "";
      }
    }
  },

  props: ["session"]
};
</script>
