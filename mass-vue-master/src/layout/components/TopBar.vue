<template>
  <!-- 提醒 -->

  <!--用户选项-->
  <a-dropdown placement="bottomLeft">
    <a-button type="text" size="small">
      <a-space align="center">
        <a-avatar size="small" :src="userStore.getUserInfo?.avatar">
          <template #icon>
            <user-outlined />
          </template>
        </a-avatar>

        <span class="font-mono">
          {{ userStore.getUserInfo.nickname }}
        </span>
      </a-space>
    </a-button>

    <template #overlay>
      <a-menu>
        <a-menu-item key="0" @click="toUserInfo()">
          <template #icon>
            <user-outlined />
          </template>
          <a>个人中心</a>
        </a-menu-item>

        <a-menu-item key="1" @click="logout">
          <template #icon>
            <logout-outlined />
          </template>
          <span>退出登录</span>
        </a-menu-item>
      </a-menu>
    </template>
  </a-dropdown>
</template>

<script setup>
import { LogoutOutlined, UserOutlined } from "@ant-design/icons-vue"
import { useRouter } from "vue-router"
import { message } from "ant-design-vue"
import { useUserStore } from "@/store/modules/userInfo.js"
import { useSettingsStore } from "@/store/modules/settings.js"
import authApi from "@/api/auth/authApi.js"
import { lStorage } from "@/utils/cache/index.js"

const userStore = useUserStore()
const settingsStore = useSettingsStore()
const router = useRouter()

// 退出登录
const logout = () => {
  // 退出登录
  authApi
    .logout()
    .then((res) => {
      const { data } = res
      if (res.status === 200) {
        // 清除缓存
        lStorage.remove("token")
        // 清除用户信息、设置
        userStore.$reset()
        settingsStore.$reset()

        // 跳转到登录页面
        router.push({ path: "/login" })
        // 提示信息
        message.success("退出成功")
      } else {
        message.error(data.message)
      }
    })
    .catch((err) => {
      message.error(err.message)
    })
}

const toUserInfo = () => {
  router.push({ path: "/profile" })
  // settingsStore.openKeys = ["/", "/user"]
  settingsStore.selectedKeys = ["/profile"]
}
</script>

<style scoped></style>
