import { required, email, min, is } from "@vee-validate/rules";
import { defineRule } from "vee-validate";
// import { capitalize } from "lodash";

// setInteractionMode("lazy");

defineRule("required", required);
defineRule("is", is);
defineRule("min", min);
defineRule("email", email);
// defineRule("excluded", excluded);

// TODO: Update custom messages for rules
// extend("required", {
//   ...required,
//   message: fieldName => `${capitalize(fieldName)} is required`
// });

// extend("is", {
//   ...is,
//   message: () => `Password does not match`
// });

// extend("min", {
//   ...min,
//   message: fieldName => `the ${fieldName} must have at least 8 characters`
// });

// extend("email", {
//   ...email,
//   message: "Value must be a valid email"
// });

// extend("excluded", {
//   ...excluded,
//   message: fieldName => `${capitalize(fieldName)} already exists`
// });
