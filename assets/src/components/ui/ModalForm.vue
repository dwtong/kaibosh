<template>
  <b-modal :active.sync="isOpen" has-modal-card>
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
              <button class="button is-light" type="button" @click="close">
                Cancel
              </button>
              <SubmitButton :disabled="loading || invalid" type="is-info">
                Save
              </SubmitButton>
            </div>
          </slot>
        </footer>
      </div>
    </ValidatedForm>
  </b-modal>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import SubmitButton from "@/components/ui/SubmitButton.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";

@Component({ components: { SubmitButton, ValidatedForm } })
export default class ModalForm extends Vue {
  @Prop() readonly loading!: string;
  @Prop({ default: false }) readonly value!: boolean;

  get isOpen() {
    return this.value;
  }

  close() {
    this.$emit("input", false);
  }

  open() {
    this.$emit("input", true);
  }

  handleSubmit() {
    this.$emit("submit");
    this.close();
  }
}
</script>

<style lang="scss" scoped>
.modal-card {
  width: 500px;
}

.modal-card-foot {
  justify-content: right;
}
</style>
