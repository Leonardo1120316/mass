import { defAxios as request } from "@/utils/http"

export default {
  // 分页查询
  listClubFinancePage(params) {
    return request({
      url: "/clubFinance/listClubFinancePage",
      method: "get",
      params
    })
  },
  // 获取社团经费数据
  getClubFinanceEcharts() {
    return request({
      url: "/clubFinance/getClubFinanceEcharts",
      method: "get"
    })
  },
  // 保存或更新
  saveOrUpdateClubFinance(body) {
    return request({
      url: "/clubFinance/saveOrUpdateClubFinance",
      method: "post",
      data: body
    })
  },
  // 导出社团财务报告
  exportFinanceReport(body) {
    return request({
      url: "/clubFinance/exportFinanceReport",
      method: "post",
      responseType: "blob",
      data: body
    })
  },
  // 是否有财务权限
  checkFinanceAuth() {
    return request({
      url: "/clubFinance/checkFinanceAuth",
      method: "get"
    })
  },
  // 删除
  deleteBatch(data) {
    return request({
      url: "/clubFinance/deleteBatch",
      method: "delete",
      data
    })
  }
}
