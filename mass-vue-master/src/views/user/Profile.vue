<template>
  <div class="flex" style="margin-top: 16px">
    <a-card style="flex-basis: 25%; margin-left: 16px" hoverable>
      <template #title>
        <span>个人信息</span>
      </template>

      <a-avatar
        style="margin: auto; display: block"
        :size="128"
        :src="userStore.getUserInfo.avatar"
      >
        <template #icon>
          <UserOutlined />
        </template>
      </a-avatar>

      <a-list item-layout="horizontal" :data-source="userInfoState.dataList">
        <template #renderItem="{ item }">
          <a-list-item>
            <a-list-item-meta>
              <template #title>
                <AntIcon :icon="item.icon" />
                <span>{{ item.label }}</span>
              </template>
            </a-list-item-meta>
            <template #actions>
              <span>{{ item.value }}</span>
            </template>
          </a-list-item>
        </template>
      </a-list>
    </a-card>

    <a-card style="flex-basis: 75%; margin-left: 16px; margin-right: 16px" title="基本资料">
      <a-tabs v-model:activeKey="baseInfoState.activeTabKey" @change="changeTab">
        <a-tab-pane key="1" tab="基本资料">
          <a-form
            ref="userInfoFormRef"
            layout="horizontal"
            :model="userInfoFormState.formData"
            autocomplete="off"
            :label-col="{ span: 2 }"
            :wrapper-col="{ span: 6 }"
          >
            <a-form-item
              label="头像"
              name="avatar"
              :rules="[{ required: true, message: '请上传头像!' }]"
            >
              <a-upload
                v-model:file-list="userInfoFormState.fileList"
                name="file"
                class="avatar-uploader"
                :show-upload-list="false"
                :action="userInfoFormState.action"
                :headers="userInfoFormState.headers"
                :before-upload="beforeUpload"
                @change="handleChange"
              >
                <a-avatar
                  v-if="userInfoFormState.formData.avatar"
                  :size="64"
                  :src="userInfoFormState.formData.avatar"
                >
                  <template #icon>
                    <UserOutlined />
                  </template>
                </a-avatar>

                <div v-else>
                  <loading-outlined v-if="userInfoFormState.uploadLoading"></loading-outlined>
                  <a-avatar v-else :size="64">
                    <template #icon>
                      <UserOutlined />
                    </template>
                  </a-avatar>
                </div>
              </a-upload>
            </a-form-item>

            <a-form-item
              label="用户名"
              name="username"
              :rules="[{ required: true, message: '请输入用户名!' }]"
            >
              <a-input v-model:value="userInfoFormState.formData.username" />
            </a-form-item>

            <a-form-item
              label="昵称"
              name="nickname"
              :rules="[{ required: true, message: '请输入昵称!' }]"
            >
              <a-input v-model:value="userInfoFormState.formData.nickname" />
            </a-form-item>

            <a-form-item
              label="性别"
              name="sex"
              :rules="[{ required: true, message: '请选择性别!' }]"
            >
              <a-radio-group v-model:value="userInfoFormState.formData.sex">
                <a-radio :value="0">女</a-radio>
                <a-radio :value="1">男</a-radio>
              </a-radio-group>
            </a-form-item>

            <a-form-item
              label="手机号"
              name="phone"
              :rules="[{ required: true, message: '请输入手机号!' }]"
            >
              <a-input v-model:value="userInfoFormState.formData.phone" />
            </a-form-item>

            <a-form-item :wrapper-col="{ offset: 2, span: 6 }">
              <a-button
                type="primary"
                @click.prevent="updateUserInfo"
                :loading="userInfoFormState.confirmLoading"
              >
                保存
              </a-button>
            </a-form-item>
          </a-form>
        </a-tab-pane>
        <a-tab-pane key="2" tab="修改密码">
          <a-form
            ref="updatePasswordFormRef"
            layout="horizontal"
            :rules="updatePasswordRules"
            :model="updatePasswordFormRefState.dataFormData"
            autocomplete="off"
            :label-col="{ span: 2 }"
            :wrapper-col="{ span: 6 }"
          >
            <a-form-item label="旧密码" name="oldPassword">
              <a-input-password
                v-model:value="updatePasswordFormRefState.dataFormData.oldPassword"
              />
            </a-form-item>

            <a-form-item label="新密码" name="newPassword">
              <a-input-password
                v-model:value="updatePasswordFormRefState.dataFormData.newPassword"
              />
            </a-form-item>

            <a-form-item :wrapper-col="{ offset: 2, span: 6 }">
              <a-button
                type="primary"
                @click.prevent="updatePassword"
                :loading="updatePasswordFormRefState.confirmLoading"
              >
                确认
              </a-button>
            </a-form-item>
          </a-form>
        </a-tab-pane>
      </a-tabs>
    </a-card>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from "vue"
import { useRouter } from "vue-router"
import { message, Modal } from "ant-design-vue"
import { isPassWord } from "@/utils/validate.js"
import userApi from "@/api/user/userApi.js"
import { AntIcon } from "@/utils/AntIcon.js"
import authApi from "@/api/auth/authApi.js"
import { lStorage } from "@/utils/cache/index.js"
import { useUserStore } from "@/store/modules/userInfo.js"
import { useSettingsStore } from "@/store/modules/settings.js"
import { LoadingOutlined, UserOutlined } from "@ant-design/icons-vue"
import { defaultConfig } from "@/config/config.js"

const validateNewPass = async (_rule, value) => {
  if (value === "") {
    return Promise.reject("请输入密码")
  }
  if (!isPassWord(value)) {
    return Promise.reject("以字母或数字开头，长度在6~18之间")
  }
  return Promise.resolve()
}

