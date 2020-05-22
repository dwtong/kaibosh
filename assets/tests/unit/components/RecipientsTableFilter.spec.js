import { mount, shallowMount, createLocalVue } from "@vue/test-utils";
import Vuex from "vuex";
import Buefy from "buefy";
import RecipientsTableFilter from "@/components/RecipientsTableFilter.vue";
import state from "@/store/modules/recipients/state";

const localVue = createLocalVue();

localVue.use(Vuex);
localVue.use(Buefy);

describe("RecipientsTableFilter.vue", () => {
  let actions;
  let store;
  let stubs;

  beforeEach(() => {
    actions = {
      updateNameFilter: jest.fn(),
      toggleStatusFilter: jest.fn(),
      resetFilters: jest.fn()
    };

    stubs = {
      BaseSelect: { template: "<div />" }
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

  describe("status filter", () => {
    it("renders all status filters", () => {
      const wrapper = shallowMount(RecipientsTableFilter, { store, localVue });
      const checkboxes = wrapper.findAll("b-checkbox-stub");
      expect(checkboxes.length).toBe(state.filters.status.length);
    });

    it("renders active status label", () => {
      const wrapper = mount(RecipientsTableFilter, { store, localVue, stubs });
      const activeStatusLabel = wrapper.find("#active-filter > .b-checkbox > .control-label");
      expect(activeStatusLabel.text()).toEqual("Active");
    });

    it('dispatches "toggleStatusFilter" when status checkboxes are changed', () => {
      const wrapper = mount(RecipientsTableFilter, { store, localVue, stubs });
      const activeStatusInput = wrapper.find('input[name="active"]');
      activeStatusInput.setChecked();
      expect(actions.toggleStatusFilter).toBeCalled();
      expect(actions.toggleStatusFilter.mock.calls[0][1]).toEqual("active");
    });
  });

  describe("name filter", () => {
    it('dispatches "updateNameFilter" when name input event value is changed', () => {
      const wrapper = shallowMount(RecipientsTableFilter, { store, localVue });
      const nameInput = wrapper.find("#name-filter");
      const text = "some text to filter by";
      nameInput.element.value = text;
      nameInput.trigger("input");
      expect(actions.updateNameFilter).toBeCalled();
      expect(actions.updateNameFilter.mock.calls[0][1]).toEqual(text);
    });
  });

  describe("reset filters button", () => {
    it('dispatches "resetFilters" when button is clicked', () => {
      const wrapper = shallowMount(RecipientsTableFilter, { store, localVue });
      const resetFilterButton = wrapper.find("#reset-filter-link");
      resetFilterButton.trigger("click");
      expect(actions.resetFilters).toBeCalled();
    });
  });
});
