import RecipientService from "@/services/recipient-service";
import Store from "@/store";
import { IRecipientListItem, IStatus } from "@/types";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";

@Module({ name: "allRecipients", store: Store, dynamic: true })
class AllRecipients extends VuexModule {
  list: IRecipientListItem[] = [];
  filteredBase: string = "0";
  filteredName: string = "";
  filteredStatus: IStatus[] = [
    { label: "Active", name: "active", enabled: false },
    { label: "Pending", name: "pending", enabled: false },
    { label: "On Hold", name: "on_hold", enabled: false },
    { label: "Archived", name: "archived", enabled: false }
  ];

  get filteredList() {
    const filters = this.filteredStatus.filter(f => f.enabled).map(f => f.name);

    let list: IRecipientListItem[];

    if (this.list.length === 0) {
      list = [];
    } else if (filters.length > 0) {
      list = this.list.filter(r => filters.includes(r.status));
    } else {
      list = this.list;
    }

    if (this.filteredName && this.filteredName !== "") {
      list = list.filter(r => r.name.toLowerCase().includes(this.filteredName!.toLowerCase()));
    }

    if (this.filteredBase && this.filteredBase.toString() !== "0") {
      list = list.filter(r => r.base_id === this.filteredBase);
    }

    return list;
  }

  @Mutation
  setRecipientList(recipients: IRecipientListItem[]) {
    this.list = recipients;
  }

  @Action
  async fetchRecipients() {
    try {
      const recipients = await RecipientService.all();
      this.context.commit("setRecipientList", recipients);
    } catch (e) {
      return e;
    }
  }

  @Mutation
  setFilteredBase(baseId: string) {
    this.filteredBase = baseId;
  }

  @Action
  updateBaseFilter(baseId: string) {
    this.context.commit("setFilteredBase", baseId);
  }

  @Mutation
  setFilteredName(name: string) {
    this.filteredName = name;
  }

  @Action
  updateNameFilter(name: string) {
    this.context.commit("setFilteredName", name);
  }

  @Mutation
  setFilteredStatus(statusName: string) {
    const filter = this.filteredStatus.find(f => f.name === statusName);

    if (filter) {
      filter.enabled = !filter.enabled;
    }
  }

  @Action
  toggleStatusFilter(statusName: string) {
    this.context.commit("setFilteredStatus", statusName);
  }

  @Mutation
  setFilterDefaults() {
    this.filteredBase = "0";
    this.filteredName = "";
    this.filteredStatus.forEach(f => (f.enabled = false));
  }

  @Action
  resetFilters() {
    this.context.commit("setFilterDefaults");
  }
}

export const AllRecipientsModule = getModule(AllRecipients);
