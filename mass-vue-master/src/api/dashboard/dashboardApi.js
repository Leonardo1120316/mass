import { defAxios as request } from "@/utils/http"

export default {
  // 获取学生仪表盘数据
  getStudentDashboard() {
    return request({
      url: "/dashboard/getStudentDashboard",
      method: "get"
    })
  },
  // 获取老师仪表盘数据
  getTeacherDashboard() {
    return request({
      url: "/dashboard/getTeacherDashboard",
      method: "get"
    })
  },
  // 获取管理员仪表盘数据
  getAdminDashboard() {
    return request({
      url: "/dashboard/getAdminDashboard",
      method: "get"
    })
  },
  // 获取最近五条系统通知
  listRecentlySystemNotice() {
    return request({
      url: "/dashboard/listRecentlySystemNotice",
      method: "get"
    })
  }
}
