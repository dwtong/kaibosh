// https://medium.com/@lachlanmiller_52885/a-pattern-to-handle-ajax-requests-in-vuex-2d69bc2f8984
const createAPIMutation = type => ({
  SUCCESS: `${type}_SUCCESS`,
  FAILURE: `${type}_FAILURE`,
  PENDING: `${type}_PENDING`
});
export const API_CREATE_RECIPIENT = createAPIMutation("CREATE_RECIPIENT");
export const API_CREATE_SCHEDULED_SESSION = createAPIMutation(
  "CREATE_SCHEDULED_SESSION"
);
export const API_UPDATE_SCHEDULED_SESSION = createAPIMutation(
  "UPDATE_SCHEDULED_SESSION"
);
export const API_DELETE_SCHEDULED_SESSION = createAPIMutation(
  "DELETE_SCHEDULED_SESSION"
);
export const API_CREATE_SESSION_HOLD = createAPIMutation("CREATE_SESSION_HOLD");
export const API_DELETE_SESSION_HOLD = createAPIMutation("DELETE_SESSION_HOLD");
export const API_GET_RECIPIENT = createAPIMutation("GET_RECIPIENT");
export const API_GET_RECIPIENTS = createAPIMutation("GET_RECIPIENTS");
export const API_GET_SCHEDULED_SESSIONS = createAPIMutation(
  "GET_SCHEDULED_SESSIONS"
);

export const API_GET_BASES = createAPIMutation("GET_BASES");
export const API_GET_FOOD_CATEGORIES = createAPIMutation("GET_FOOD_CATEGORIES");
export const API_GET_SESSION_SLOTS = createAPIMutation("GET_SESSION_SLOTS");

export const SET_BASE_FILTER = "SET_BASE_FILTER";
export const SET_NAME_FILTER = "SET_NAME_FILTER";
export const SET_STATUS_FILTER = "SET_STATUS_FILTER";

export const PUSH_TOAST_ERROR = "PUSH_TOAST_ERROR";
