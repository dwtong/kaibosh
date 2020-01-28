<template>
  <div class="print">
    <div class="title-box">
      <h1 v-if="sessionDate" class="title">
        {{ sessionDate | moment("dddd h:mma") }}
      </h1>
      <h2 class="subtitle is-4">
        {{ sessionDate | moment("MMMM Do, Y") }}
      </h2>
    </div>

    <div class="columns is-multiline is-centered">
      <div
        v-for="category in foodCategories"
        :key="category.id"
        class="column is-one-third"
      >
        <div class="card">
          <div class="card-image">
            <figure class="image is-5by1">
              <img src="@/assets/images/produce.png" alt />
            </figure>
          </div>
          <div class="card-content">
            <div class="media">
              <div class="media-content">
                <p class="title is-4">
                  {{ capitalize(category.food_category.name) }}
                </p>
              </div>
            </div>

            <div class="content">
              <div
                v-for="allocation in category.allocations"
                :key="allocation.id"
              >
                <AllocationRecipient
                  :allocation="allocation"
                  :recipient="allocation.recipient"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { capitalize } from "lodash";
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { SessionSlotsModule } from "@/store/modules/session-slots";
import { BasesModule } from "@/store/modules/bases";
import AllocationRecipient from "@/components/AllocationRecipient.vue";

@Component({ components: { AllocationRecipient } })
export default class ShowSessionSlot extends Vue {
  @Prop(String) readonly id!: string;

  async created() {
    let date = this.$route.query.date;

    if (typeof date !== "string") {
      date = "";
    }

    await SessionSlotsModule.fetchAllocationsForSlot({
      sessionSlotId: this.id,
      sessionDate: date
    });
  }

  capitalize(str: string) {
    return capitalize(str);
  }

  quantity(allocation: any) {
    if (parseInt(allocation.quantity, 10) > 0) {
      return `(${allocation.quantity_label})`;
    } else {
      return "";
    }
  }

  get foodCategories() {
    return SessionSlotsModule.allocationsByFoodCategory;
  }

  get sessionDate() {
    return SessionSlotsModule.date;
  }
}
</script>

<style lang="scss" scoped>
.box {
  padding: 1rem 0.2rem;
}

.card {
  height: 100%;
}

.print {
  @media print {
    font-size: 0.8rem;
  }
}

.title-box {
  height: 100px !important;

  .subtitle {
    margin-top: 0.4rem !important;
  }

  .title {
    margin-left: 0 !important;
    margin-bottom: 0.4rem !important;

    @media print {
      font-size: 1rem;
    }
  }
}
</style>
