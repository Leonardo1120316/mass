import { defAxios as request } from "@/utils/http"

export default {
  // 获取验证码
  getVerifyCode(params) {
    return request({
      url: "/code/getVerifyCode",
      method: "get",
      params
    })
  }
}
