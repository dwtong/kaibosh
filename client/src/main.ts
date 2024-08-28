import { createApp } from "vue"
import { createPinia } from "pinia"

import "@/assets/scss/app.scss"

import App from "./App.vue"
import router from "./router"
import vueClickOutsideElement from "vue-click-outside-element"

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(vueClickOutsideElement)

app.mount("#app")
