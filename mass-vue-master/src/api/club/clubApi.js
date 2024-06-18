import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listClubPage(params) {
    return request({
      url: "/club/listClubPage",
      method: "get",
      params
    })
  },
  // 分页查询社团信息
  listClubInfoPage(params) {
    return request({
      url: "/club/listClubInfoPage",
      method: "get",
      params
    })
  },
  // 查询社团信息
  getClubInfo(params) {
    return request({
      url: "/club/getClubInfo",
      method: "get",
      params
    })
  },
  // 查询所有社团
  listAllClub(params) {
    return request({
      url: "/club/listAllClub",
      method: "get",
      params
    })
  },
  // 查询当前用户所在社团列表
  listCurrentUserClub() {
    return request({
      url: "/club/listCurrentUserClub",
      method: "get"
    })
  },
  // 是否为社长
  isClubLeader() {
    return request({
      url: "/club/isClubLeader",
      method: "get"
    })
  },
  // 申请社团
  applyClub(body) {
    return request({
      url: "/club/applyClub",
      method: "post",
      data: body
    })
  },
  // 更换社长
  changePresident(body) {
    return request({
      url: "/club/changePresident",
      method: "post",
      data: body
    })
  },
  // 更新社团信息
  updateClub(body) {
    return request({
      url: "/club/updateClub",
      method: "put",
      data: body
    })
  },
  // 申请解散社团
  applyDissolveClub(body) {
    return request({
      url: "/club/applyDissolveClub",
      method: "delete",
      data: body
    })
  },
  // 移除成员
  removeMember(data) {
    return request({
      url: "/club/removeMember",
      method: "delete",
      data
    })
  },
  // 导出社团信息
  exportClub(body) {
    return request({
      url: "/club/exportClub",
      method: "post",
      responseType: "blob",
      data: body
    })
  }
}
