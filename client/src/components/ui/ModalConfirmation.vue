<script setup lang="ts">
export type ButtonType =
  | "is-info"
  | "is-primary"
  | "is-success"
  | "is-warning"
  | "is-danger"

defineProps<{
  type: ButtonType
  submitButton: string
  isOpen: boolean
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
      <section class="modal-card-body">
        <slot></slot>
      </section>
      <footer class="modal-card-foot">
        <div>
          <div class="buttons is-right">
            <button class="button" @click="$emit('close')">Cancel</button>
            <button class="button" :class="type" @click="$emit('submit')">
              {{ submitButton }}
            </button>
          </div>
        </div>
      </footer>
    </div>
  </div>
</template>

<style scoped>
.modal-card {
  max-width: 450px;
}

.modal-card-body {
  text-align: center;
  border-top-left-radius: 5px;
  border-top-right-radius: 5px;
}

.modal-card-foot {
  height: 4rem;
  justify-content: flex-end;
}
</style>
