import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listClubActivityUserPage(params) {
    return request({
      url: "/clubActivityUser/listClubActivityUserPage",
      method: "get",
      params
    })
  },
  // 保存或更新
  saveOrUpdateClubActivityUser(body) {
    return request({
      url: "/clubActivityUser/saveOrUpdateClubActivityUser",
      method: "post",
      data: body
    })
  },
  // 删除
  deleteBatch(data) {
    return request({
      url: "/clubActivityUser/deleteBatch",
      method: "delete",
      data
    })
  }
}
