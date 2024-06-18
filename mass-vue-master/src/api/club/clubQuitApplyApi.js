import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listClubQuitApplyPage(params) {
    return request({
      url: "/clubQuitApply/listClubQuitApplyPage",
      method: "get",
      params
    })
  },
  // 新增申请
  saveClubQuitApply(body) {
    return request({
      url: "/clubQuitApply/saveClubQuitApply",
      method: "post",
      data: body
    })
  },
  // 撤销申请
  revertClubQuitApply(body) {
    return request({
      url: "/clubQuitApply/revertClubQuitApply",
      method: "post",
      data: body
    })
  },
  // 审批
  approve(data) {
    return request({
      url: "/clubQuitApply/approve",
      method: "post",
      data
    })
  }
}