const updatePasswordRules = reactive({
  oldPassword: [
    {
      required: true,
      validator: validateNewPass,
      trigger: "change"
    }
  ],
  newPassword: [
    {
      required: true,
      validator: validateNewPass,
      trigger: "change"
    }
  ]
})

const userStore = useUserStore()
const settingsStore = useSettingsStore()
const router = useRouter()

const userInfoState = reactive({
  dataList: [
    {
      icon: "UserOutlined",
      label: "用户名称",
      value: computed(() => userStore.getUserInfo.username)
    },
    {
      icon: "WomanOutlined",
      label: "性别",
      value: computed(() => (userStore.getUserInfo.sex === 1 ? "男" : "女"))
    },
    {
      icon: "MobileOutlined",
      label: "手机号码",
      value: computed(() => userStore.getUserInfo.phone)
    }
    // {
    //   icon: "ScheduleOutlined",
    //   label: "创建日期",
    //   value: "2023-04-23 16:11:38"
    // }
  ]
})

const baseInfoState = reactive({
  activeTabKey: "1"
})

// 修改个人信息
const userInfoFormRef = ref()
const userInfoFormState = reactive({
  confirmLoading: false,
  fileList: [],
  action: `${defaultConfig.BASE_URL}/upload/uploadImg`,
  headers: {
    Authorization: `Bearer ${userStore.getToken}`
  },
  uploadLoading: false,
  formData: {
    id: userStore.getUserInfo.id,
    // 头像
    avatar: userStore.getUserInfo.avatar,
    // 用户名
    username: userStore.getUserInfo.username,
    // 昵称
    nickname: userStore.getUserInfo.nickname,
    // 性别 0女 1男
    sex: userStore.getUserInfo.sex,
    // 手机号
    phone: userStore.getUserInfo.phone
  }
})
// 初始化个人信息
const initUserInfoForm = () => {
  userInfoFormState.formData.id = userStore.getUserInfo.id
  userInfoFormState.formData.avatar = userStore.getUserInfo.avatar
  userInfoFormState.formData.username = userStore.getUserInfo.username
  userInfoFormState.formData.nickname = userStore.getUserInfo.nickname
  userInfoFormState.formData.sex = userStore.getUserInfo.sex
  userInfoFormState.formData.phone = userStore.getUserInfo.phone
}

// 上传前校验
const beforeUpload = (file) => {
  const isJpgOrPng = file.type === "image/jpeg" || file.type === "image/png"
  if (!isJpgOrPng) {
    message.error("只支持jpeg或者png格式")
  }
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isLt2M) {
    message.error("图片大小不能超过2MB!")
  }
  return isJpgOrPng && isLt2M
}

// 图片变化
const handleChange = (info) => {
  console.log("info", info)
  if (info.file.status === "uploading") {
    userInfoFormState.uploadLoading = true
    return
  }
  if (info.file.status === "done") {
    const { response } = info.file
    if (response.code === 200) {
      userInfoFormState.formData.avatar = response.data.fileAccessUrl
    } else {
      message.error("上传失败")
    }
    userInfoFormState.uploadLoading = false
  }
  if (info.file.status === "error") {
    userInfoFormState.uploadLoading = false
    message.error("上传失败")
  }
}

// 更新信息
const updateUserInfo = () => {
  userInfoFormRef.value
    .validate()
    .then(() => {
      userInfoFormState.confirmLoading = true
      const params = {
        ...userInfoFormState.formData
      }
      userApi
        .updateSelfInfo(params)
        .then(({ data }) => {
          if (data.code === 200) {
            userInfoFormState.confirmLoading = false
            userStore.setUserInfo(data.data)
            initUserInfoForm()
            message.success("更新成功")
          } else {
            // 返回失败信息
            userInfoFormState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch((err) => {
          userInfoFormState.confirmLoading = false
          console.log(err)
        })
    })
    .catch((err) => {
      userInfoFormState.confirmLoading = false
      console.log(err)
    })
}

// 修改密码
const updatePasswordFormRef = ref()
const updatePasswordFormRefState = reactive({
  confirmLoading: false,
  dataFormData: {
    userId: userStore.getUserInfo.id,
    // 旧密码
    oldPassword: "",
    // 新密码
    newPassword: ""
  }
})
// 初始化修改密码表单
const initUpdatePasswordForm = () => {
  updatePasswordFormRefState.dataFormData.userId = userStore.getUserInfo.id
  updatePasswordFormRefState.dataFormData.oldPassword = ""
  updatePasswordFormRefState.dataFormData.newPassword = ""
}

// 去修改密码
const toUpdatePassword = () => {
  updatePasswordFormRef.value?.clearValidate()
  initUpdatePasswordForm()
}

// 修改密码
const updatePassword = () => {
  updatePasswordFormRef.value
    .validate()
    .then(() => {
      Modal.confirm({
        title: "提示",
        content: "确认要更新密码吗？",
        onOk() {
          updatePasswordFormRefState.confirmLoading = true

          const params = {
            ...updatePasswordFormRefState.dataFormData
          }

          userApi
            .updatePassword(params)
            .then(({ data }) => {
              if (data.code === 200) {
                updatePasswordFormRefState.confirmLoading = false
                logout()
                message.success("请重新登陆!")
              } else {
                // 返回失败信息
                updatePasswordFormRefState.confirmLoading = false
                message.error(data.message)
              }
            })
            .catch((err) => {
              updatePasswordFormRefState.confirmLoading = false
              console.log(err)
            })
        },
        onCancel() {}
      })
    })
    .catch((err) => {
      updatePasswordFormRefState.confirmLoading = false
      console.log(err)
    })
}

const changeTab = (activeKey) => {
  switch (activeKey) {
    case "1":
      initUserInfoForm()
      break
    case "2":
      toUpdatePassword()
      break
    default:
  }
}

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
</script>

<style scoped></style>
