<template>
  <div class="print">
    <div class="title-box">
      <h1 class="title is-inline-block">{{ sessionName }}</h1>
    </div>

    <div class="columns is-multiline is-centered">
      <div
        v-for="category in foodCategories"
        :key="category.id"
        class="column is-one-third"
        >
        <div class="card">
          <div class="card-image">
            <figure class="image is-2by1">
              <img src="@/assets/images/500x100.png" alt />
            </figure>
          </div>
          <div class="card-content">
            <div class="media">
              <div class="media-content">
                <p class="title is-4">{{ capitalize(category.food_category.name) }}</p>
              </div>
            </div>

            <div class="content">
              <div v-for="allocation in category.allocations" :key="allocation.id">
                <div class="allocation-recipient">
                  <span class="tag is-pulled-right is-rounded">
                    {{ allocation.quantity > 0 ? allocation.quantity_label: "no max" }}
                  </span>
                  {{ allocation.recipient.name }}</div>
              </div>
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

@Component
export default class ShowSessionSlot extends Vue {
  @Prop(String) readonly id!: string;
  async created() {
    await SessionSlotsModule.fetchAllocationsForSlot(this.id);
  }

  capitalize(string: string) {
    return capitalize(string);
  }

  quantity(allocation: any) {
    if (parseInt(allocation.quantity, 10) > 0) {
      return `(${allocation.quantity_label})`
    } else {
      return ""
    }
  }

  get sessionName() {
    return "Monday 10:00am";
  }
  get foodCategories() {
    const result = SessionSlotsModule.allocationsByFoodCategory;
    return result;
  }
}
</script>

<style lang="scss" scoped>
.allocation-recipient {
  margin-bottom: 0.8rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;

  .tag {
    font-weight: 800;
    margin-left: 0.1rem;
  }
}

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
  height: 60px;

  .title {
    &.is-4 {
      margin-left: 0 !important;
      margin-bottom: 0 !important;

      @media print {
        font-size: 1rem;
      }
    }
  }
}
</style>
