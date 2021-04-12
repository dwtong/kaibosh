<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm v-if="recipient" :recipient="recipient" @submit="updateRecipient" />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import RecipientForm from "@/components/recipient/RecipientForm.vue";
import ActiveRecipient from "@/store/modules/active-recipient";
import { IRecipient } from "@/types";
import toast from "@/helpers/toast";
import LoadRecipient from "@/mixins/load-recipient";

export default defineComponent({
  components: {
    RecipientForm
  },
  mixins: [LoadRecipient],
  props: {
    id: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      recipient: ActiveRecipient.details
    };
  },
  methods: {
    async updateRecipient(params: IRecipient) {
      await ActiveRecipient.updateRecipient(params);
      this.$router.push(`/recipients/${params.id}`);
      toast.success("Recipient updated.");
    }
  }
});
</script>
