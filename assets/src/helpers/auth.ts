import Router from "@/router";

interface IAuthToken {
  client: string;
  uid: string;
  "access-token": string;
  "token-type": string;
}

export default {
  authTokenIsPresent(): boolean {
    return !!window.localStorage.getItem("client");
  },

  saveAuthToken(headers: IAuthToken) {
    if (headers.client && headers["access-token"]) {
      localStorage.setItem("client", headers.client);
      localStorage.setItem("uid", headers.uid);
      localStorage.setItem("access-token", headers["access-token"]);
      localStorage.setItem("token-type", headers["token-type"]);
    }
  },

  loadAuthToken(): IAuthToken {
    return {
      client: window.localStorage.getItem("client")!,
      uid: window.localStorage.getItem("uid")!,
      "access-token": window.localStorage.getItem("access-token")!,
      "token-type": window.localStorage.getItem("token-type")!
    };
  },

  deleteAuthToken() {
    localStorage.removeItem("access-token");
    localStorage.removeItem("client");
    localStorage.removeItem("uid");
    localStorage.removeItem("token-type");
  }
};
