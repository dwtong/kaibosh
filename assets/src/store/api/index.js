import axios from "axios";

const basePath = "/api/v1";

const get = async endpoint => {
  try {
    const response = await axios.get(basePath + endpoint);
    return response;
  } catch (error) {
    return { error: error };
  }
};

const post = async (endpoint, body) => {
  try {
    const response = await axios.post(basePath + endpoint, body);
    return response;
  } catch (error) {
    return error;
  }
};

export default {
  get,
  post
};
