<template>
  <form @submit.prevent="">
    <div v-if="!loading" class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">
          {{ this.sessionId ? "Edit " : "Add" }} Sorting Session
        </p>
      </header>

      <section class="modal-card-body">
        <div class="columns">
          <div class="column">
            <p class="subtitle">Select session time and day</p>
            <b-field class="form-field">
              <b-select
                name="session"
                placeholder="Select an option"
                expanded
                v-model="sessionSlotId"
              >
                <option
                  v-for="session in sessionSlots"
                  :key="session.id"
                  :value="session.id"
                  >{{ session.day }} - {{ session.time }}</option
                >
              </b-select>
            </b-field>
          </div>
        </div>

        <div v-if="sessionSlotId" class="columns">
          <div class="column">
            <p class="subtitle">Choose food categories</p>
            <div v-for="food in categories" :key="food.food_category_id">
              <div
                class="level box"
                :class="{ disabled: food.enabled == false }"
              >
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
                          :value="
                            parseInt(food.quantity) > 0 ? food.quantity : null
                          "
                          @input="setFoodQuantity(food, $event.target.value)"
                          type="number"
                        />
                      </p>
                      <p class="control">
                        <button class="button is-static">
                          {{ food.unit }} (max)
                        </button>
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <footer class="modal-card-foot">
        <div class="buttons">
          <button class="button is-light" type="button" @click="$emit('close')">
            Cancel
          </button>
          <button type="submit" class="button is-info" @click="saveSession">
            Save
          </button>
        </div>
      </footer>
    </div>
  </form>
</template>

<script>
import { mapActions, mapGetters, mapState } from "vuex";
import toast from "@/helpers/toast";
import { mapEnabledFoodCategories } from "@/helpers/food-categories";

export default {
  computed: {
    ...mapState("bases", ["sessionSlots", "foodCategories"]),
    ...mapState("recipients", ["errors"]),
    ...mapGetters("recipients", ["scheduledSessionById"]),
    selectedSession() {
      return this.scheduledSessionById(this.sessionId);
    }
  },

  async created() {
    await Promise.all([
      this.getSessionSlots(this.baseId),
      this.getFoodCategories()
    ]);

    this.categories = mapEnabledFoodCategories(
      this.selectedSession,
      this.foodCategories
    );

    if (this.selectedSession) {
      this.sessionSlotId = this.selectedSession.session_slot.id;
    }

    this.loading = false;
  },

  data() {
    return {
      categories: [],
      sessionSlotId: null,
      loading: true
    };
  },

  methods: {
    ...mapActions("bases", ["getSessionSlots", "getFoodCategories"]),
    ...mapActions("recipients", [
      "createScheduledSession",
      "updateScheduledSession"
    ]),

    setFoodQuantity(food, quantity) {
      if (quantity && quantity > 0) {
        food.quantity = quantity;
        food.enabled = true;
      } else {
        food.quantity = 0;
        food.enabled = false;
      }
    },

    foodQuantityValue(quantity) {
      if (parseInt(quantity) > 0) {
        return quantity;
      } else {
        return null;
      }
    },

    async saveSession() {
      const allocations = this.categories.map(allocation => {
        if (allocation.enabled) {
          return {
            food_category_id: allocation.food_category_id,
            quantity: allocation.quantity,
            id: allocation.id
          };
        } else if (!allocation.enabled && allocation.id) {
          return { id: allocation.id, _destroy: true };
        }
      });

      if (this.selectedSession) {
        const params = {
          allocations_attributes: allocations,
          session_slot_id: this.sessionSlotId,
          ...this.selectedSession
        };
        await this.updateScheduledSession(params);
      } else {
        const params = {
          recipient_id: this.recipientId,
          session_slot_id: this.sessionSlotId,
          allocations_attributes: allocations
        };

        await this.createScheduledSession(params);
      }

      if (this.errors.length > 0) {
        toast.error("Unable to save session.");
      } else {
        this.$emit("close");
        toast.success("Session saved.");
      }
    }
  },

  props: {
    baseId: {
      required: true,
      type: Number
    },
    recipientId: {
      required: true,
      type: Number
    },
    sessionId: {
      required: false,
      type: Number
    }
  }
};
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

.modal-card {
  width: 400px;
}

.modal-card-foot {
  justify-content: right;
}
</style>
