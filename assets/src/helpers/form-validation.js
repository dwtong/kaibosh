import { capitalize } from "lodash";

export default {
  addErrorsToForm(newErrors, formErrors) {
    if (typeof newErrors == "object") {
      for (const field in newErrors) {
        newErrors[field].forEach(error => {
          const humanisedField = capitalize(field.split(".").pop());
          formErrors.add({
            field: field,
            msg: `${capitalize(humanisedField)} ${error}.`
          });
        });
      }
    }
  }
};
