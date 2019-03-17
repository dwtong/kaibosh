import api from "@/store/api";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
const mock = new MockAdapter(axios);
const endpoint = "/test";
const path = `/api/v1${endpoint}`;

describe("api", () => {
  describe("get", () => {
    it("returns response data with successful request", async () => {
      const data = { hello: "world" };
      mock.onGet(path).reply(200, data);
      const response = await api.get(endpoint);

      expect(response.status).toEqual(200);
      expect(response.data).toEqual(data);
      expect(response.error).not.anything;
    });

    it("returns error with failed request", async () => {
      mock.onGet(path).reply(502);
      const response = await api.get(endpoint);

      expect(response.status).toEqual(502);
      expect(response.error).anything;
    });
  });

  describe("post", () => {
    it("returns created data with successful request", async () => {
      const data = { hello: "world" };
      mock.onPost(path).reply(201, { ...data, id: 1 });
      const response = await api.post(endpoint, data);
      expect(response.status).toEqual(201);
      expect(response.data).toEqual({ ...data, id: 1 });
    });

    it("returns error with failed request", async () => {
      const errorMessage = { record: "must exist" };
      mock.onPost(path).reply(422, errorMessage);
      const response = await api.post(endpoint);

      expect(response.status).toEqual(422);
      expect(response.error).toEqual(errorMessage);
    });
  });
});
