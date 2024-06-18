import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listClubUserPage(params) {
    return request({
      url: "/clubUser/listClubUserPage",
      method: "get",
      params
    })
  },
  // 保存或更新
  saveOrUpdateClubUser(body) {
    return request({
      url: "/clubUser/saveOrUpdateClubUser",
      method: "post",
      data: body
    })
  },
  // 获取echart社团成员数据
  getClubNumberEchartsData() {
    return request({
      url: "/clubUser/getClubNumberEchartsData",
      method: "get"
    })
  },
  // 设置成员角色
  setClubUserRole(data) {
    return request({
      url: "/clubUser/setClubUserRole",
      method: "put",
      data
    })
  }
}
