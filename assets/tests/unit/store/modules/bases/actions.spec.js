import actions from "@/store/modules/bases/actions";
import * as types from "@/store/mutation-types";
import state from "@/store/modules/bases/state";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
const mock = new MockAdapter(axios);
const commit = jest.fn();

describe("actions", () => {
  describe("getBases", () => {
    it("calls SUCCESS mutation with list of bases on API success", async () => {
      const bases = [
        { name: "Kaibosh Wellington", id: 1 },
        { name: "Kaibosh Hutt", id: 2 }
      ];
      mock.onGet("/api/v1/bases").reply(200, bases);
      await actions.getBases({ commit, state });
      await expect(commit).toBeCalledWith(types.API_GET_BASES.PENDING);
      await expect(commit).toBeCalledWith(types.API_GET_BASES.SUCCESS, bases);
    });
  });
});
