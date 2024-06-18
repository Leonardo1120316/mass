<template>
  <div class="loginClass">
    <a-card>
      <a-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        @finish="login"
        @finishFailed="validateFailed"
      >
        <!--用户名-->
        <a-form-item class="text-center" style="text-align: center">
          <h1>{{ defaultConfig.projectName }}</h1>
        </a-form-item>

        <!--用户名-->
        <a-form-item name="username">
          <a-input
            v-model:value="loginForm.username"
            placeholder="用户名"
            allow-clear
            @pressEnter="this.$refs.passwordRef.focus()"
          >
            <!--图标-->
            <template #prefix>
              <user-outlined style="color: rgba(0, 0, 0, 0.25)" />
            </template>
          </a-input>
        </a-form-item>

        <!--密码-->
        <a-form-item name="password">
          <a-input-password
            ref="passwordRef"
            v-model:value="loginForm.password"
            placeholder="密码"
            allow-clear
          >
            <!--图标-->
            <template #prefix>
              <lock-outlined style="color: rgba(0, 0, 0, 0.25)" />
            </template>
          </a-input-password>
        </a-form-item>
        <a-form-item class="mt-4">
          <a-button type="primary" html-type="submit" block :loading="loading"> 登录</a-button>
        </a-form-item>
      </a-form>
    </a-card>
  </div>
</template>

<script setup>
import { LockOutlined, UserOutlined } from "@ant-design/icons-vue"
import { message } from "ant-design-vue"
import { onMounted, reactive, ref } from "vue"
import { useRouter } from "vue-router"
import authApi from "@/api/auth/authApi.js"
import { isPassWord } from "@/utils/validate.js"
import { useUserStore } from "@/store/modules/userInfo.js"
import codeApi from "@/api/code/codeApi.js"
import { defaultConfig } from "@/config/config.js"
import { useSettingsStore } from "@/store/modules/settings.js"
import CryptoJSUtil from "@/utils/CryptoJSUtil.js"

// 数据格式校验
const validateUserName = (_rule, value) => {
  if (!value) {
    return Promise.reject("用户名不能为空")
  }
  if (value.trim().length === 0) {
    return Promise.reject("用户名不能为空")
  }
  return Promise.resolve()
}

const validatePassword = (_rule, value) => {
  if (value.trim().length === 0) {
    return Promise.reject("密码不能为空")
  }
  if (!isPassWord(value)) {
    return Promise.reject("请正确输入密码")
  }
  return Promise.resolve()
}

const router = useRouter()
const userStore = useUserStore()
const settingsStore = useSettingsStore()

// 登录时加载动画
const loading = ref(false)

// 表单数据
const loginForm = reactive({
  username: "",
  password: "",
  timestamp: null,
  remember: false
})
// 表单校验规则
const loginRules = {
  username: [{ required: true, trigger: "change", validator: validateUserName }],
  password: [{ required: true, trigger: "change", validator: validatePassword }]
}

// 验证失败
const validateFailed = () => {
  message.error("请完整填写表单!", 2)
}

// 登录
const login = () => {
  loading.value = true

  // 请求体
  const params = {
    username: loginForm.username,
    // password: CryptoJSUtil.Encrypt(loginForm.password),
    password: loginForm.password,
    timestamp: loginForm.timestamp
  }

  // 发送请求
  authApi
    .login(params)
    .then((res) => {
      const { data } = res
      if (data.code === 200) {
        // 保存token、用户信息
        const token = res.headers.authorization
        const info = data.data
        userStore.setToken(token, info.expireTime)
        userStore.setUserInfo(info)
        loading.value = false

        settingsStore.changeSelectedKeys("/")
        router.push({ path: "/" })

        message.success("登录成功")
      } else {
        // 返回失败信息
        loading.value = false
        message.error(data.message)
      }
    })
    .catch((err) => {
      loading.value = false
      message.error(err.message)
    })
}
</script>

<style scoped>
.loginClass {
  width: 100%;
  height: 100%;
  display: grid;
  justify-items: center;
  align-items: center;
  min-height: 100vh;
}
</style>
