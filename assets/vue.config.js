const CompressionPlugin = require("compression-webpack-plugin");

module.exports = {
  css: {
    loaderOptions: {
      sass: {
        data: `
          @import "~bulma/sass/utilities/functions";  
          @import "@/assets/scss/_variables.scss";
        `
      }
    }
  },
  configureWebpack: {
    devServer: {
      disableHostCheck: true,
      hot: true,
      proxy: {
        "^/api": {
          target: "http://localhost:3000",
          changeOrigin: true
        }
      }
    },
    plugins: [new CompressionPlugin()]
  }
};
