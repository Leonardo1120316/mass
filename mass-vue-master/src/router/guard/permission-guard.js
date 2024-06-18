import { WHITE_LIST } from "../white/index.js"
import { lStorage } from "@/utils/cache/index.js"

export function createPermissionGuard(router) {
  router.beforeEach(async (to, from, next) => {
    const token = lStorage.get("token")

    if (token) {
      console.log("有token")
      if (to.path === "/login") {
        // 存在token，且想跳转到登录页，则进入到后台首页
        next({ path: "/" })
      } else {
        next()
      }
    } else if (WHITE_LIST.includes(to.path)) {
      next()
    } else {
      console.log("重新登录")
      next({ path: "/login" })
    }
  })
}
