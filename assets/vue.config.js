const CompressionPlugin = require("compression-webpack-plugin");
const path = require("path");

module.exports = {
  outputDir: path.resolve(__dirname, "../priv/static"),
  css: {
    loaderOptions: {
      sass: {
        prependData: `
          @import "~bulma/sass/utilities/functions";
          @import "@/assets/scss/_variables.scss";
        `
      }
    }
  },
  configureWebpack: {
    devServer: {
      overlay: {
        warnings: false,
        errors: true
      },
      disableHostCheck: true,
      hot: true
    },
    output: {
      path: path.resolve(__dirname, "../priv/static")
    },
    plugins: [new CompressionPlugin()]
  }
};
