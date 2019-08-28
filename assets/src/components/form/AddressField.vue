<template>
  <b-field :label="label">
    <b-input id="address" :value="value" />
  </b-field>
</template>

<script>
export default {
  mounted() {
    const script = document.createElement("script");
    script.setAttribute(
      "src",
      "https://api.addressfinder.io/assets/v3/widget.js"
    );
    script.setAttribute("async", true);
    script.onload = () => {
      this.widget = new window.AddressFinder.Widget(
        document.getElementById("address"),
        "A3XCU7TYNHVR48P6WK9G",
        "NZ",
        {
          address_params: {}
        }
      );
      this.widget.on("result:select", (fullAddress, metaData) => {
        const selected = new window.AddressFinder.NZSelectedAddress(
          fullAddress,
          metaData
        );

        this.$emit("input", selected.fullAddress);
      });
    };
    document.head.appendChild(script);
  },

  props: ["label", "value"]
};
</script>
