import { createHtmlPlugin } from "vite-plugin-html"

export function configHtmlPlugin(viteEnv, isBuild) {
  const htmlPlugin = createHtmlPlugin({
    minify: isBuild,
    inject: {
      data: {
        title: viteEnv.VITE_APP_TITLE
      }
    }
  })
  return htmlPlugin
}
