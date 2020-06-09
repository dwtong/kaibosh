export interface IAllocation {
  foodCategoryId: string;
  id: string;
  quantity: string;
  quantityLabel: string;
}

export interface IAllocationCategory {
  foodCategoryId: string;
  enabled?: boolean;
  id: string;
  quantity: string;
  quantityLabel: string;
}

export interface IBase {
  id: string;
  name: string;
}

export interface IContact {
  name: string;
  email: string;
  phoneLandline: string;
  phoneMobile: string;
}

export interface IFoodCategory {
  id: string;
  name: string;
}

export interface IHold {
  id?: string;
  sessionId: string;
  startsAt: string;
  endsAt: string;
}

export interface ILoginCreds {
  email: string;
  password: string;
}

export interface IRecipient {
  name: string;
  id?: string;
  description?: string;
  descriptionHtml?: string;
  status?: string;
  startedAt: Date | string;
  physicalAddress?: string;
  baseId?: string;
  primaryContact: IContact;
  hasMetKaibosh?: boolean;
  hasSignedTerms?: boolean;
}

export interface IRecipientListItem {
  name: string;
  baseId?: string;
  id: string;
  status: string;
  description?: string;
  descriptionHtml?: string;
}

export interface ISessionSlot {
  id: string;
  day: string;
  time: string;
  date: string;
  recipients: IRecipientListItem[];
}

export interface IScheduledSession {
  allocations?: IAllocation[];
  enabled?: boolean;
  holds?: IHold[];
  id?: string;
  recipientId: string;
  sessionSlot?: ISessionSlot;
  sessionSlotId?: string;
  holdStatus?: string;
}

export interface IStatus {
  name: string;
  label: string;
  enabled?: boolean;
}

export interface IStatusLabelGroup {
  [key: string]: string;
}

export interface IUser {
  email: string;
}
