import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listUserPage(params) {
    return request({
      url: "/sysUser/listUserPage",
      method: "get",
      params
    })
  },
  // 获取学生信息
  listStudentsBaseInfo() {
    return request({
      url: "/sysUser/listStudentsBaseInfo",
      method: "get"
    })
  },
  // 获取老师信息
  listTeachersBaseInfo() {
    return request({
      url: "/sysUser/listTeachersBaseInfo",
      method: "get"
    })
  },
  // 获取用户信息
  getUserInfo(params) {
    return request({
      url: "/sysUser/getUserInfo",
      method: "get",
      params
    })
  },
  // 保存或更新用户信息
  saveOrUpdateUser(body) {
    return request({
      url: "/sysUser/saveOrUpdateUser",
      method: "post",
      data: body
    })
  },
  // 更新个人信息
  updateSelfInfo(body) {
    return request({
      url: "/sysUser/updateSelfInfo",
      method: "put",
      data: body
    })
  },
  // 更新密码
  updatePassword(data) {
    return request({
      url: "/sysUser/updatePassword",
      method: "put",
      data
    })
  },
  // 删除用户
  deleteById(data) {
    return request({
      url: "/sysUser/deleteById",
      method: "delete",
      data
    })
  }
}
