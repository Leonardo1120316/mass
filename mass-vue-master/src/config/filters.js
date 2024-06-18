import enumsConfig from "@/config/enumsConfig.js"

export const filters = {
  // 获取性别
  getSex: (sex) => {
    return enumsConfig.sex.find((enums) => enums.value === sex)
  },
  // 获取性别
  getRole: (role) => {
    return enumsConfig.role.find((enums) => enums.value === role)
  },
  // 获取用户状态
  getUserStatus: (status) => {
    return enumsConfig.User.status.find((enums) => enums.value === status)
  },
  // 获取社团状态
  getClubStatus: (status) => {
    return enumsConfig.club.status.find((enums) => enums.value === status)
  },
  // 获取社团活动状态
  getClubActivityStatus: (status) => {
    return enumsConfig.clubActivity.status.find((enums) => enums.value === status)
  },
  // 获取社团活动类型
  getClubActivityType: (type) => {
    return enumsConfig.clubActivity.type.find((enums) => enums.value === type)
  },
  // 获取入社申请状态
  getClubRecruitmentStatus: (status) => {
    return enumsConfig.clubRecruitment.status.find((enums) => enums.value === status)
  },
  // 获取退团申请状态
  getClubQuitApplyStatus: (status) => {
    return enumsConfig.clubQuitApply.status.find((enums) => enums.value === status)
  },
  // 获取审批设置状态
  getApproveSettingStatus: (status) => {
    return enumsConfig.approveSetting.status.find((enums) => enums.value === status)
  },
  // 获取审批方式
  getApproveSettingMethod: (status) => {
    return enumsConfig.approveSetting.method.find((enums) => enums.value === status)
  },
  // 获取审批记录状态
  getApproveRecordStatus: (status) => {
    return enumsConfig.approveRecord.status.find((enums) => enums.value === status)
  },
  // 获取审批记录详情状态
  getApproveRecordDetailStatus: (status) => {
    return enumsConfig.approveRecord.detailStatus.find((enums) => enums.value === status)
  },
  // 获取社团成员角色名称
  getClubUserRole: (role) => {
    return enumsConfig.clubUser.role.find((enums) => enums.value === role)
  },
  // 获取社团费用类型
  getClubFinanceType: (type) => {
    return enumsConfig.clubFinance.type.find((enums) => enums.value === type)
  },
  // 获取社团费用状态
  getClubFinanceStatus: (status) => {
    return enumsConfig.clubFinance.status.find((enums) => enums.value === status)
  },
  // 获取通知状态
  getNoticeType: (type) => {
    return enumsConfig.notice.type.find((enums) => enums.value === type)
  }
}
