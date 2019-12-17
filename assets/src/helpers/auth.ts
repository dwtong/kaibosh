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

  saveAuthTokenFromUrlParams() {
    const urlParams = new URLSearchParams(window.location.search);
    const client = urlParams.get("client");
    const accessToken = urlParams.get("access-token");
    const uid = urlParams.get("uid");

    if (client && accessToken && uid) {
      localStorage.setItem("client", client);
      localStorage.setItem("uid", uid);
      localStorage.setItem("access-token", accessToken);
      localStorage.setItem("token-type", "Bearer");
    }
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
