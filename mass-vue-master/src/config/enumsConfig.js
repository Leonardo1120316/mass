export default {
  sex: [
    {
      value: 0,
      label: "女"
    },
    {
      value: 1,
      label: "男"
    }
  ],
  role: [
    {
      value: "admin",
      label: "管理员"
    },
    {
      value: "student",
      label: "学生"
    },
    {
      value: "teacher",
      label: "老师"
    }
  ],
  club: {
    status: [
      {
        value: 0,
        label: "正常",
        color: "success"
      },
      {
        value: 1,
        label: "待审批",
        color: "warning"
      },
      {
        value: 2,
        label: "审批中",
        color: "processing"
      },
      {
        value: 3,
        label: "已拒绝",
        color: "error"
      },
      {
        value: 4,
        label: "申请解散",
        color: "warning"
      }
    ]
  },
  clubUser: {
    role: [
      {
        value: "president",
        label: "社长"
      },
      {
        value: "finance",
        label: "财务"
      },
      {
        value: "member",
        label: "社团成员"
      }
    ]
  },
  clubActivity: {
    type: [
      {
        value: "normal",
        label: "一般活动"
      },
      {
        value: "recruitment",
        label: "纳新"
      }
    ],
    status: [
      {
        value: 0,
        label: "待审批",
        color: "warning"
      },
      {
        value: 1,
        label: "审批中",
        color: "processing"
      },
      {
        value: 2,
        label: "已拒绝",
        color: "error"
      },
      {
        value: 3,
        label: "未开始",
        color: "warning"
      },
      {
        value: 4,
        label: "进行中",
        color: "processing"
      },
      {
        value: 5,
        label: "已结束",
        color: "default"
      }
    ]
  },
  clubRecruitment: {
    status: [
      {
        value: 0,
        label: "待审核",
        color: "warning"
      },
      {
        value: 1,
        label: "通过",
        color: "success"
      },
      {
        value: 2,
        label: "拒绝",
        color: "error"
      },
      {
        value: 3,
        label: "已取消",
        color: "default"
      }
    ]
  },
  clubFinance: {
    type: [
      {
        value: "cost",
        label: "支出",
        color: "success"
      },
      {
        value: "income",
        label: "收入",
        color: "error"
      }
    ],
    status: [
      {
        value: 0,
        label: "待审批",
        color: "warning"
      },
      {
        value: 1,
        label: "审批中",
        color: "processing"
      },
      {
        value: 2,
        label: "已审批",
        color: "success"
      },
      {
        value: 3,
        label: "已拒绝",
        color: "error"
      }
    ]
  },
  clubQuitApply: {
    status: [
      {
        value: 0,
        label: "待审核",
        color: "warning"
      },
      {
        value: 1,
        label: "已拒绝",
        color: "success"
      },
      {
        value: 2,
        label: "同意",
        color: "error"
      },
      {
        value: 3,
        label: "已撤销",
        color: "default"
      }
    ]
  },
  approveSetting: {
    status: [
      {
        value: -1,
        label: "禁用",
        color: "default"
      },
      {
        value: 0,
        label: "正常",
        color: "success"
      }
    ],
    code: [
      {
        value: "club_apply",
        label: "社团申请"
      },
      {
        value: "club_activity_apply",
        label: "社团活动申请"
      },
      {
        value: "activity_cost_apply",
        label: "社团活动经费申请"
      },
      {
        value: "dissolve_club_apply",
        label: "解散社团申请"
      }
    ],
    method: [
      {
        value: "both",
        label: "共同审批"
      },
      {
        value: "any",
        label: "任意审批"
      }
    ]
  },
  approveRecord: {
    status: [
      {
        value: 0,
        label: "待审批",
        color: "warning"
      },
      {
        value: 1,
        label: "审批中",
        color: "processing"
      },
      {
        value: 2,
        label: "已审批",
        color: "success"
      },
      {
        value: 3,
        label: "已拒绝",
        color: "error"
      }
    ],
    detailStatus: [
      {
        value: -1,
        label: "拒绝",
        color: "error"
      },
      {
        value: 0,
        label: "待审批",
        color: "warning"
      },
      {
        value: 1,
        label: "同意",
        color: "success"
      }
    ]
  },
  User: {
    status: [
      {
        value: -1,
        label: "禁用",
        color: "default"
      },
      {
        value: 0,
        label: "正常",
        color: "success"
      }
    ]
  },
  notice: {
    type: [
      {
        value: "club",
        label: "社团通知",
        color: "default"
      },
      {
        value: "system",
        label: "系统通知",
        color: "success"
      }
    ]
  }
}
