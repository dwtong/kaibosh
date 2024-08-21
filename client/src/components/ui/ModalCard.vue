<script lang="ts" setup>
defineProps<{
  isOpen: boolean
  title: string
  submitButton: string
  disableSubmit: boolean
}>()
defineEmits<{
  (e: "close"): void
  (e: "submit"): void
}>()
</script>

<template>
  <div class="modal" :class="{ 'is-active': isOpen }">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">{{ title }}</p>
        <button
          class="delete"
          aria-label="close"
          @click="$emit('close')"
        ></button>
      </header>
      <section class="modal-card-body">
        <slot></slot>
      </section>
      <footer class="modal-card-foot">
        <div>
          <div class="buttons is-right">
            <button class="button" @click="$emit('close')">Cancel</button>
            <button
              :disabled="disableSubmit"
              class="button is-info"
              @click="$emit('submit')"
            >
              {{ submitButton }}
            </button>
          </div>
        </div>
      </footer>
    </div>
  </div>
</template>

<style scoped>
.modal-card-foot {
  justify-content: flex-end;
}
</style>
