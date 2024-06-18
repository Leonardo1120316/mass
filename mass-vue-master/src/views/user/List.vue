<template>
  <!--查询表单-->
  <a-card>
    <a-form
      ref="searchFormRef"
      layout="inline"
      :model="searchFormState.searchForm"
      @finish="searchData"
    >
      <a-form-item label="用户名" name="username">
        <a-input v-model:value="searchFormState.searchForm.username" placeholder="请输入用户名" />
      </a-form-item>

      <a-form-item>
        <a-button type="primary" html-type="submit">搜索</a-button>
        <a-button @click="initSearchForm" class="ml-4">重置</a-button>
      </a-form-item>
    </a-form>
  </a-card>

  <div class="mt-4">
    <a-card title="用户列表">
      <div style="display: flex">
        <a-button type="primary" @click="toAdd()">新增用户</a-button>
      </div>

      <!--表格-->
      <div style="margin-top: 30px">
        <a-table
          rowKey="id"
          :columns="tableState.columns"
          :data-source="tableState.dataList"
          :loading="tableState.loading"
          :pagination="paginationState"
        >
          <template #bodyCell="{ column, record }">
            <!--图标-->
            <template v-if="column.key === 'icon'">
              <AntIcon :icon="record.icon" />
            </template>

            <!-- 性别 -->
            <template v-if="column.key === 'sex'">
              {{ filters.getSex(record.sex).label }}
            </template>

            <!--状态-->
            <template v-if="column.key === 'status'">
              <a-tag :color="filters.getUserStatus(record.status).color"
                >{{ filters.getUserStatus(record.status).label }}
              </a-tag>
            </template>

            <!-- 角色 -->
            <template v-if="column.key === 'role'">
              {{ filters.getRole(record.role).label }}
            </template>

            <!--操作-->
            <template v-if="column.key === 'action'">
              <span>
                <a @click="toUpdate(record)">修改</a>
                <a-divider type="vertical" />
                <a-popconfirm
                  title="确认删除？"
                  ok-text="删除"
                  cancel-text="取消"
                  @confirm="delBatch([record.id])"
                >
                  <a>删除</a>
                </a-popconfirm>
              </span>
            </template>
          </template>
        </a-table>
      </div>
    </a-card>
  </div>

  <!-- 新增或更新 -->
  <a-modal
    :title="saveOrUpdateState.title"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="saveOrUpdateState.visible"
    :confirm-loading="saveOrUpdateState.confirmLoading"
    @ok="saveOrUpdate"
    @cancel="initSaveOrUpdateForm"
  >
    <a-form
      ref="saveOrUpdateFormRef"
      :model="saveOrUpdateState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item
        label="用户名"
        name="username"
        :rules="[{ required: true, message: '请输入用户名!' }]"
      >
        <a-input v-model:value="saveOrUpdateState.formData.username" />
      </a-form-item>

      <a-form-item
        label="昵称"
        name="nickname"
        :rules="[{ required: true, message: '请输入昵称!' }]"
      >
        <a-input v-model:value="saveOrUpdateState.formData.nickname" />
      </a-form-item>

      <a-form-item label="性别" name="sex">
        <a-radio-group
          v-model:value="saveOrUpdateState.formData.sex"
          :key="sex.value"
          v-for="sex in enumsConfig.sex"
        >
          <a-radio :value="sex.value">{{ sex.label }}</a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item
        label="手机号"
        name="phone"
        :rules="[{ required: true, message: '请输入手机号!' }]"
      >
        <a-input v-model:value="saveOrUpdateState.formData.phone" />
      </a-form-item>

      <a-form-item label="邮箱" name="email">
        <a-input v-model:value="saveOrUpdateState.formData.email" />
      </a-form-item>

      <a-form-item
        v-if="saveOrUpdateState.showPassword"
        label="密码"
        name="password"
        :rules="[{ required: saveOrUpdateState.showPassword, message: '请输入密码!' }]"
      >
        <a-input-password v-model:value="saveOrUpdateState.formData.password" />
      </a-form-item>

      <a-form-item label="角色" name="role" :rules="[{ required: true, message: '请选择角色!' }]">
        <a-radio-group
          v-model:value="saveOrUpdateState.formData.role"
          :key="role.value"
          v-for="role in enumsConfig.role"
        >
          <a-radio :value="role.value">{{ role.label }}</a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item label="状态" name="status">
        <a-switch
          v-model:checked="saveOrUpdateState.formData.status"
          :checked-value="0"
          :un-checked-value="-1"
          checked-children="启用"
          un-checked-children="禁用"
        />
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue"
import { message } from "ant-design-vue"
import { AntIcon } from "@/utils/AntIcon.js"
import userApi from "@/api/user/userApi.js"
import { filters } from "@/config/filters.js"
import enumsConfig from "@/config/enumsConfig.js"

onMounted(() => {
  searchData()
})

