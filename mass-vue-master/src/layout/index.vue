<template>
  <div class="sidebar-layout">
    <a-layout style="min-height: 100vh">
      <!-- 左侧菜单栏 -->
      <a-layout-sider
        v-model:collapsed="settingsStore.collapsed"
        :style="{
          overflow: 'auto',
          height: '100vh',
          position: 'fixed',
          left: 0,
          top: 0,
          bottom: 0
        }"
        collapsible
        theme="dark"
      >
        <!-- logo -->
        <logo />
        <!-- 菜单 -->
        <a-menu v-model:selectedKeys="settingsStore.selectedKeys" theme="dark" mode="inline">
          <a-menu-item key="/">
            <template #icon>
              <dashboard-outlined />
            </template>
            <router-link to="/">仪表盘</router-link>
          </a-menu-item>

          <a-menu-item key="/clubInfo">
            <template #icon>
              <container-outlined />
            </template>
            <router-link to="/clubInfo">社团信息</router-link>
          </a-menu-item>

          <a-sub-menu key="/club">
            <template #icon>
              <team-outlined />
            </template>
            <template #title>社团</template>

            <a-menu-item key="/club/list">
              <router-link to="/club/list">社团列表</router-link>
            </a-menu-item>

            <a-menu-item key="/club/activity">
              <router-link to="/club/activity">活动</router-link>
            </a-menu-item>

            <a-menu-item
              key="/club/type"
              v-if="userStore.userInfo.role === 'admin' || userStore.userInfo.role === 'teacher'"
            >
              <router-link to="/club/type">类型</router-link>
            </a-menu-item>

            <a-menu-item key="/club/approve">
              <router-link to="/club/approve">入团审批</router-link>
            </a-menu-item>

            <a-menu-item key="/club/quitApply">
              <router-link to="/club/quitApply">退团申请</router-link>
            </a-menu-item>

            <a-menu-item key="/club/quitApprove">
              <router-link to="/club/quitApprove">退团审批</router-link>
            </a-menu-item>

            <a-menu-item key="/club/attachment">
              <router-link to="/club/attachment">附件</router-link>
            </a-menu-item>
          </a-sub-menu>

          <a-menu-item key="/notice">
            <template #icon>
              <notification-outlined />
            </template>
            <router-link to="/notice">通知</router-link>
          </a-menu-item>

          <a-menu-item key="/recruitment">
            <template #icon>
              <contacts-outlined />
            </template>
            <router-link to="/recruitment">纳新活动</router-link>
          </a-menu-item>

          <a-menu-item key="/applyJoinClub">
            <template #icon>
              <solution-outlined />
            </template>
            <router-link to="/applyJoinClub">入团申请</router-link>
          </a-menu-item>

          <a-menu-item key="/user" v-if="userStore.userInfo.role === 'admin'">
            <template #icon>
              <user-outlined />
            </template>
            <router-link to="/user">用户管理</router-link>
          </a-menu-item>

          <a-sub-menu
            key="/approve"
            v-if="userStore.userInfo.role === 'admin' || userStore.userInfo.role === 'teacher'"
          >
            <template #icon>
              <reconciliation-outlined />
            </template>
            <template #title>审批</template>

            <a-menu-item key="/approve/waitApprove">
              <router-link to="/approve/waitApprove">待审批</router-link>
            </a-menu-item>

            <a-menu-item key="/approve/approved">
              <router-link to="/approve/approved">已审批</router-link>
            </a-menu-item>

            <a-menu-item key="/approve/setting">
              <router-link to="/approve/setting">审批设置</router-link>
            </a-menu-item>
          </a-sub-menu>

          <a-menu-item key="/finance" v-if="state.financeAuth">
            <template #icon>
              <dollar-outlined />
            </template>
            <router-link to="/finance">财务管理</router-link>
          </a-menu-item>

          <a-menu-item key="/profile">
            <template #icon>
              <user-outlined />
            </template>
            <router-link to="/profile">个人中心</router-link>
          </a-menu-item>

          <!--<a-sub-menu key="9" v-if="userStore.userInfo.role === 'admin'">-->
          <!--  <template #icon>-->
          <!--    <user-outlined />-->
          <!--  </template>-->
          <!--  <template #title>系统设置</template>-->

          <!--  <a-menu-item key="6.1">-->
          <!--    <router-link to="/user">管理</router-link>-->
          <!--  </a-menu-item>-->
          <!--</a-sub-menu>-->
        </a-menu>
      </a-layout-sider>

      <a-layout :class="layoutClass">
        <!-- header -->
        <a-affix>
          <a-layout-header style="background: #fff; padding: 0">
            <navbar>
              <!-- left插槽 -->
              <template #left></template>

              <!-- 默认插槽和center插槽，默认插槽可不加template直接写内容，作用同center插槽 -->
              <template #center></template>

              <!-- right插槽 -->
              <template #right>
                <top-bar />
              </template>
            </navbar>
          </a-layout-header>
        </a-affix>

        <!-- 主体内容 -->
        <a-layout-content>
          <!-- 面板屑 -->
          <a-card size="small">
            <bread-crumb />
          </a-card>

          <!-- 内容 -->
          <div class="p-6">
            <a-layout-content>
              <router-view />
            </a-layout-content>
          </div>
        </a-layout-content>

        <a-layout-footer style="text-align: center">
          Ant Design ©2018 Created by Ant UED
        </a-layout-footer>
      </a-layout>
    </a-layout>
  </div>
</template>

<script setup>
import {
  DashboardOutlined,
  UserOutlined,
  NotificationOutlined,
  DollarOutlined,
  TeamOutlined,
  SolutionOutlined,
  ContactsOutlined,
  ContainerOutlined,
  ReconciliationOutlined
} from "@ant-design/icons-vue"
import { computed, onMounted, reactive, ref } from "vue"
import TopBar from "./components/TopBar.vue"
import BreadCrumb from "./components/BreadCrumb.vue"
import Navbar from "./components/Navbar.vue"
import Logo from "./components/Logo.vue"
import { useSettingsStore } from "@/store/modules/settings.js"
import { useUserStore } from "@/store/modules/userInfo.js"
import clubRecruitmentApi from "@/api/club/clubRecruitmentApi.js"
import { message } from "ant-design-vue"
import clubFinanceApi from "@/api/club/clubFinanceApi.js"

onMounted(() => {
  checkFinanceAuth()
})

const userStore = useUserStore()
const settingsStore = useSettingsStore()

const layoutClass = computed(() => {
  if (settingsStore.collapsed) {
    return "collapsed-layout"
  }
  return "layout"
})

const state = reactive({
  financeAuth: false
})

const checkFinanceAuth = () => {
  clubFinanceApi
    .checkFinanceAuth()
    .then(({ data }) => {
      if (data.code === 200) {
        state.financeAuth = data.data
      } else {
        message.error(data.message)
      }
    })
    .catch((err) => {
      message.error(err.message)
    })
}
</script>

<style scoped>
.collapsed-layout {
  margin-left: 80px;
  transform: translateX(0px);
}

.layout {
  margin-left: 200px;
}
</style>
