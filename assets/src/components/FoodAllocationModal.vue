<template>
  <form action="">
    <div class="modal-card" style="width: auto">
      <header class="modal-card-head">
        <p class="modal-card-title">Add Food Allocation</p>
      </header>

      <section class="modal-card-body">
        <b-field label="Select session" class="form-field">
          <b-select name="session" placeholder="Select an option" expanded>
            <option
              v-for="session in sessions"
              :key="session.id"
              :value="session.id"
              >{{ session.day }} - {{ session.time }}</option
            >
          </b-select>
        </b-field>

        <div v-for="food in foodCategories" :key="food.id">{{ food.name }}</div>
      </section>

      <footer class="modal-card-foot">
        <div class="buttons">
          <button
            class="button is-light"
            type="button"
            @click="$parent.close()"
          >
            Cancel
          </button>
          <button class="button is-primary">
            Save
          </button>
        </div>
      </footer>
    </div>
  </form>
</template>

<script>
export default {
  props: ["sessions", "foodCategories"]
};
</script>

<style lang="scss" scoped>
.modal-card-foot {
  justify-content: right;
}
</style>
