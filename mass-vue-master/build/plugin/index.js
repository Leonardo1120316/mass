import vue from "@vitejs/plugin-vue"

/**
 * * 扩展setup插件，支持在script标签中使用name属性
 * usage: <script setup name="MyComp"></script>
 */
import VueSetupExtend from "vite-plugin-vue-setup-extend"

import { configHtmlPlugin } from "./html"

export function createVitePlugins(viteEnv, isBuild) {
  return [vue(), VueSetupExtend(), configHtmlPlugin(viteEnv, isBuild)]
}
