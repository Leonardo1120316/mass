import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listApproveSettingDetailPage(params) {
    return request({
      url: "/approveSettingDetail/listApproveSettingDetailPage",
      method: "get",
      params
    })
  },
  // 保存或修改
  saveOrUpdateApproveSettingDetail(body) {
    return request({
      url: "/approveSettingDetail/saveOrUpdateApproveSettingDetail",
      method: "post",
      data: body
    })
  },
  // 禁用社团
  deleteBatch(data) {
    return request({
      url: "/approveSettingDetail/deleteBatch",
      method: "delete",
      data
    })
  }
}
