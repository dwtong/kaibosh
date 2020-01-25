import axios from "axios";
import toast from "@/helpers/toast";
import auth from "@/helpers/auth";
import { UserModule } from "@/store/modules/user";

const basePath = "/api";

const service = axios.create({
  baseURL: basePath
});

service.interceptors.request.use(config => {
  const authHeaders = auth.loadAuthToken();
  config.headers = { ...config.headers, ...authHeaders };
  return config;
});

service.interceptors.response.use(
  response => {
    if (response.headers.client) {
      auth.saveAuthToken(response.headers);
    }
    return response;
  },
  error => {
    if (error.response.status === 401) {
      UserModule.logout();
    }
    return error;
  }
);

export const get = async (resource: string, params?: object) => {
  try {
    const response = await service.get(resource, { params });
    return Promise.resolve(response.data);
  } catch (error) {
    toast.error(`Failed to fetch ${resource}.`);
    return Promise.reject(error.response.data);
  }
};

export const post = async (resource: string, params: object) => {
  try {
    const response = await service.post(resource, params);
    return Promise.resolve(response.data);
  } catch (error) {
    toast.error(`Failed to create ${resource}.`);
    return Promise.reject(error.response.data);
  }
};

export const put = async (resource: string, params: object) => {
  try {
    const response = await service.put(resource, params);
    return Promise.resolve(response.data);
  } catch (error) {
    toast.error(`Failed to update ${resource}.`);
    return Promise.reject(error.response.data);
  }
};

export const destroy = async (resource: string) => {
  try {
    const response = await service.delete(resource);
    return Promise.resolve(response.data);
  } catch (error) {
    toast.error(`Failed to delete ${resource}.`);
    return Promise.reject(error.response.data);
  }
};
