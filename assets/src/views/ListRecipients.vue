<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">Food Recipients</h1>
      <button class="button is-primary is-pulled-right">
        Create Recipient
      </button>
    </div>

    <div class="columns">
      <div class="column">
        <div class="box">
          <RecipientsTable />
        </div>
      </div>

      <div class="column is-one-quarter">
        <div class="box">
          <RecipientsTableFilter />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import RecipientsTable from "@/components/RecipientsTable";
import RecipientsTableFilter from "@/components/RecipientsTableFilter";

export default {
  components: {
    RecipientsTable,
    RecipientsTableFilter
  }
};
</script>

<style lang="scss" scoped>
.button {
  margin-top: 0.3rem;
}

.title {
  margin-left: 0.5rem !important;
  margin-bottom: 2.5rem !important;
}

.title-box {
  margin-right: 0.5rem;
}
</style>
