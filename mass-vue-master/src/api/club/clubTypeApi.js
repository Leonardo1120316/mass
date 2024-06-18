import { defAxios as request } from "@/utils/http"

export default {
  // 查询所以分类
  listAllClubType(params) {
    return request({
      url: "/clubType/listAllClubType",
      method: "get",
      params
    })
  },
  // 保存或更新
  saveOrUpdateClubType(body) {
    return request({
      url: "/clubType/saveOrUpdateClubType",
      method: "post",
      data: body
    })
  },
  // 删除
  deleteById(data) {
    return request({
      url: "/clubType/deleteBatch",
      method: "delete",
      data
    })
  }
}
