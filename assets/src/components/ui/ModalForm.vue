<template>
  <b-modal v-model="isOpen" has-modal-card>
    <ValidatedForm v-slot="{ invalid }" @submit="handleSubmit">
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">
            <slot name="title"></slot>
          </p>
        </header>

        <section class="modal-card-body">
          <slot></slot>
        </section>

        <footer class="modal-card-foot">
          <slot name="footer">
            <div class="buttons">
              <button class="button is-light" type="button" @click="close">Cancel</button>
              <SubmitButton :disabled="loading || invalid" type="is-info"> Save </SubmitButton>
            </div>
          </slot>
        </footer>
      </div>
    </ValidatedForm>
  </b-modal>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import SubmitButton from "@/components/ui/SubmitButton.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";

export default defineComponent({
  components: {
    SubmitButton,
    ValidatedForm
  },
  props: {
    loading: {
      type: Boolean,
      required: true
    },
    value: {
      type: Boolean,
      default: false
    }
  },
  emits: ["input", "submit"],
  computed: {
    isOpen(): boolean {
      return this.value;
    }
  },
  methods: {
    close() {
      this.$emit("input", false);
    },

    open() {
      this.$emit("input", true);
    },

    handleSubmit() {
      this.$emit("submit");
      this.close();
    }
  }
});
</script>

<style lang="scss" scoped>
.modal-card {
  width: 500px;
}

.modal-card-foot {
  justify-content: right;
}
</style>
