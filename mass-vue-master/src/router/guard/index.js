import { createPageTitleGuard } from "./page-title-guard.js"
import {createPermissionGuard} from "./permission-guard.js";

export function setupRouterGuard(router) {
  // 权限、动态路由
  createPermissionGuard(router)
  // 页面标题
  createPageTitleGuard(router)
}
