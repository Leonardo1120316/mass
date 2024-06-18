import { createRouter, createWebHistory } from "vue-router"
import { basicRoutes as routes } from "./routes"
import { setupRouterGuard } from "./guard"

export const router = createRouter({
  // import.meta.env.BASE_URL：获取vite.config.js配置的base,默认是根目录/
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior: () => ({ left: 0, top: 0 })
  // linkActiveClass: 'active',
})

export function setupRouter(app) {
  app.use(router)
  // 路由守卫
  setupRouterGuard(router)
}
