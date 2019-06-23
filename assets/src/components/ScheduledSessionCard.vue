<template>
  <b-collapse aria-id="contentIdForA11y3" :open="isOpen" class="session-card">
    <div
      slot="trigger"
      aria-controls="contentIdForA11y3"
      class="level box header"
    >
      <div class="level-left">
        <div class="level-item">
          <p>
            <span class="has-text-weight-semibold is-size-5 day-text"
              >{{ session.session_slot.day }}
            </span>
            <span class="is-size-5">{{ session.session_slot.time }}</span>
          </p>
        </div>
      </div>
      <div class="level-item"></div>
      <div class="level-right">
        <div class="level-item">
          <b-tag rounded :type="statusLabelType" size="is-medium">{{
            statusLabel
          }}</b-tag>
        </div>
      </div>
    </div>
    <div class="box">
      <div class="card-content">
        <div v-if="sortedHolds.length > 0" class="content">
          <p class="label">Session Holds</p>
          <table>
            <tbody>
              <tr v-for="hold in sortedHolds" :key="hold.id">
                <td>{{ holdLabel(hold) }}</td>
                <td>
                  <a
                    @click="$emit('remove-hold', hold.id)"
                    class="delete is-medium"
                  ></a>
                </td>
              </tr>
              <tr></tr>
            </tbody>
          </table>
        </div>

        <div class="content">
          <p class="label">Food Allocations</p>
          <table>
            <tr v-for="allocation in sortedAllocations" :key="allocation.id">
              <td>{{ foodCategoryName(allocation.food_category_id) }}</td>
              <td>{{ allocationQuantityLabel(allocation.quantity_label) }}</td>
            </tr>
          </table>
        </div>

        <div class="buttons">
          <a @click="$emit('edit')" class="button is-primary">Edit</a>
          <a @click="$emit('remove')" class="button is-danger">Delete</a>
        </div>
      </div>
    </div>
  </b-collapse>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import { sortBy } from "lodash";

export default {
  computed: {
    ...mapGetters("bases", ["foodCategoryById"]),
    statusLabel() {
      if (this.sortedHolds[0]) {
        return `On hold from ${this.sortedHolds[0].starts_at}`;
      } else {
        return "active";
      }
    },

    statusLabelType() {
      if (this.statusLabel == "active") {
        return "is-primary";
      } else {
        return "is-warning";
      }
    },

    sortedAllocations() {
      const allocations = this.session.allocations.map(a => {
        return {
          name: this.foodCategoryName(a.food_category_id),
          quantity: this.allocationQuantityLabel(a.quantity_label),
          ...a
        };
      });

      return sortBy(allocations, ["name"]);
    },
    sortedHolds() {
      return sortBy(this.session.holds, ["starts_at"]);
    }
  },

  async created() {
    await this.getFoodCategories();
  },

  data() {
    return {
      isOpen: false
    };
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
    },

    holdLabel(hold) {
      if (hold && hold.ends_at) {
        return `${hold.starts_at} - ${hold.ends_at}`;
      } else if (hold) {
        return `${hold.starts_at} - (no end date)`;
      } else {
        return "";
      }
    },

    toggleIsOpen() {
      this.isOpen = !this.isOpen;
    }
  },

  props: ["session"]
};
</script>

<style lang="scss" scoped>
.box {
  border-radius: 0px;
  border-color: black;
  padding: 1rem;
  box-shadow: 0;
}

.buttons {
  margin-top: 2rem;
}

.content {
  margin-bottom: 2.5rem !important;
}

.header {
  background-color: #e6e6e6;
}

.day-text {
  margin-right: 0.5rem;
}

.session-card {
  margin-bottom: 1rem;
}
</style>
