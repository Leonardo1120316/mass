<template>
  <!--查询表单-->
  <a-card>
    <a-form
      ref="searchFormRef"
      layout="inline"
      :model="searchFormState.searchForm"
      @finish="searchData"
    >
      <a-form-item label="社团名称" name="clubName">
        <a-input v-model:value="searchFormState.searchForm.clubName" placeholder="请输入社团名称" />
      </a-form-item>

      <a-form-item>
        <a-button type="primary" html-type="submit">搜索</a-button>
        <a-button @click="initSearchForm" class="ml-4">重置</a-button>
      </a-form-item>
    </a-form>
  </a-card>

  <div class="mt-4">
    <a-card title="社团列表">
      <div style="display: flex">
        <a-button type="primary" @click="toAdd()">申请社团</a-button>
        <a-button
          style="margin-left: 10px"
          type="primary"
          @click="exportClub()"
          :disabled="tableState.selectedIds.length === 0"
        >
          导出社团信息
        </a-button>
      </div>

      <!--表格-->
      <div style="margin-top: 30px">
        <a-table
          rowKey="id"
          :columns="tableState.columns"
          :data-source="tableState.dataList"
          :loading="tableState.loading"
          :row-selection="selectSetting"
          :custom-row="customRow"
          :pagination="paginationState"
        >
          <template #bodyCell="{ column, record }">
            <!--状态-->
            <template v-if="column.key === 'status'">
              <a-tag :color="filters.getClubStatus(record.status).color">
                {{ filters.getClubStatus(record.status).label }}
              </a-tag>
            </template>

            <!--操作-->
            <template v-if="column.key === 'action'">
              <span>
                <a @click="toUpdate(record)">修改</a>
              </span>

              <span v-if="userStore.userInfo.role === 'student'">
                <a-divider type="vertical" />
                <a @click="toQuit(record)">退团</a>
                <a-divider type="vertical" />
                <a-popconfirm
                  title="确认申请解散该社团？"
                  ok-text="确认"
                  cancel-text="取消"
                  @confirm="applyDissolveClub(record.id)"
                >
                  <a style="color: red">解散</a>
                </a-popconfirm>
              </span>
            </template>
          </template>
        </a-table>
      </div>
    </a-card>
  </div>

  <div class="mt-4">
    <a-card title="社团成员">
      <div class="mt-4">
        <a-table
          rowKey="id"
          :columns="memberTableState.columns"
          :data-source="memberTableState.dataList"
          :loading="memberTableState.loading"
          :pagination="memberPaginationState"
        >
          <template #bodyCell="{ column, record }">
            <!--角色-->
            <template v-if="column.key === 'role'">
              <a-tag>
                {{ filters.getClubUserRole(record.role).label }}
              </a-tag>
            </template>

            <!--操作-->
            <template v-if="column.key === 'action'">
              <span>
                <span v-if="record.role !== 'president'">
                  <a-popconfirm
                    v-if="record.role !== 'president'"
                    title="确认设置该成员为社长？"
                    ok-text="确定"
                    cancel-text="取消"
                    @confirm="changePresident(record)"
                  >
                    <a>设为社长</a>
                  </a-popconfirm>

                  <a-divider type="vertical" />
                  <a @click="toUpdateMemberRole(record)"> 修改角色 </a>
                  <a-divider type="vertical" />

                  <a-popconfirm
                    v-if="record.role !== 'president'"
                    title="确认移除该成员？"
                    ok-text="确定"
                    cancel-text="取消"
                    @confirm="removeMember(record)"
                  >
                    <a>移除</a>
                  </a-popconfirm>
                </span>

                <span v-else> </span>
              </span>
            </template>
          </template>
        </a-table>
      </div>
    </a-card>
  </div>

  <!-- 申请社团 -->
  <a-modal
    :title="applyClubState.title"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="applyClubState.visible"
    :confirm-loading="applyClubState.confirmLoading"
    @ok="applyClub"
    @cancel="initApplyClubForm"
  >
    <a-form
      ref="applyClubFormRef"
      :model="applyClubState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item label="logo" name="logo" :rules="[{ required: true, message: '请选择logo!' }]">
        <a-upload
          v-model:file-list="applyClubState.fileList"
          name="file"
          class="avatar-uploader"
          :show-upload-list="false"
          :action="applyClubState.action"
          :headers="applyClubState.headers"
          :before-upload="beforeUpload"
          @change="handleChange"
        >
          <a-avatar
            v-if="applyClubState.formData.logo"
            :size="64"
            :src="applyClubState.formData.logo"
          >
            <template #icon>
              <UserOutlined />
            </template>
          </a-avatar>

          <div v-else>
            <loading-outlined v-if="applyClubState.uploadLoading"></loading-outlined>
            <a-avatar v-else :size="64">
              <template #icon>
                <UserOutlined />
              </template>
            </a-avatar>
          </div>
        </a-upload>
      </a-form-item>

      <a-form-item
        label="社团类型代码"
        name="typeCode"
        :rules="[{ required: true, message: '请选择社团类型代码!' }]"
      >
        <a-select
          show-search
          v-model:value="applyClubState.formData.typeCode"
          :field-names="{ label: 'name', value: 'code' }"
          :options="state.clubTypeList"
        ></a-select>
      </a-form-item>

      <a-form-item
        label="社团名称"
        name="name"
        :rules="[{ required: true, message: '请输入社团名称!' }]"
      >
        <a-input v-model:value="applyClubState.formData.name" />
      </a-form-item>

      <a-form-item
        label="社长"
        name="leaderId"
        :rules="[{ required: true, message: '请选择社长!' }]"
      >
        <a-select
          show-search
          v-model:value="applyClubState.formData.leaderId"
          :field-names="{ label: 'nickname', value: 'id' }"
          :options="state.studentBaseInfoList"
        ></a-select>
      </a-form-item>

      <a-form-item
        label="社团描述"
        name="description"
        :rules="[{ required: true, message: '请输入社团描述!' }]"
      >
        <a-input v-model:value="applyClubState.formData.description" />
      </a-form-item>
    </a-form>
  </a-modal>

  <!-- 修改社团描述 -->
  <a-modal
    title="修改社团描述"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="updateClubState.visible"
    :confirm-loading="updateClubState.confirmLoading"
    @ok="updateClub"
    @cancel="initUpdateClubForm"
  >
    <a-form
      ref="updateClubFormRef"
      :model="updateClubState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item
        label="社团描述"
        name="description"
        :rules="[{ required: true, message: '请输入社团描述!' }]"
      >
        <a-input v-model:value="updateClubState.formData.description" />
      </a-form-item>
    </a-form>
  </a-modal>

  <!-- 设置成员角色 -->
  <a-modal
    title="修改社团成员角色"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="memberState.visible"
    :confirm-loading="memberState.confirmLoading"
    @ok="updateMemberRole"
    @cancel="initMemberForm"
    :destroy-on-close="true"
  >
    <a-form
      ref="memberFormRef"
      :model="memberState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item
        label="成员角色"
        name="role"
        :rules="[{ required: true, message: '请选择成员角色!' }]"
      >
        <a-select
          show-search
          v-model:value="memberState.formData.role"
          :field-names="{ label: 'label', value: 'value' }"
          :options="memberState.roleList"
        ></a-select>
      </a-form-item>
    </a-form>
  </a-modal>

  <!-- 退团申请 -->
  <a-modal
    title="退团申请"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="quitClubState.visible"
    :confirm-loading="quitClubState.confirmLoading"
    @ok="quitClub"
    @cancel="initQuitClubForm"
    :destroy-on-close="true"
  >
    <a-form
      ref="quitClubFormRef"
      :model="quitClubState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item
        label="原因"
        name="reason"
        :rules="[{ required: true, message: '请输入退团原因!' }]"
      >
        <a-textarea
          v-model:value="quitClubState.formData.reason"
          :rows="4"
          placeholder="最多200个字符"
          show-count
          :maxlength="200"
        />
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup>
import { UserOutlined, LoadingOutlined } from "@ant-design/icons-vue"
import { computed, onMounted, reactive, ref } from "vue"
import { message } from "ant-design-vue"
import { filters } from "@/config/filters.js"
import clubApi from "@/api/club/clubApi.js"
import { useUserStore } from "@/store/modules/userInfo.js"
import { defaultConfig } from "@/config/config.js"
import userApi from "@/api/user/userApi.js"
import clubUserApi from "@/api/club/clubUserApi.js"
import clubTypeApi from "@/api/club/clubTypeApi.js"
import clubQuitApplyApi from "@/api/club/clubQuitApplyApi.js"
import clubFinanceApi from "@/api/club/clubFinanceApi.js"
import { saveAs } from "file-saver"

