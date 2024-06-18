import axios from "axios"
import { resResolve, resReject, reqResolve, reqReject } from "./interceptors"

export function createAxios(options = {}) {
  const defaultOptions = {
    baseURL: import.meta.env.VITE_APP_BASE_URL,
    timeout: 12000
  }
  const service = axios.create({
    ...defaultOptions,
    ...options
  })
  // 请求拦截器
  service.interceptors.request.use(reqResolve, reqReject)
  // 响应拦截器
  service.interceptors.response.use(resResolve, resReject)
  return service
}

// 默认axios
export const defAxios = createAxios()

// 测试用
export const testAxios = createAxios({
  baseURL: import.meta.env.VITE_APP_BASE_API_TEST
})
