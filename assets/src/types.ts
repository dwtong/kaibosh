export interface IAllocation {
  categoryId: string;
  recipientId: string;
  id?: string;
  quantity: string;
}

export interface IAllocationCategory {
  categoryId: string;
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

export interface ICategory {
  id: string;
  name: string;
}

export interface IHold {
  id?: string;
  recipientSessionId?: string;
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
  status?: string;
  startedAt: Date | string;
  physicalAddress?: string;
  baseId?: string;
  contact: IContact;
  hasMetKaibosh?: boolean;
  hasSignedTerms?: boolean;
  archivedAt?: Date | string | null;
}

export interface IRecipientListItem {
  name: string;
  baseId?: string;
  id: string;
  status: string;
  description?: string;
}

export interface ISession {
  id: string;
  day: string;
  time: string;
}

export interface ISessionPlan {
  session: {
    date: Date;
    day: string;
    time: string;
    baseId: string;
  };
  recipients: IRecipientListItem[];
}

export interface ISessionPlanDetails {
  session: {
    date: Date | string;
    day: string;
    time: string;
  };
  allocations: IAllocation[];
  recipients: IRecipientListItem[];
}

export interface IRecipientSession {
  allocations?: IAllocation[];
  enabled?: boolean;
  holds?: IHold[];
  id?: string;
  recipientId: string;
  session?: ISession;
  sessionId?: string;
  status?: string;
  day?: string;
  time?: string;
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
