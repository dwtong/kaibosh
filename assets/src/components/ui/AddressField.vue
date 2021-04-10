<template>
  <b-field :label="label" :message="help">
    <b-input id="address" :value="value" />
  </b-field>
</template>

<script>
export default {
  props: {
    label: {
      required: true,
      type: String
    },
    value: {
      required: false,
      default: "",
      type: String
    },
    help: {
      required: false,
      default: "",
      type: String
    }
  },
  emits: ["input"],
  mounted() {
    const script = document.createElement("script");
    script.setAttribute("src", "https://api.addressfinder.io/assets/v3/widget.js");
    script.setAttribute("async", true);
    script.onload = () => {
      const addressElement = document.getElementById("address");
      if (addressElement) {
        this.widget = new window.AddressFinder.Widget(addressElement, "A3XCU7TYNHVR48P6WK9G", "NZ", {
          address_params: {}
        });
        this.widget.on("result:select", (fullAddress, metaData) => {
          const selected = new window.AddressFinder.NZSelectedAddress(fullAddress, metaData);

          this.$emit("input", selected.fullAddress);
        });
      }
    };
    document.head.appendChild(script);
  }
};
</script>
