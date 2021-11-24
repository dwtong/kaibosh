import { AxiosResponseHeaders } from "axios";

interface AuthToken {
  authorization: string;
}

export default {
  authTokenIsPresent(): boolean {
    return !!window.localStorage.getItem("authorization");
  },

  saveAuthTokenFromUrlParams() {
    const urlParams = new URLSearchParams(window.location.search);
    const authorization = urlParams.get("authorization");

    if (authorization) {
      localStorage.setItem("authorization", authorization);
    }
  },

  saveAuthToken(headers: AxiosResponseHeaders) {
    if (headers.authorization) {
      localStorage.setItem("authorization", headers.authorization);
    }
  },

  loadAuthToken(): AuthToken {
    return {
      authorization: window.localStorage.getItem("authorization") ?? ""
    };
  },

  deleteAuthToken() {
    localStorage.removeItem("authorization");
  }
};
