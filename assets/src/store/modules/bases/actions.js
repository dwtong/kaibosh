import apiHelper from "@/store/api-helper";
import * as types from "@/store/mutation-types";

export default {
  async getBases(store) {
    await apiHelper.get(store, {
      endpoint: "/bases",
      mutation: types.API_GET_BASES
    });
  }
};
