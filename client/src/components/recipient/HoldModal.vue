<script lang="ts" setup>
import ModalCard from "@/components/ui/ModalCard.vue"
import { toTypedSchema } from "@vee-validate/zod"
import { useForm } from "vee-validate"
import { computed, reactive, ref } from "vue"
import { object, date } from "zod"
import ValidatedDate from "../ui/ValidatedDate.vue"
import CheckBox from "../ui/CheckBox.vue"
import { type RecipientSession } from "@/api/recipient-sessions"
import { capitalize } from "es-toolkit"
import { endOfDayString, formatTime, startOfDayString } from "@/utils/date"
import SubmitButton from "../ui/SubmitButton.vue"
import { createHold } from "@/api/recipient-sessions"
import { toast } from "@/utils/toast"
import { useRecipientSessionsStore } from "@/stores/recipient-sessions"

const props = defineProps<{
  recipientSessions: RecipientSession[]
  recipientId: string
}>()
const { fetchRecipientSessions } = useRecipientSessionsStore()
const isOpen = ref(false)
const noEndDate = ref(false)
const isSubmitting = ref(false)
const allSessions = ref(false)
const sessions = reactive(
  props.recipientSessions.map((rs) => {
    return {
      ...rs,
      enabled: false,
    }
  }),
)
const validationSchema = toTypedSchema(
  object({
    startDate: date(),
    endDate: date().optional(),
  })
    .refine((data) => noEndDate.value || !!data.endDate, {
      path: ["endDate"],
      message: "End date is required",
    })
    .refine(
      (data) =>
        noEndDate.value || (data.endDate && data.endDate >= data.startDate),
      {
        path: ["endDate"],
        message: "End date must be after start date",
      },
    ),
)
const { handleSubmit, submitCount } = useForm({
  validationSchema,
})
const showErrors = computed(() => submitCount.value > 0)
const sessionsSelected = computed(
  () => !!allSessions.value || !!sessions.filter((s) => s.enabled).length,
)

function onClose() {
  isOpen.value = false
}

function openModal() {
  isOpen.value = true
}

const submit = handleSubmit(async ({ startDate, endDate }) => {
  isSubmitting.value = true
  const sessionsToSubmit = allSessions.value
    ? sessions
    : sessions.filter((s) => s.enabled)

  const sessionPromises = []
  for (const recipientSession of sessionsToSubmit) {
    const params = {
      recipientSessionId: recipientSession.id,
      startsAt: startOfDayString(startDate),
      endsAt: noEndDate.value ? null : endOfDayString(endDate as Date),
    }
    sessionPromises.push(createHold(props.recipientId, params))
  }

  try {
    await Promise.all(sessionPromises)
    await fetchRecipientSessions(props.recipientId)
    toast({ message: "Holds created", type: "is-success" })
    sessions.forEach((s) => (s.enabled = false))
    allSessions.value = false
    submitCount.value = 0
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to create holds", type: "is-danger" })
  } finally {
    isSubmitting.value = false
    isOpen.value = false
  }
})
</script>

<template>
  <slot :open="openModal"></slot>
  <form
    class="form"
    :validation-schema="validationSchema"
    @submit.prevent="submit"
  >
    <ModalCard :is-open="isOpen" title="Set hold date" @close="onClose">
      <div class="hold-modal">
        <div class="columns">
          <div class="column">
            <ValidatedDate
              name="startDate"
              label="start date"
              :show-error="showErrors"
              placeholder="Click to select..."
            />
            <ValidatedDate
              name="endDate"
              label="end date"
              :show-error="showErrors"
              :disabled="noEndDate"
              placeholder="Click to select..."
            />
            <div class="field">
              <CheckBox
                class="checkbox"
                label="No end date"
                :value="noEndDate"
                @input="noEndDate = !noEndDate"
              />
            </div>
          </div>
        </div>

        <div class="columns">
          <div class="column">
            <p class="subtitle">Sessions</p>
            <CheckBox
              class="checkbox"
              label="All sessions"
              :value="allSessions"
              @input="allSessions = !allSessions"
            />
            <div v-for="session in sessions" :key="session.id">
              <CheckBox
                class="checkbox"
                :disabled="allSessions"
                :label="`${capitalize(session.day)} ${formatTime(
                  session.time,
                )}`"
                :value="session.enabled || allSessions"
                @input="session.enabled = !session.enabled"
              />
            </div>
          </div>
        </div>
      </div>
      <template #submit>
        <SubmitButton
          label="Save"
          :is-submitting="isSubmitting"
          :disabled="!sessionsSelected"
        />
      </template>
    </ModalCard>
  </form>
</template>

<style scoped>
.hold-modal {
  min-height: 520px;
}
</style>
