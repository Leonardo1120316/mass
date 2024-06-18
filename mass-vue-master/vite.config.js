import { defineConfig, loadEnv } from "vite"
import path from "path"
// plugins配置
import { createVitePlugins } from "./build/plugin"

export default defineConfig(({ command, mode }) => {
  const isBuild = command === "build"
  const env = loadEnv(mode, process.cwd())

  return {
    plugins: createVitePlugins(env, isBuild),
    base: env.VITE_PUBLIC_PATH || "/",
    resolve: {
      // 设置别名
      alias: {
        "@": path.resolve(__dirname, "src")
      }
    },
    server: {
      host: "0.0.0.0",
      port: env.VITE_PORT,
      open: true, // 运行自动打开浏览器
      proxy: {
        "/api": {
          target: "http://localhost:8071/",
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, "")
        }
      }
    }
  }
})
