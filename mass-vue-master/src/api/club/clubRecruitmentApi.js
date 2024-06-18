import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listClubActivityPage(params) {
    return request({
      url: "/clubRecruitment/listClubRecruitmentPage",
      method: "get",
      params
    })
  },
  // 报名
  saveRecruitment(body) {
    return request({
      url: "/clubRecruitment/saveRecruitment",
      method: "post",
      data: body
    })
  },
  // 取消报名
  cancelRecruitment(body) {
    return request({
      url: "/clubRecruitment/cancelRecruitment",
      method: "post",
      data: body
    })
  },
  // 审批
  approve(body) {
    return request({
      url: "/clubRecruitment/approve",
      method: "post",
      data: body
    })
  },
  // 删除
  deleteBatch(data) {
    return request({
      url: "/clubRecruitment/deleteBatch",
      method: "delete",
      data
    })
  }
}
