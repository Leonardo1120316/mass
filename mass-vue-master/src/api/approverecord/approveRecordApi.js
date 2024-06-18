import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listApproveRecordPage(params) {
    return request({
      url: "/approveRecord/listApproveRecordPage",
      method: "get",
      params
    })
  },
  // 审批
  approve(body) {
    return request({
      url: "/approveRecord/approve",
      method: "post",
      data: body
    })
  },
  // 驳回社团活动申请
  revertActivityApply(body) {
    return request({
      url: "/approveRecord/revertActivityApply",
      method: "post",
      data: body
    })
  },
  // 删除
  deleteBatch(data) {
    return request({
      url: "/approveRecord/deleteBatch",
      method: "delete",
      data
    })
  }
}
