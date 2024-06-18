export const basicRoutes = [
  // 展示页
  {
    path: "/",
    name: "/",
    component: () => import("@/layout/index.vue"),
    meta: {
      title: "首页",
      hidden: false,
      icon: "DashboardOutlined"
    },
    children: [
      {
        path: "",
        name: "/dashboard",
        component: () => import("@/views/index.vue"),
        meta: {
          title: "首页",
          hidden: false
        }
      },
      {
        path: "/clubInfo",
        name: "/clubInfo",
        component: () => import("@/views/club/InfoList.vue"),
        meta: {
          title: "社团信息",
          hidden: false
        }
      },
      {
        path: "/user",
        name: "/user",
        component: () => import("@/views/user/List.vue"),
        children: [],
        meta: {
          title: "用户管理",
          hidden: false
        }
      },
      {
        path: "/club",
        name: "/club",
        component: () => import("@/views/club/index.vue"),
        redirect: "/club/list",
        children: [
          {
            path: "/club/list",
            name: "/club/list",
            component: () => import("@/views/club/List.vue"),
            children: [],
            meta: {
              title: "社团列表",
              hidden: false
            }
          },
          {
            path: "/club/activity",
            name: "/club/activity",
            component: () => import("@/views/club/Activity.vue"),
            children: [],
            meta: {
              title: "活动",
              hidden: false
            }
          },
          {
            path: "/club/approve",
            name: "/club/approve",
            component: () => import("@/views/club/ApplyApprove.vue"),
            children: [],
            meta: {
              title: "入团审批",
              hidden: false
            }
          },
          {
            path: "/club/quitApply",
            name: "/club/quitApply",
            component: () => import("@/views/club/QuitApply.vue"),
            children: [],
            meta: {
              title: "退团申请",
              hidden: false
            }
          },
          {
            path: "/club/quitApprove",
            name: "/club/quitApprove",
            component: () => import("@/views/club/QuitApprove.vue"),
            children: [],
            meta: {
              title: "退团审批",
              hidden: false
            }
          },
          {
            path: "/club/type",
            name: "/club/type",
            component: () => import("@/views/club/Type.vue"),
            children: [],
            meta: {
              title: "类型管理",
              hidden: false
            }
          },
          {
            path: "/club/attachment",
            name: "/club/attachment",
            component: () => import("@/views/club/Attachment.vue"),
            children: [],
            meta: {
              title: "附件管理",
              hidden: false
            }
          }
        ],
        meta: {
          title: "社团管理",
          hidden: false
        }
      },
      {
        path: "/notice",
        name: "/notice",
        component: () => import("@/views/notice/index.vue"),
        meta: {
          title: "通知",
          hidden: false
        }
      },
      {
        path: "/recruitment",
        name: "/recruitment",
        component: () => import("@/views/club/Recruitment.vue"),
        meta: {
          title: "纳新活动",
          hidden: false
        }
      },
      {
        path: "/applyJoinClub",
        name: "/applyJoinClub",
        component: () => import("@/views/club/Apply.vue"),
        meta: {
          title: "入团申请",
          hidden: false
        }
      },
      {
        path: "/finance",
        name: "/finance",
        component: () => import("@/views/finance/index.vue"),
        meta: {
          title: "财务管理",
          hidden: false
        }
      },
      {
        path: "/approve",
        name: "/approve",
        component: () => import("@/views/approve/index.vue"),
        redirect: "/approve/waitApprove",
        children: [
          {
            path: "/approve/waitApprove",
            name: "/approve/waitApprove",
            component: () => import("@/views/approve/WaitApprove.vue"),
            children: [],
            meta: {
              title: "待审批",
              hidden: false
            }
          },
          {
            path: "/approve/approved",
            name: "/approve/approved",
            component: () => import("@/views/approve/Approved.vue"),
            children: [],
            meta: {
              title: "已审批",
              hidden: false
            }
          },
          {
            path: "/approve/setting",
            name: "/approve/setting",
            component: () => import("@/views/approve/Setting.vue"),
            children: [],
            meta: {
              title: "审批设置",
              hidden: false
            }
          }
        ],
        meta: {
          title: "审批管理",
          hidden: false
        }
      },
      {
        path: "/profile",
        name: "/profile",
        component: () => import("@/views/user/Profile.vue"),
        meta: {
          title: "个人中心",
          hidden: false
        }
      }
    ]
  },
  {
    name: "登录",
    path: "/login",
    component: () => import("@/views/login/index.vue"),
    meta: {
      title: "登录页"
    }
  },
  {
    name: "注册",
    path: "/register",
    component: () => import("@/views/register/index.vue"),
    isHidden: true,
    meta: {
      title: "用户注册"
    }
  },
  {
    name: "404",
    path: "/404",
    component: () => import("@/views/error-page/404.vue"),
    meta: {
      hidden: true
    }
  },
  {
    name: "NotFound",
    path: "/:pathMatch(.*)*",
    redirect: "/404",
    meta: {
      hidden: true
    }
  }
]
