import { defAxios as request } from "@/utils/http"

export default {
  // 登录
  login(data) {
    return request({
      url: "/auth/login",
      method: "post",
      data
    })
  },
  // 注册
  register(data) {
    return request({
      url: "/auth/register",
      method: "post",
      data
    })
  },
  // 退出登录
  logout() {
    return request({
      url: "/auth/loginOut",
      method: "post"
    })
  }
}
