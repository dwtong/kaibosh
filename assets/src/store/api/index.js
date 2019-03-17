import axios from "axios";

const basePath = "/api/v1";

const errorObject = error => {
  if (error.response.data) {
    return { status: error.response.status, error: error.response.data };
  } else {
    return { status: error.response.status, error: error };
  }
};

const get = async endpoint => {
  try {
    const response = await axios.get(basePath + endpoint);
    return response;
  } catch (error) {
    return errorObject(error);
  }
};

const post = async (endpoint, body) => {
  try {
    const response = await axios.post(basePath + endpoint, body);
    return response;
  } catch (error) {
    return errorObject(error);
  }
};

export default {
  get,
  post
};
