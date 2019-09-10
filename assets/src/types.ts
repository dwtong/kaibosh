export interface IAllocation {
  food_category_id: string;
  id: string;
  quantity: string;
  quantity_label: string;
}

export interface IAllocationCategory {
  food_category_id: string;
  enabled?: boolean;
  id: string;
  quantity: string;
  quantity_label: string;
}

export interface IBase {
  id: string;
  name: string;
}

export interface IContact {
  name: string;
  email: string;
  phone_landline: string;
  phone_mobile: string;
}

export interface IFoodCategory {
  id: string;
  name: string;
}

export interface IHold {
  id?: string;
  scheduled_session_id: string;
  starts_at: string;
  ends_at: string;
}

export interface ILoginCreds {
  email: string;
  password: string;
}

export interface IRecipient {
  name: string;
  id?: string;
  status?: string;
  started_at?: Date;
  physical_address?: string;
  base_id?: string;
  primary_contact?: IContact;
  has_met_kaibosh?: boolean;
  has_signed_terms?: boolean;
}

export interface IRecipientListItem {
  name: string;
  base_id: string;
  id: string;
  status: string;
}

export interface ISessionSlot {
  id: string;
  day: string;
  time: string;
}

export interface IScheduledSession {
  allocations?: IAllocation[];
  enabled?: boolean;
  holds?: IHold[];
  id?: string;
  recipient_id: string;
  session_slot?: ISessionSlot;
  session_slot_id?: string;
  hold_status?: string;
}

export interface IStatus {
  name: string;
  label: string;
  enabled?: boolean;
}

export interface IStatusLabelGroup {
  [key: string]: string;
}
