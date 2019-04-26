import { mount, shallowMount, createLocalVue } from "@vue/test-utils";
import Vuex from "vuex";
import Buefy from "buefy";
import VeeValidate from "vee-validate";
import RecipientForm from "@/components/RecipientForm.vue";
import state from "@/store/modules/bases/state";

const localVue = createLocalVue();
const bases = [{ id: 1, name: "Base 1" }, { id: 2, name: "Base 2" }];

localVue.use(Vuex);
localVue.use(Buefy);
localVue.use(VeeValidate);

describe("RecipientForm.vue", () => {
  let actions;
  let store;
  let provide;

  beforeEach(() => {
    actions = {
      getBases: jest.fn()
    };

    provide = {
      $validator: new VeeValidate.Validator()
    };

    store = new Vuex.Store({
      modules: {
        bases: {
          namespaced: true,
          actions,
          state: { ...state, bases: bases }
        }
      }
    });
  });

  describe("component layout", () => {
    it("renders correctly", () => {
      const wrapper = mount(RecipientForm, { store, localVue, provide });
      expect(wrapper.element).toMatchSnapshot();
    });
  });

  describe("submitting form", () => {
    it("emits submit event", () => {
      const wrapper = shallowMount(RecipientForm, { store, localVue, provide });

      const form = wrapper.find("form");
      form.trigger("submit");
      expect(wrapper.emitted().submit).toBeTruthy();
    });
  });
});
