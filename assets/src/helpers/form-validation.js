import { capitalize } from "lodash";

export default {
  addErrorsToForm(errors) {
    if (typeof errors == "object") {
      for (const field in errors) {
        errors[field].forEach(error => {
          const humanisedField = capitalize(field.split(".").pop());
          this.errors.add({
            field: field,
            msg: `${capitalize(humanisedField)} ${error}.`
          });
        });
      }
    }
  }
};
