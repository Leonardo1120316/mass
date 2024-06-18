import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listApproveSettingPage(params) {
    return request({
      url: "/approveSetting/listApproveSettingPage",
      method: "get",
      params
    })
  },
  // 保存或修改
  saveOrUpdateApproveSetting(body) {
    return request({
      url: "/approveSetting/saveOrUpdateApproveSetting",
      method: "post",
      data: body
    })
  },
  // 删除
  deleteById(data) {
    return request({
      url: "/approveSetting/deleteBatch",
      method: "delete",
      data
    })
  }
}
