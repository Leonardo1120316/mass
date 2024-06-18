<template>
  <!--查询表单-->
  <a-card>
    <a-form
      ref="searchFormRef"
      layout="inline"
      :model="searchFormState.searchForm"
      @finish="searchData"
    >
      <a-form-item label="活动名称" name="name">
        <a-input v-model:value="searchFormState.searchForm.name" placeholder="请输入活动名称" />
      </a-form-item>

      <a-form-item>
        <a-button type="primary" html-type="submit">搜索</a-button>
        <a-button @click="initSearchForm" class="ml-4">重置</a-button>
      </a-form-item>
    </a-form>
  </a-card>

  <div class="mt-4">
    <a-card title="活动列表">
      <div style="display: flex">
        <a-button
          type="primary"
          @click="toAdd()"
          v-if="userStore.userInfo.role === 'student' && state.isLeader"
        >
          新增活动
        </a-button>

        <a-button
          style="margin-left: 10px"
          type="primary"
          @click="exportActivity()"
          :disabled="tableState.selectedIds.length === 0"
        >
          导出活动
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
              <a-tag :color="filters.getClubActivityStatus(record.status).color">
                {{ filters.getClubActivityStatus(record.status).label }}
              </a-tag>
            </template>

            <template v-if="column.key === 'type'">
              <a-tag>
                {{ filters.getClubActivityType(record.type).label }}
              </a-tag>
            </template>

            <!--操作-->
            <template v-if="column.key === 'action'">
              <span>
                <a @click="toUpdate(record)">修改</a>
                <a-divider type="vertical" />
                <a @click="signUp(record)">签到</a>
                <a-divider type="vertical" />
                <a-popconfirm
                  title="确认删除？"
                  ok-text="删除"
                  cancel-text="取消"
                  @confirm="delActivity(record.id)"
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

  <!--报名成员-->
  <div class="mt-4">
    <a-card title="报名成员">
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
            <template v-if="column.key === 'signInFlag'">
              {{ record.signInFlag ? "已签到" : "未签到" }}
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
    :destroyOnClose="true"
  >
    <a-form
      ref="saveOrUpdateFormRef"
      :model="saveOrUpdateState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item label="社团" name="clubId" :rules="[{ required: true, message: '请选择社团!' }]">
        <a-select
          show-search
          v-model:value="saveOrUpdateState.formData.clubId"
          :field-names="{ label: 'name', value: 'id' }"
          :options="state.currentUserClubList"
        ></a-select>
      </a-form-item>

      <a-form-item
        label="活动类型"
        name="type"
        :rules="[{ required: true, message: '请选择活动类型!' }]"
      >
        <a-select
          show-search
          v-model:value="saveOrUpdateState.formData.type"
          :options="enumsConfig.clubActivity.type"
        ></a-select>
      </a-form-item>

      <a-form-item
        label="活动名称"
        name="name"
        :rules="[{ required: true, message: '请输入活动名称!' }]"
      >
        <a-input v-model:value="saveOrUpdateState.formData.name" />
      </a-form-item>

      <a-form-item
        label="活动地点"
        name="location"
        :rules="[{ required: true, message: '请输入活动地点!' }]"
      >
        <a-input v-model:value="saveOrUpdateState.formData.location" />
      </a-form-item>

      <a-form-item label="活动时间" :rules="[{ required: true, message: '请选择活动时间!' }]">
        <a-range-picker
          v-model:value="saveOrUpdateState.activeTime"
          :show-time="{ defaultValue: dayjs('00:00:00', 'HH:mm:ss'), format: 'HH:mm' }"
          :disabled-date="disabledBeforeToday"
          format="YYYY-MM-DD HH:mm"
          value-format="YYYY-MM-DD HH:mm"
          :placeholder="['开始时间', '结束时间']"
          @change="onActivityTimeChange"
        />
      </a-form-item>

      <a-form-item label="活动描述" name="description">
        <a-textarea
          v-model:value="saveOrUpdateState.formData.description"
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
import { computed, onMounted, reactive, ref } from "vue"
import { message } from "ant-design-vue"
import dayjs from "dayjs"
import { filters } from "@/config/filters.js"
import enumsConfig from "@/config/enumsConfig.js"
import clubActivityApi from "@/api/club/clubActivityApi.js"
import { useUserStore } from "@/store/modules/userInfo.js"
import clubApi from "@/api/club/clubApi.js"
import clubActivityUserApi from "@/api/club/clubActivityUserApi.js"
import { saveAs } from "file-saver"

onMounted(() => {
  isClubLeader()
  searchData()
})

const userStore = useUserStore()

const state = reactive({
  isLeader: false,
  currentUserClubList: []
})

