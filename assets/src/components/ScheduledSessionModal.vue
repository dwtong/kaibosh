<template>
  <form action="">
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Add Scheduled Session</p>
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
            <div v-for="food in categories" :key="food.id">
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
          <button type="button" class="button is-info" @click="saveSession">
            Save
          </button>
        </div>
      </footer>
    </div>
  </form>
</template>

<script>
import { mapActions, mapState } from "vuex";
import toast from "@/helpers/toast";

export default {
  computed: {
    ...mapState("bases", ["sessionSlots", "foodCategories"]),
    ...mapState("recipients", ["errors"]),

    selectedFoodCategories() {
      return {
        foodCategories: this.categories.filter(c => c.enabled === true)
      };
    }
  },

  async created() {
    await Promise.all([
      this.getSessionSlots(this.baseId),
      this.getFoodCategories()
    ]);

    this.categories = this.foodCategories.map(fc => {
      return { enabled: false, quantity: 0, ...fc };
    });
  },

  data() {
    return {
      categories: [],
      sessionSlotId: null
    };
  },

  methods: {
    ...mapActions("bases", ["getSessionSlots", "getFoodCategories"]),
    ...mapActions("recipients", ["createScheduledSession"]),

    setFoodQuantity(food, quantity) {
      if (quantity && quantity > 0) {
        food.quantity = quantity;
        food.enabled = true;
      } else {
        food.quantity = 0;
        food.enabled = false;
      }
    },

    async saveSession() {
      const allocations = this.categories.reduce((acc, fc) => {
        if (fc.enabled) {
          acc.push({ food_category_id: fc.id, quantity: fc.quantity });
        }

        return acc;
      }, []);

      const params = {
        recipient_id: this.recipientId,
        session_slot_id: this.sessionSlotId,
        allocations_attributes: allocations
      };
      await this.createScheduledSession(params);

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
.modal-card-foot {
  justify-content: right;
}
</style>
