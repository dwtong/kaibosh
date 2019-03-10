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
      disableHostCheck: true
    }
  }
};
