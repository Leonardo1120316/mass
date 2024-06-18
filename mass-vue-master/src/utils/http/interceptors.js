import { isNullOrUndef } from "@/utils/is"
import { useUserStore } from "@/store/modules/userInfo.js"
import { router } from "@/router/index.js"
import { lStorage } from "@/utils/cache/index.js"
import { useSettingsStore } from "@/store/modules/settings.js"

export function reqResolve(config) {
  // 防止缓存，给get请求加上时间戳
  if (config.method === "get") {
    config.params = { ...config.params, t: new Date().getTime() }
  }

  // 登录、注册登放行
  if (
    config.url !== "/auth/login" &&
    config.url !== "/auth/register" &&
    config.url !== "/code/getVerifyCode"
  ) {
    // 从浏览器中获取token
    const userStore = useUserStore()
    const token = userStore.getToken
    // const token = lStorage.getItem("token")
    console.log("请求时的token", token)
    // 如果有token，给这次请求带上token
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
      return config
    }
    // 否则跳转到登录页面
    router.push({ path: "/login" })
    return Promise.reject("请登录!")
  }

  return config
}

export function reqReject(error) {
  return Promise.reject(error)
}

export function resResolve(response) {
  const userStore = useUserStore()
  const settingsStore = useSettingsStore()

  let message
  /**
   * TODO 此处可以根据后端返回的错误码自定义框架层面的错误处理
   */
  switch (response.data.code) {
    case 999:
    case 401:
      // message = message || '登录已过期'
      message = "登录已过期，请重新登陆!"
      // 清除缓存
      lStorage.remove("token")
      // 清除用户信息、设置
      userStore.$reset()
      settingsStore.$reset()
      // 跳转到登录页面
      router.push({ path: "/login" })
      break
    case 403:
      message = message || "没有权限"
      break
    case 404:
      message = message || "资源或接口不存在"
      break
    default:
      message = message || "未知异常"
      break
  }
  return response
}

export function resReject(error) {
  let { code, message } = error.response?.data || {}
  if (isNullOrUndef(code)) {
    // 未知错误
    code = -1
    message = "网络繁忙，请稍后重试！"
  }
  console.error(`【${code}】 ${error}`)
  return Promise.reject({ code, message, error })
}
