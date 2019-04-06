<template>
  <b-field label="Select session" class="form-field">
    <b-select name="session" placeholder="Select an option" expanded>
      <option v-for="session in sessions" :key="session.id" :value="session.id"
        >{{ session.time }} {{ session.day }}</option
      >
    </b-select>
  </b-field>
</template>

<script>
import { mapActions, mapGetters, mapState } from "vuex";

export default {
  computed: {
    ...mapGetters("bases", ["getBase"]),
    ...mapState("bases", ["bases"]),
    foodCategories: () => this.getBase(this.baseId).foods,
    sessions: () => this.getBase(this.baseId).session_slots
  },

  async created() {
    await this.getBases();
  },

  data() {
    return {
      allValue: 0
    };
  },

  inject: ["$validator"],

  methods: {
    ...mapActions("bases", ["getBases"])
  },

  props: ["baseId"]
};
</script>
