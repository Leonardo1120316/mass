import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listClubAttachmentPage(params) {
    return request({
      url: "/clubAttachment/listAttachmentPage",
      method: "get",
      params
    })
  },
  // 获取已上传文件所有文件类型
  listMediaType() {
    return request({
      url: "/clubAttachment/listMediaType",
      method: "get"
    })
  },
  // 下载附件
  downloadAttachment(params) {
    return request({
      url: "/clubAttachment/downloadAttachment",
      method: "get",
      responseType: "blob",
      params
    })
  },
  // 删除附件
  deleteAttachment(id) {
    return request({
      url: `/clubAttachment/deleteAttachment/${id}`,
      method: "delete"
    })
  }
}
