<template>
  <div class="print">
    <b-loading :active.sync="isLoading"></b-loading>
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
        class="column card-column"
      >
        <div class="card">
          <div class="card-image">
            <figure class="image is-5by1">
              <img
                class="food-image"
                :src="imagePath(category.food_category.name)"
                alt
              />
            </figure>
          </div>
          <div class="card-content">
            <div class="media">
              <div class="media-content">
                <p class="title food-title is-4">
                  {{ capitalize(category.food_category.name) }}
                </p>
              </div>
            </div>

            <div class="content">
              <div
                v-for="allocation in sortCategories(category.allocations)"
                :key="allocation.id"
              >
                <AllocationRecipient
                  v-if="!isLoading"
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
import { capitalize, snakeCase, sortBy } from "lodash";
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { SessionSlotsModule } from "@/store/modules/session-slots";
import { BasesModule } from "@/store/modules/bases";
import AllocationRecipient from "@/components/AllocationRecipient.vue";

@Component({ components: { AllocationRecipient } })
export default class ShowSessionSlot extends Vue {
  @Prop(String) readonly id!: string;
  isLoading = true;

  async created() {
    let date = this.$route.query.date;

    if (typeof date !== "string") {
      date = "";
    }

    await SessionSlotsModule.fetchAllocationsForSlot({
      sessionSlotId: this.id,
      sessionDate: date
    });

    this.isLoading = false;
  }

  capitalize(str: string) {
    return capitalize(str);
  }

  sortCategories(list: any) {
    return sortBy(list, ["recipient.status", "recipient.name"]);
  }

  imagePath(str: string) {
    const fileName = snakeCase(str);
    const images = require.context("@/assets/images/foods", false, /\.png$/);
    return images("./" + fileName + ".png");
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

  @media print {
    border: 1px solid gray;
    box-shadow: unset;
    -webkit-box-shadow: unset;
  }
}

.card-column {
  -webkit-box-flex: 0;
  -ms-flex: none;
  flex: none;
  width: 33.3333%;

  @media print {
    margin: 0;
    padding: 10px;
  }
}

.card-content {
  @media print {
    padding: 8px;
  }
}

.card-image {
  @media print {
    $padding: 10px;
    padding: $padding;
    margin-top: -$padding;
    margin-bottom: -$padding;
  }
}

.food-title {
  @media print {
    font-size: 20px !important;
  }
}

.print {
  @media print {
    font-size: 20px;
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
  }
}
</style>
