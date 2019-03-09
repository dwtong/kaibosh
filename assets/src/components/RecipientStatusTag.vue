<template>
  <b-tag rounded :type="getType(status)">{{ status.replace("_", " ") }}</b-tag>
</template>

<script>
export default {
  methods: {
    getType: statusName => {
      let type = "";

      switch (statusName) {
        case "active":
          type = "is-primary";
          break;
        case "on_hold":
          type = "is-warning";
          break;
        case "archived":
          type = "is-gray-darker";
          break;
        case "pending":
          type = "is-info";
          break;
        default:
          type = "";
      }

      return type;
    }
  },

  props: {
    status: {
      default: ""
    }
  }
};
</script>
