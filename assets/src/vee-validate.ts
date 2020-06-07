import { required, confirmed, email, min, is } from "vee-validate/dist/rules";
import { setInteractionMode, extend } from "vee-validate";

setInteractionMode("lazy");

extend("required", {
  ...required,
  message: "This field is required"
});

extend("is", {
  ...is,
  message: "This field does not match the previous field"
});

extend("min", {
  ...min,
  message: "This field requires at least 8 characters"
});

extend("email", {
  ...email,
  message: "This field must be a valid email"
});

extend("confirmed", {
  ...confirmed,
  message: "This field confirmation does not match"
});
