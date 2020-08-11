<template>
  <div class="print">
    <div class="title-box">
      <div class="field buttons is-pulled-right">
        <p class="control">
          <router-link :to="`/sessions/${id}/descriptions`" tag="button" class="button is-primary"
            >Recipient Descriptions</router-link
          >
        </p>

        <p class="control">
          <PrintButton label="Print Session" />
        </p>
      </div>

      <h1 v-if="sessionDate" class="title">
        {{ sessionDate | formatDate("EEEE h:mma") }}
      </h1>
      <h2 v-if="sessionDate" class="subtitle is-4">
        {{ sessionDate | formatDate("MMMM do, Y") }}
      </h2>
    </div>

    <div class="columns is-multiline is-centered">
      <div v-for="category in categories" :key="category.id" class="column card-column">
        <div class="card">
          <div v-if="category.imageName" class="card-image">
            <figure class="image is-5by1">
              <img v-if="category.imageName" class="category-image" :src="imagePath(category.imageName)" alt />
            </figure>
          </div>
          <div class="card-content">
            <div class="media">
              <div class="media-content">
                <p class="title category-title is-4">
                  {{ capitalize(category.name) }}
                </p>
              </div>
            </div>

            <div class="content">
              <div v-for="allocation in allocationsForCategory(category.id)" :key="allocation.recipientId">
                <SessionRecipient v-if="allocation" :allocation="allocation" :recipient="allocation.recipient" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { capitalize, sortBy } from "lodash";
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import App from "@/store/modules/app";
import SessionPlans from "@/store/modules/session-plans";
import SessionRecipient from "@/components/sessions/SessionRecipient.vue";
import PrintButton from "@/components/ui/PrintButton.vue";
import { formatDate } from "@/helpers/date";

@Component({ components: { SessionRecipient, PrintButton }, filters: { formatDate } })
export default class ShowSession extends Vue {
  @Prop(String) readonly id!: string;

  allocationsForCategory(categoryId: string) {
    const allocations = SessionPlans.allocationsForCategory(categoryId).map((a: any) => {
      return { ...a, recipient: SessionPlans.recipientById(a.recipientId) };
    });

    return sortBy(allocations, a => a.recipient.status);
  }

  recipientById(recipientId: string) {
    return SessionPlans.recipientById(recipientId);
  }

  async created() {
    App.enableLoading();
    const baseId = this.$route.query.baseId?.toString();
    const sessionId = this.$route.params.id?.toString();
    const date = this.$route.query.date?.toString();

    await App.fetchCategories();
    await SessionPlans.fetchPlanDetails({ baseId, sessionId, date });

    App.disableLoading();
  }

  capitalize(str: string) {
    return capitalize(str);
  }

  imagePath(imageName: string) {
    const images = require.context("@/assets/images/foods", false, /\.png$/);
    return images("./" + imageName + "-min.png");
  }

  get categories() {
    return sortBy(App.categories, "name");
  }

  get sessionDate() {
    if (SessionPlans.planDetails?.session.date) {
      return new Date(`${SessionPlans.planDetails.session.date}T${SessionPlans.planDetails.session.time}`);
    } else {
      return null;
    }
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
    width: 50%;
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

.category-image {
  @media print {
    display: none;
  }
}

.category-title {
  @media print {
    font-size: 16px !important;
    background-color: rgb(200, 200, 200);
    padding: 4px;
  }
}

.media {
  @media print {
    margin-bottom: 10px !important;
  }
}

.print {
  @media print {
    font-size: 20px;
  }
}

.title-box {
  height: 100px !important;

  @media print {
    height: 60px !important;
  }

  .subtitle {
    margin-top: 0.4rem !important;

    @media print {
      font-size: 20px;
      margin-top: 0px !important;
    }
  }

  .title {
    margin-left: 0 !important;
    margin-bottom: 0.4rem !important;

    @media print {
      font-size: 20px;
      margin-bottom: 0px !important;
    }
  }
}
</style>