onMounted(() => {
  searchData()
})

const userStore = useUserStore()

const state = reactive({
  clubTypeList: [],
  studentBaseInfoList: []
})

// 查询表单state
const searchFormRef = ref()
const searchFormState = reactive({
  searchForm: {
    clubName: ""
  }
})
// 重置查询表单
const initSearchForm = () => {
  searchFormState.searchForm.clubName = ""
  cleanMemberData()
  searchData()
}

// table state
const tableState = reactive({
  defaultIcon: "SearchOutlined",
  selectedIds: [],
  columns: [
    {
      title: "社团类型",
      dataIndex: "typeName",
      key: "typeName"
    },
    {
      title: "名称",
      dataIndex: "name",
      key: "name"
    },
    {
      title: "社长",
      dataIndex: "leader",
      key: "leader"
    },
    {
      title: "描述",
      dataIndex: "description",
      key: "description",
      width: 200
    },
    {
      title: "状态",
      dataIndex: "status",
      key: "status"
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

const selectSetting = computed(() => {
  return {
    selectedRowKeys: tableState.selectedIds,
    type: "radio",
    onChange: (selectedRowKeys) => {
      tableState.selectedIds = selectedRowKeys
    }
  }
})
const selectRow = (record) => {
  // 单选不可取消
  tableState.selectedIds = [record.id]

  searchMemberData()
}
const customRow = (record) => {
  return {
    onClick: () => {
      selectRow(record)
    }
  }
}

// 申请社团state
const applyClubFormRef = ref()
const applyClubState = reactive({
  title: "申请社团",
  visible: false,
  confirmLoading: false,
  fileList: [],
  uploadLoading: false,
  action: `${defaultConfig.BASE_URL}/clubAttachment/uploadImg`,
  headers: {
    Authorization: `Bearer ${userStore.getToken}`
  },
  formData: {
    // 社团类型代码
    typeCode: "",
    // 社团名称
    name: "",
    // 社长id
    leaderId: "",
    // logo
    logo: "",
    // 描述
    description: ""
  }
})
const initApplyClubForm = () => {
  applyClubState.formData.typeCode = ""
  applyClubState.formData.name = ""
  applyClubState.formData.leaderId = ""
  applyClubState.formData.logo = ""
  applyClubState.formData.description = ""
}

// 去添加
const toAdd = () => {
  initApplyClubForm()
  listAllClubType()
  listStudentsBaseInfo()

  applyClubState.title = "申请社团"
  applyClubState.visible = true
}

// 申请社团state
const updateClubFormRef = ref()
const updateClubState = reactive({
  visible: false,
  confirmLoading: false,
  formData: {
    id: "",
    description: ""
  }
})
const initUpdateClubForm = () => {
  updateClubState.formData.id = ""
  updateClubState.formData.description = ""
}
// 去更新
const toUpdate = (record) => {
  updateClubState.formData.id = record.id
  updateClubState.formData.description = record.description
  updateClubState.visible = true
}
// 更新社团
const updateClub = () => {
  updateClubFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...updateClubState.formData
      }
      clubApi
        .updateClub(params)
        .then(({ data }) => {
          if (data.code === 200) {
            updateClubState.confirmLoading = false
            updateClubState.visible = false
            searchData()
            message.success(data.message)
          } else {
            updateClubState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch(() => {
          updateClubState.confirmLoading = false
          message.error("请检查表单项")
        })
    })
    .catch(() => {
      updateClubState.confirmLoading = false
      message.error("请检查表单项")
    })
}

// 退团申请state
const quitClubFormRef = ref()
const quitClubState = reactive({
  visible: false,
  confirmLoading: false,
  formData: {
    clubId: "",
    reason: ""
  }
})
const initQuitClubForm = () => {
  quitClubState.formData.clubId = ""
  quitClubState.formData.reason = ""
}
// 去更新
const toQuit = (record) => {
  initQuitClubForm()

  quitClubState.formData.clubId = record.id
  quitClubState.visible = true
}
// 退团
const quitClub = () => {
  quitClubFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...quitClubState.formData
      }
      clubQuitApplyApi
        .saveClubQuitApply(params)
        .then(({ data }) => {
          if (data.code === 200) {
            quitClubState.confirmLoading = false
            quitClubState.visible = false
            message.success(data.message)
          } else {
            quitClubState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch(() => {
          quitClubState.confirmLoading = false
          message.error("请检查表单项")
        })
    })
    .catch(() => {
      quitClubState.confirmLoading = false
      message.error("请检查表单项")
    })
}

const applyDissolveClub = (id) => {
  if (!id) {
    message.warning("请选择要解散的社团")
    return
  }

  const params = {
    clubId: id
  }

  clubApi
    .applyDissolveClub(params)
    .then(({ data }) => {
      if (data.code === 200) {
        cleanMemberData()
        searchData()
      } else {
        message.error(data.message)
      }
    })
    .catch((err) => {
      message.error(err.message)
    })
}

// 查询数据
const searchData = () => {
  tableState.loading = true
  const params = {
    pageNum: paginationState.current,
    pageSize: paginationState.pageSize,
    ...searchFormState.searchForm
  }
  clubApi
    .listClubPage(params)
    .then(({ data }) => {
      if (data.code === 200) {
        cleanMemberData()

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

// 申请社团
const applyClub = () => {
  applyClubFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...applyClubState.formData
      }
      clubApi
        .applyClub(params)
        .then(({ data }) => {
          if (data.code === 200) {
            applyClubState.confirmLoading = false
            applyClubState.visible = false
            searchData()
            message.success(data.message)
          } else {
            applyClubState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch(() => {
          applyClubState.confirmLoading = false
          message.error("请检查表单项")
        })
    })
    .catch(() => {
      applyClubState.confirmLoading = false
      message.error("请检查表单项")
    })
}

// 图片变化
const handleChange = (info) => {
  console.log("info", info)
  if (info.file.status === "uploading") {
    applyClubState.uploadLoading = true
    return
  }
  if (info.file.status === "done") {
    const response = info.file.response
    if (response.code === 200) {
      applyClubState.formData.logo = response.data.fileAccessUrl
    } else {
      message.error("上传失败")
    }
    applyClubState.uploadLoading = false
  }
  if (info.file.status === "error") {
    applyClubState.uploadLoading = false
    message.error("上传失败")
  }
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

// 查询所有社团类型
const listAllClubType = (name) => {
  const params = {
    name
  }
  clubTypeApi
    .listAllClubType(params)
    .then(({ data }) => {
      if (data.code === 200) {
        state.clubTypeList = data.data
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("获取社团类型数据失败")
    })
}

// 查询所有学生基本信息
const listStudentsBaseInfo = () => {
  userApi
    .listStudentsBaseInfo()
    .then(({ data }) => {
      if (data.code === 200) {
        state.studentBaseInfoList = data.data
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

// 查询成员数据
const searchMemberData = () => {
  memberTableState.loading = true
  const params = {
    pageNum: memberPaginationState.current,
    pageSize: memberPaginationState.pageSize,
    clubId: tableState.selectedIds[0]
  }
  clubUserApi
    .listClubUserPage(params)
    .then(({ data }) => {
      if (data.code === 200) {
        memberTableState.dataList = data.data.records
        memberTableState.loading = false
      } else {
        memberTableState.loading = false
        message.error(data.message)
      }
    })
    .catch((err) => {
      memberTableState.loading = false
      message.error(err.message)
    })
}

// 成员table
const memberTableState = reactive({
  defaultIcon: "SearchOutlined",
  columns: [
    {
      title: "用户昵称",
      dataIndex: "nickname",
      key: "nickname"
    },
    {
      title: "角色",
      dataIndex: "role",
      key: "role"
    },
    {
      title: "加入时间",
      dataIndex: "joinTime",
      key: "joinTime"
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

// 清除成员数据
const cleanMemberData = () => {
  tableState.selectedIds = []
  memberTableState.dataList = []
}

// 成员state
const memberFormRef = ref()
const memberState = reactive({
  title: "成员",
  visible: false,
  confirmLoading: false,
  formData: {
    // 成员id
    clubUserId: "",
    // 角色
    role: ""
  },
  roleList: [
    {
      value: "finance",
      label: "财务"
    },
    {
      value: "member",
      label: "社团成员"
    }
  ]
})
const initMemberForm = () => {
  memberState.formData.clubUserId = ""
  memberState.formData.role = ""
}

// 更新成员角色
const toUpdateMemberRole = (record) => {
  initMemberForm()
  memberState.formData.clubUserId = record.id
  memberState.visible = true
}

// 更新成员角色
const updateMemberRole = () => {
  memberFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...memberState.formData
      }
      clubUserApi
        .setClubUserRole(params)
        .then(({ data }) => {
          if (data.code === 200) {
            memberState.confirmLoading = false
            memberState.visible = false
            searchData()
            message.success(data.message)
          } else {
            memberState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch(() => {
          memberState.confirmLoading = false
          message.error("请检查表单项")
        })
    })
    .catch(() => {
      memberState.confirmLoading = false
      message.error("请检查表单项")
    })
}

// 移除成员
const removeMember = (record) => {
  const params = {
    clubId: record.clubId,
    clubUserId: record.userId
  }

  clubApi
    .removeMember(params)
    .then(({ data }) => {
      if (data.code === 200) {
        searchData()
        message.success(data.message)
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("移除失败")
    })
}

// 更换社长
const changePresident = (record) => {
  const params = {
    clubUserId: record.id,
    clubId: record.clubId
  }

  clubApi
    .changePresident(params)
    .then(({ data }) => {
      if (data.code === 200) {
        searchData()
        message.success(data.message)
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("移除失败")
    })
}

const exportClub = () => {
  if (tableState.selectedIds.length === 0) {
    message.warning("先选择社团进行导出")
  }
  const params = {
    clubId: tableState.selectedIds[0]
  }
  clubApi
    .exportClub(params)
    .then((res) => {
      const blob = res.data

      // 判断返回的是json还是文件流
      if (blob.type === "application/json") {
        blob.text().then((text) => {
          // 将字符串转换为 JSON
          const data = JSON.parse(text)
          message.error(data.message)
        })
      } else {
        // file-saver插件
        saveAs(blob, "社团信息.xlsx")
      }
    })
    .catch((err) => {
      console.log(err)
    })
}

// 详情分页配置
const memberPaginationState = reactive({
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
    memberPaginationState.current = page
    memberPaginationState.pageSize = pageSize
    searchMemberData()
  }
})
</script>

<style scoped></style>
