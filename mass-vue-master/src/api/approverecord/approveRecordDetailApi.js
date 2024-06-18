import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listApproveRecordDetailPage(params) {
    return request({
      url: "/approveRecordDetail/listApproveRecordDetailPage",
      method: "get",
      params
    })
  },
  // 删除
  deleteBatch(data) {
    return request({
      url: "/approveRecordDetail/deleteBatch",
      method: "delete",
      data
    })
  }
}
