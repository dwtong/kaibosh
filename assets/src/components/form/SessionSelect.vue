<template>
  <b-field label="Select session" class="form-field">
    <b-select name="session" placeholder="Select an option" expanded>
      <option
        v-for="session in sessionSlots"
        :key="session.id"
        :value="session.id"
        >{{ session.time }} {{ session.day }}</option
      >
    </b-select>
  </b-field>
</template>

<script>
import { mapActions, mapState } from "vuex";

export default {
  computed: {
    ...mapState("bases", ["sessionSlots", "foodCategories"])
  },

  async created() {
    await Promise.all([
      this.getSessionSlots(this.baseId),
      this.getFoodCategories(this.baseId)
    ]);
  },

  data() {
    return {
      allValue: 0
    };
  },

  inject: ["$validator"],

  methods: {
    ...mapActions("bases", ["getSessionSlots", "getFoodCategories"])
  },

  props: ["baseId"]
};
</script>