// 查询当前用户所在社团列表
const listCurrentUserClub = () => {
  clubApi
    .listCurrentUserClub()
    .then(({ data }) => {
      if (data.code === 200) {
        state.currentUserClubList = data.data
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("查询当前用户所在社团列表失败")
    })
}

// 查询表单state
const searchFormRef = ref()
const searchFormState = reactive({
  searchForm: {
    name: ""
  }
})
// 重置查询表单
const initSearchForm = () => {
  searchFormState.searchForm.name = ""
  searchData()
}

// table state
const tableState = reactive({
  selectedIds: [],
  columns: [
    {
      title: "社团",
      dataIndex: "clubName",
      key: "clubName"
    },
    {
      title: "活动类型",
      dataIndex: "type",
      key: "type"
    },
    {
      title: "活动名称",
      dataIndex: "name",
      key: "name"
    },
    {
      title: "活动地点",
      dataIndex: "location",
      key: "location"
    },
    {
      title: "活动开始时间",
      dataIndex: "startTime",
      key: "startTime"
    },
    {
      title: "活动结束时间",
      dataIndex: "endTime",
      key: "endTime"
    },
    {
      title: "活动描述",
      dataIndex: "description",
      key: "description"
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

// 新增或更新state
const saveOrUpdateFormRef = ref()
const saveOrUpdateState = reactive({
  title: "新增用户",
  visible: false,
  confirmLoading: false,
  activeTime: null,
  formData: {
    id: "",
    // 社团id
    clubId: "",
    // 活动类型，见枚举
    type: "",
    // 活动名称
    name: "",
    // 活动地点
    location: "",
    // 活动开始时间
    startTime: null,
    // 活动结束时间
    endTime: null,
    // 活动描述
    description: "",
    // 状态，见枚举
    status: 0
  }
})
const initSaveOrUpdateForm = () => {
  saveOrUpdateState.formData.id = ""
  saveOrUpdateState.formData.clubId = ""
  saveOrUpdateState.formData.type = ""
  saveOrUpdateState.formData.name = ""
  saveOrUpdateState.formData.location = ""
  saveOrUpdateState.formData.startTime = null
  saveOrUpdateState.formData.endTime = null
  saveOrUpdateState.formData.description = ""
  saveOrUpdateState.formData.status = 0
}
// 去添加
const toAdd = () => {
  initSaveOrUpdateForm()
  listCurrentUserClub()
  saveOrUpdateState.title = "新增活动"
  saveOrUpdateState.visible = true
}

// 去更新
const toUpdate = (record) => {
  saveOrUpdateState.formData = { ...record }
  saveOrUpdateState.activeTime = [
    dayjs(record.startTime, "YYYY-MM-DD HH:mm"),
    dayjs(record.endTime, "YYYY-MM-DD HH:mm")
  ]
  listCurrentUserClub()

  saveOrUpdateState.title = "修改活动"
  saveOrUpdateState.visible = true
}

// 查询当前用户是否为社长
const isClubLeader = () => {
  clubApi
    .isClubLeader()
    .then(({ data }) => {
      if (data.code === 200) {
        state.isLeader = data.data
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("查询当前用户是否为社长失败")
    })
}

// 签到
const signUp = (record) => {
  const params = {
    activityId: record.id
  }

  clubActivityApi
    .signUp(params)
    .then(({ data }) => {
      if (data.code === 200) {
        message.success(data.message)
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
  clubActivityApi
    .listClubActivityPage(params)
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
  console.log("saveOrUpdateState.formData", saveOrUpdateState.formData)
  saveOrUpdateFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...saveOrUpdateState.formData
      }
      clubActivityApi
        .saveOrUpdateClubActivity(params)
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

// 删除活动
const delActivity = (id) => {
  if (!id) {
    message.error("请选择要删除的活动")
    return
  }

  const params = {
    id
  }
  clubActivityApi
    .deleteActivity(params)
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

// 禁用今天之前的日期
const disabledBeforeToday = (current) => {
  return current < dayjs().startOf("day")
}

const exportActivity = () => {
  if (tableState.selectedIds.length === 0) {
    message.warning("先选择社团进行导出")
  }
  const params = {
    activityId: tableState.selectedIds[0]
  }
  clubActivityApi
    .exportClubActivity(params)
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
        saveAs(blob, "活动信息.xlsx")
      }
    })
    .catch((err) => {
      console.log(err)
    })
}

const onActivityTimeChange = (value, dateString) => {
  // eslint-disable-next-line prefer-destructuring
  saveOrUpdateState.formData.startTime = value[0]
  // eslint-disable-next-line prefer-destructuring
  saveOrUpdateState.formData.endTime = value[1]
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
    activityId: tableState.selectedIds[0]
  }
  clubActivityUserApi
    .listClubActivityUserPage(params)
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
      title: "报名时间",
      dataIndex: "signupTime",
      key: "signupTime"
    },
    {
      title: "是否签到",
      dataIndex: "signInFlag",
      key: "signInFlag"
    },
    {
      title: "签到时间",
      dataIndex: "signInTime",
      key: "signInTime"
    },
    {
      title: "缺席原因",
      dataIndex: "reason",
      key: "reason"
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
