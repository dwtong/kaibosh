import axios from "axios";
import toast from "@/helpers/toast";

const basePath = "/api/v1";

const service = axios.create({
  baseURL: basePath
});

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
