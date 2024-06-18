import { defAxios as request } from "@/utils/http/index.js"

export default {
  // 分页查询
  listSysNoticePage(params) {
    return request({
      url: "/sysNotice/listSysNoticePage",
      method: "get",
      params
    })
  },
  // 保存或更新
  saveOrUpdateNotice(body) {
    return request({
      url: "/sysNotice/saveOrUpdateNotice",
      method: "post",
      data: body
    })
  },
  // 删除
  deleteBatch(data) {
    return request({
      url: "/sysNotice/deleteBatch",
      method: "delete",
      data
    })
  }
}
