import axios from "axios";
const basePath = "/api/v1";

const get = async (store, { endpoint, mutation, params }) => {
  store.commit(mutation.PENDING);

  try {
    const response = await axios.get(basePath + endpoint, { params });
    store.commit(mutation.SUCCESS, response.data);
  } catch (error) {
    store.commit(mutation.FAILURE, error);
  }
};

const del = async (store, { endpoint, mutation, id }) => {
  store.commit(mutation.PENDING);

  try {
    await axios.delete(basePath + endpoint + `/${id}`);
    store.commit(mutation.SUCCESS, id);
  } catch (error) {
    store.commit(mutation.FAILURE, error);
  }
};

const post = async (store, { endpoint, body, mutation }) => {
  store.commit(mutation.PENDING);

  try {
    const response = await axios.post(basePath + endpoint, body);
    store.commit(mutation.SUCCESS, response.data);
  } catch (error) {
    let errors;
    if (error.response.data) {
      errors = error.response.data;
    } else {
      errors = error.message;
    }
    store.commit(mutation.FAILURE, errors);
  }
};

const put = async (store, { endpoint, body, mutation }) => {
  store.commit(mutation.PENDING);

  try {
    const response = await axios.put(basePath + endpoint, body);
    store.commit(mutation.SUCCESS, response.data);
  } catch (error) {
    let errors;
    if (error.response.data) {
      errors = error.response.data;
    } else {
      errors = error.message;
    }
    store.commit(mutation.FAILURE, errors);
  }
};

export default {
  get,
  post,
  put,
  del
};