// 查询表单state
const searchFormRef = ref()
const searchFormState = reactive({
  searchForm: {
    username: ""
  }
})
// 重置查询表单
const initSearchForm = () => {
  searchFormState.searchForm.username = ""
  searchData()
}

// table state
const tableState = reactive({
  defaultIcon: "SearchOutlined",
  columns: [
    {
      title: "用户名",
      dataIndex: "username",
      key: "username"
    },
    {
      title: "昵称",
      dataIndex: "nickname",
      key: "nickname"
    },
    {
      title: "性别",
      dataIndex: "sex",
      key: "sex"
    },
    {
      title: "手机号",
      dataIndex: "phone",
      key: "phone",
      width: 200
    },
    {
      title: "邮箱",
      dataIndex: "email",
      key: "email",
      width: 200
    },
    {
      title: "状态",
      dataIndex: "status",
      key: "status"
    },
    {
      title: "角色",
      dataIndex: "role",
      key: "role",
      width: 200
    },
    {
      title: "创建时间",
      dataIndex: "createTime",
      key: "createTime"
    },
    {
      title: "操作",
      key: "action"
    }
  ],
  loading: false,
  dataList: []
})

// 新增或更新state
const saveOrUpdateFormRef = ref()
const saveOrUpdateState = reactive({
  title: "新增用户",
  visible: false,
  confirmLoading: false,
  formData: {
    id: "",
    // 用户名
    username: "",
    // 昵称
    nickname: "",
    // 性别
    sex: 0,
    // 手机号码
    phone: "",
    // 邮箱
    email: "",
    // 密码
    password: "",
    // 角色
    role: "student",
    // 状态
    status: 0
  }
})
const initSaveOrUpdateForm = () => {
  saveOrUpdateState.formData.id = ""
  saveOrUpdateState.formData.username = ""
  saveOrUpdateState.formData.nickname = ""
  saveOrUpdateState.formData.password = ""
  saveOrUpdateState.formData.role = "student"
  saveOrUpdateState.formData.sex = 0
  saveOrUpdateState.formData.email = ""
  saveOrUpdateState.formData.phone = ""
  saveOrUpdateState.formData.status = 0
}

// 去添加
const toAdd = () => {
  initSaveOrUpdateForm()
  saveOrUpdateState.showPassword = true
  saveOrUpdateState.title = "新增用户"
  saveOrUpdateState.visible = true
}

// 去更新
const toUpdate = (record) => {
  saveOrUpdateState.formData = { ...record }
  saveOrUpdateState.showPassword = false
  saveOrUpdateState.title = "修改用户"
  saveOrUpdateState.visible = true
}

// 查询数据
const searchData = () => {
  tableState.loading = true
  const params = {
    pageNum: paginationState.current,
    pageSize: paginationState.pageSize,
    ...searchFormState.searchForm
  }
  userApi
    .listUserPage(params)
    .then(({ data }) => {
      if (data.code === 200) {
        tableState.dataList = data.data.records
        tableState.loading = false
      } else {
        tableState.loading = false
        message.error(data.message)
      }
    })
    .catch((err) => {
      tableState.loading = false
      message.error(err.message)
    })
}

// 新增或修改
const saveOrUpdate = () => {
  saveOrUpdateFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...saveOrUpdateState.formData
      }
      userApi
        .saveOrUpdateUser(params)
        .then(({ data }) => {
          if (data.code === 200) {
            saveOrUpdateState.confirmLoading = false
            saveOrUpdateState.visible = false
            searchData()
            message.success(data.message)
          } else {
            saveOrUpdateState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch(() => {
          saveOrUpdateState.confirmLoading = false
          message.error("请检查表单项")
        })
    })
    .catch(() => {
      saveOrUpdateState.confirmLoading = false
      message.error("请检查表单项")
    })
}

// 批量删除用户
const delBatch = (idList) => {
  const params = []
  idList.forEach((item) => {
    params.push(item)
  })

  userApi
    .deleteBatch(params)
    .then(({ data }) => {
      if (data.code === 200) {
        searchData()
        message.success(data.message)
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("删除失败")
    })
}

// 分页配置
const paginationState = reactive({
  // 当前页数
  current: 1,
  // 每页条数
  pageSize: 10,
  // 指定每页可以显示多少条
  pageSizeOptions: ["10", "20", "30", "40"],
  // 数据总数
  total: 0,
  // 是否显示较少页面内容
  // showLessItems: true,
  // 是否可以快速跳转至某页
  showQuickJumper: true,
  // 是否展示 pageSize 切换器，当 total 大于 50 时默认为 true
  showSizeChanger: true,
  // 显示数据总量和当前数据顺序
  showTotal: (total) => `共 ${total} 项`,
  // 页码或 pageSize 改变的回调，参数是改变后的页码及每页条数
  onChange: (page, pageSize) => {
    paginationState.current = page
    paginationState.pageSize = pageSize
    searchData()
  }
})
</script>

<style scoped></style>
