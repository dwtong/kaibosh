interface AuthToken {
  authorization: string;
}

export default {
  authTokenIsPresent(): boolean {
    return !!window.localStorage.getItem("client");
  },

  saveAuthTokenFromUrlParams() {
    const urlParams = new URLSearchParams(window.location.search);
    const authorization = urlParams.get("authorization");

    if (authorization) {
      localStorage.setItem("authorization", authorization);
    }
  },

  saveAuthToken(headers: AuthToken) {
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
