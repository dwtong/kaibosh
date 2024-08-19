<script setup lang="ts">
import MessageBox from "../ui/MessageBox.vue"

defineProps<{
  name?: string
  status?: string
  reactivate: () => void
}>()
</script>

<template>
  <transition name="fade">
    <div>
      <MessageBox v-if="status === 'pending'" title="Pending" type="is-info">
        <p>
          {{ name }} is currently pending. For a recipient to become active,
          they must:<br /><br />
          &nbsp;&nbsp;&nbsp;&nbsp;1. Have their start date set to today or
          earlier.<br />
          &nbsp;&nbsp;&nbsp;&nbsp;2. Have all 'Onboarding' items checked off.<br />
          &nbsp;&nbsp;&nbsp;&nbsp;3. Have at least one sorting session set.<br />
        </p>
      </MessageBox>

      <MessageBox
        v-if="status === 'archived'"
        title="Archived"
        type="is-warning"
      >
        <p>
          {{ name }} is currently archived.
          <a @click="reactivate">Click here</a> to reactivate them.
        </p>
      </MessageBox>
    </div>
  </transition>
</template>
