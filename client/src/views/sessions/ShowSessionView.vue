<script setup lang="ts">
import SessionRecipient from "@/components/sessions/SessionRecipient.vue"
import { useAppStore } from "@/stores/app"
import { useSessionPlansStore } from "@/stores/session-plans"
import { imagePath } from "@/utils/assets"
import { formatDate } from "@/utils/date"
import { capitalize, sortBy } from "es-toolkit"
import { storeToRefs } from "pinia"
import { computed, onBeforeMount } from "vue"
import { useRoute } from "vue-router"

const route = useRoute()
const sessionId = route.params.id as string
const baseId = route.query.baseId as string
const date = route.query.date as string
const appStore = useAppStore()
const sessionPlansStore = useSessionPlansStore()
const { categories } = storeToRefs(appStore)
const { planDetails } = storeToRefs(sessionPlansStore)
const sessionDate = computed(() => {
  if (planDetails.value == null) return null
  const { date, time } = planDetails.value.session
  return new Date(`${date}T${time}`)
})

function print() {
  window.print()
}

function allocationsForCategory(categoryId: string) {
  const allocations =
    sessionPlansStore.allocationsForCategory(categoryId)?.map((a) => {
      return { ...a, recipient: sessionPlansStore.recipientById(a.recipientId) }
    }) || []

  return sortBy(allocations, [(a) => [a.recipient?.status, a.recipient?.name]])
}

onBeforeMount(async () => {
  appStore.setIsLoading(true)
  await Promise.all([
    appStore.fetchCategories(),
    sessionPlansStore.fetchPlanDetails(baseId, sessionId, date),
  ])
  appStore.setIsLoading(false)
})
</script>

<template>
  <div v-if="!appStore.isLoading" class="print">
    <div class="title-box">
      <div class="field buttons is-pulled-right">
        <p class="control">
          <router-link
            :to="`/sessions/${sessionId}/descriptions?date=${date}&baseId=${baseId}`"
            class="button is-primary"
            >Recipient Descriptions</router-link
          >
        </p>

        <p class="control">
          <button class="button is-info is-hidden-print" @click="print">
            Print Session
          </button>
        </p>
      </div>

      <h1 v-if="sessionDate" class="title">
        {{ formatDate(sessionDate, "EEEE h:mma") }}
      </h1>
      <h2 v-if="sessionDate" class="subtitle is-4">
        {{ formatDate(sessionDate, "MMMM do, y") }}
      </h2>
    </div>

    <div class="columns is-multiline is-centered">
      <div
        v-for="category in categories"
        :key="category.id"
        class="column card-column is-one-third"
      >
        <div class="card">
          <div v-if="category.imageName" class="card-image">
            <figure class="image is-5by1">
              <img
                v-if="category.imageName"
                class="category-image"
                :src="imagePath(category.imageName)"
              />
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
              <div
                v-for="allocation in allocationsForCategory(category.id)"
                :key="allocation.recipientId"
              >
                <SessionRecipient
                  v-if="allocation"
                  :quantity="allocation.quantity"
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

<style lang="scss" scoped>
.columns {
  align-items: stretch;
}
.box {
  padding: 1rem 0.2rem;
}

.card {
  height: 100%;

  @media print {
    break-inside: avoid;
    border: 1px solid gray;
    box-shadow: unset;
    -webkit-box-shadow: unset;
  }
}

.card-column {
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
