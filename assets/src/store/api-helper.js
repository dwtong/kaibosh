import axios from "axios";
const basePath = "/api/v1";

const get = async (store, { endpoint, mutation }) => {
  store.commit(mutation.PENDING);

  try {
    const response = await axios.get(basePath + endpoint);
    store.commit(mutation.SUCCESS, response.data);
  } catch (error) {
    store.commit(mutation.FAILURE);
    console.log(`API ERROR: ${error.message}`);
  }
};

const post = async (store, { endpoint, body, mutation }) => {
  store.commit(mutation.PENDING);

  try {
    const response = await axios.post(basePath + endpoint, body);
    store.commit(mutation.SUCCESS, response.data);
  } catch (error) {
    store.commit(mutation.FAILURE, error);
  }
};

export default {
  get,
  post
};
