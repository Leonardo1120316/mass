import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listClubActivityPage(params) {
    return request({
      url: "/clubActivity/listClubActivityPage",
      method: "get",
      params
    })
  },
  // 分页查询纳新活动
  listRecruitmentActivityPage(params) {
    return request({
      url: "/clubActivity/listRecruitmentActivityPage",
      method: "get",
      params
    })
  },
  // 签到
  signUp(body) {
    return request({
      url: "/clubActivity/signUp",
      method: "post",
      data: body
    })
  },
  // 保存或更新
  saveOrUpdateClubActivity(body) {
    return request({
      url: "/clubActivity/saveOrUpdateClubActivity",
      method: "post",
      data: body
    })
  },
  // 删除
  deleteActivity(data) {
    return request({
      url: "/clubActivity/deleteActivity",
      method: "delete",
      data
    })
  },
  // 导出活动信息
  exportClubActivity(body) {
    return request({
      url: "/clubActivity/exportClubActivity",
      method: "post",
      responseType: "blob",
      data: body
    })
  }
}
