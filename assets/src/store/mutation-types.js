// https://medium.com/@lachlanmiller_52885/a-pattern-to-handle-ajax-requests-in-vuex-2d69bc2f8984
const createAPIMutation = type => ({
  SUCCESS: `${type}_SUCCESS`,
  FAILURE: `${type}_FAILURE`,
  PENDING: `${type}_PENDING`
});
export const API_CREATE_RECIPIENT = createAPIMutation("CREATE_RECIPIENT");
export const API_GET_RECIPIENT = createAPIMutation("GET_RECIPIENT");
export const API_GET_RECIPIENTS = createAPIMutation("GET_RECIPIENTS");
export const API_GET_BASES = createAPIMutation("GET_BASES");

export const SET_BASE_FILTER = "SET_BASE_FILTER";
export const SET_NAME_FILTER = "SET_NAME_FILTER";
export const SET_STATUS_FILTER = "SET_STATUS_FILTER";

export const PUSH_TOAST_ERROR = "PUSH_TOAST_ERROR";
