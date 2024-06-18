<template>
  <a-card title="新增用户">
    <a-form
      ref="userFormRef"
      autocomplete="off"
      layout="horizontal"
      :model="userState.formData"
      :label-col="{ span: 7 }"
      :wrapper-col="{ span: 6 }"
    >
      <a-form-item
        label="用户名"
        name="username"
        :rules="[{ required: true, message: '请输入用户名!' }]"
      >
        <a-input v-model:value="userState.formData.username" />
      </a-form-item>

      <a-form-item
        label="密码"
        name="password"
        :rules="[{ required: true, validator: validateNewPass, trigger: 'change' }]"
      >
        <a-input-password v-model:value="userState.formData.password" />
      </a-form-item>

      <a-form-item label="性别" name="gender" :rules="[{ required: true, message: '请选择性别!' }]">
        <a-radio-group v-model:value="userState.formData.gender">
          <a-radio :value="1">男</a-radio>
          <a-radio :value="2">女</a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item
        label="手机号"
        name="phone"
        :rules="[{ required: true, message: '请输入手机号!' }]"
      >
        <a-input v-model:value="userState.formData.phone" />
      </a-form-item>

      <a-form-item :wrapper-col="{ offset: 7, span: 6 }">
        <a-button type="primary" @click="addUser" :loading="userState.confirmLoading"
          >提交
        </a-button>
        <a-button style="margin-left: 10px" @click="initUserForm">重置</a-button>
      </a-form-item>
    </a-form>
  </a-card>
</template>

<script setup>
// 添加模板state
import { reactive, ref } from "vue"
import { message } from "ant-design-vue"
import userApi from "@/api/user/userApi.js"
import { isPassWord } from "@/utils/validate.js"

const validateNewPass = async (_rule, value) => {
  if (value === "") {
    return Promise.reject("请输入新密码")
  }
  if (!isPassWord(value)) {
    return Promise.reject("以字母或数字开头，长度在6~18之间")
  }
  return Promise.resolve()
}

const userFormRef = ref()
const userState = reactive({
  visible: false,
  confirmLoading: false,
  title: "新增用户",
  formData: {
    id: "",
    // 用户名
    username: "",
    // 密码
    password: "",
    // 性别 1男 2女
    gender: 1,
    // 手机号
    phone: ""
  },
  messageAccountList: []
})

// 初始化表单
const initUserForm = () => {
  userState.formData.id = ""
  userState.formData.username = ""
  userState.formData.password = ""
  userState.formData.gender = 1
  userState.formData.phone = ""

  userFormRef.value?.clearValidate()
}

// 新增用户
const addUser = () => {
  userFormRef.value
    .validate()
    .then(() => {
      userState.confirmLoading = true
      const params = {
        ...userState.formData
      }
      userApi
        .saveOrUpdateUser(params)
        .then(({ data }) => {
          if (data.code === 200) {
            userState.confirmLoading = false
            initUserForm()
            message.success("添加成功")
          } else {
            userState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch((err) => {
          userState.confirmLoading = false
          message.error(err.message)
        })
    })
    .catch((err) => {
      console.log(err)
      message.error("请检查表单项是否填写完整")
    })
}
</script>

<style scoped></style>
