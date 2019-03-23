import { shallowMount, createLocalVue } from "@vue/test-utils";
import Vuex from "vuex";
import CreateRecipient from "@/views/CreateRecipient.vue";
import state from "@/store/modules/recipients/state";

const localVue = createLocalVue();

localVue.use(Vuex);

describe("CreateRecipient.vue", () => {
  let actions;
  let store;

  beforeEach(() => {
    actions = {
      createRecipient: jest.fn()
    };

    store = new Vuex.Store({
      modules: {
        recipients: {
          namespaced: true,
          actions,
          state
        }
      }
    });
  });

  describe("submitForm", () => {
    it("calls createRecipient action with form values", () => {
      const orgName = "Wellington Food Bank";
      const wrapper = shallowMount(CreateRecipient, { store, localVue });
      const orgNameInput = wrapper.find("#org-name-field");
      const createButton = wrapper.find("#submit-button");
      orgNameInput.element.value = orgName;
      orgNameInput.trigger("input");
      createButton.trigger("click");
      expect(actions.createRecipient).toBeCalled();
      expect(actions.createRecipient.mock.calls[0][1]).toEqual({
        recipient: { name: orgName }
      });
    });
  });
});
