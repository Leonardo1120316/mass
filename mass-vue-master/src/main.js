import "@/styles/normalize.css"

// ant
import Antd from "ant-design-vue"
import "ant-design-vue/dist/antd.css"

import { createApp } from "vue"
import { setupRouter } from "@/router"
import { setupStore } from "@/store"
import App from "./App.vue"

const app = createApp(App)

// 引入Pinia
setupStore(app)
// 引入router
setupRouter(app)

app.use(Antd).mount("#app")
