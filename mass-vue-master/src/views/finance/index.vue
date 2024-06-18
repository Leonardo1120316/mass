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

      <a-form-item label="费用类型" name="type">
        <a-select
          style="width: 200px"
          v-model:value="searchFormState.searchForm.type"
          placeholder="请选择费用类型"
          :options="enumsConfig.clubFinance.type"
        />
      </a-form-item>

      <a-form-item>
        <a-button type="primary" html-type="submit">搜索</a-button>
        <a-button @click="initSearchForm" class="ml-4">重置</a-button>
      </a-form-item>
    </a-form>
  </a-card>

  <div class="mt-4">
    <a-card title="费用列表">
      <div style="display: flex">
        <a-button type="primary" @click="toAdd()" v-if="userStore.userInfo.role === 'student'">
          新增费用
        </a-button>

        <a-button class="ml-4" type="primary" @click="toExportFinanceReport()">
          导出社团财务报告
        </a-button>
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
            <!--类型-->
            <template v-if="column.key === 'type'">
              <a-tag :color="filters.getClubFinanceType(record.type).color">
                {{ filters.getClubFinanceType(record.type).label }}
              </a-tag>
            </template>

            <!--状态-->
            <template v-if="column.key === 'status'">
              <a-tag :color="filters.getClubFinanceStatus(record.status).color">
                {{ filters.getClubFinanceStatus(record.status).label }}
              </a-tag>
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
      <a-form-item label="社团" name="clubId" :rules="[{ required: true, message: '请选择社团!' }]">
        <a-select
          show-search
          v-model:value="saveOrUpdateState.formData.clubId"
          :field-names="{ label: 'name', value: 'id' }"
          :options="state.currentUserClubList"
        ></a-select>
      </a-form-item>

      <a-form-item
        label="费用类型"
        name="type"
        :rules="[{ required: true, message: '请选择费用类型!' }]"
      >
        <a-select
          show-search
          v-model:value="saveOrUpdateState.formData.type"
          :options="enumsConfig.clubFinance.type"
        ></a-select>
      </a-form-item>

      <a-form-item label="标题" name="title" :rules="[{ required: true, message: '请输入标题!' }]">
        <a-input v-model:value="saveOrUpdateState.formData.title" />
      </a-form-item>

      <a-form-item
        label="金额"
        name="amount"
        :rules="[{ required: true, message: '请输入费用金额!' }]"
      >
        <a-input-number v-model:value="saveOrUpdateState.formData.amount" />
      </a-form-item>

      <a-form-item label="费用描述" name="description">
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

  <a-modal
    title="导出财务报告"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="exportFinanceReportState.visible"
    :confirm-loading="exportFinanceReportState.confirmLoading"
    @ok="exportFinanceReport"
    @cancel="initExportFinanceReportForm"
  >
    <a-form
      ref="exportFinanceReportRef"
      :model="exportFinanceReportState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item label="社团" name="clubId" :rules="[{ required: true, message: '请选择社团!' }]">
        <a-select
          show-search
          v-model:value="exportFinanceReportState.formData.clubId"
          :field-names="{ label: 'name', value: 'id' }"
          :options="state.currentUserClubList"
        ></a-select>
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue"
import { message } from "ant-design-vue"
import dayjs from "dayjs"
import { saveAs } from "file-saver"
import { filters } from "@/config/filters.js"
import enumsConfig from "@/config/enumsConfig.js"
import { useUserStore } from "@/store/modules/userInfo.js"
import clubApi from "@/api/club/clubApi.js"
import clubFinanceApi from "@/api/club/clubFinanceApi.js"

onMounted(() => {
  searchData()
})

const userStore = useUserStore()

const state = reactive({
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
    clubName: "",
    type: ""
  }
})
// 重置查询表单
const initSearchForm = () => {
  searchFormState.searchForm.clubName = ""
  searchFormState.searchForm.type = ""
  searchData()
}

// table state
const tableState = reactive({
  defaultIcon: "SearchOutlined",
  columns: [
    {
      title: "社团",
      dataIndex: "clubName",
      key: "clubName"
    },
    {
      title: "费用类型",
      dataIndex: "type",
      key: "type"
    },
    {
      title: "标题",
      dataIndex: "title",
      key: "title"
    },
    {
      title: "金额",
      dataIndex: "amount",
      key: "amount"
    },
    {
      title: "备注",
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
    // 费用类型，见枚举
    type: "",
    // 名称
    title: "",
    // 活动地点
    amount: 0,
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
  saveOrUpdateState.formData.title = ""
  saveOrUpdateState.formData.amount = 0
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

// 查询数据
const searchData = () => {
  tableState.loading = true
  const params = {
    pageNum: paginationState.current,
    pageSize: paginationState.pageSize,
    ...searchFormState.searchForm
  }
  clubFinanceApi
    .listClubFinancePage(params)
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
      clubFinanceApi
        .saveOrUpdateClubFinance(params)
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

  // clubActivityApi
  //   .deleteBatch(params)
  //   .then(({ data }) => {
  //     if (data.code === 200) {
  //       searchData()
  //       message.success(data.message)
  //     } else {
  //       message.error(data.message)
  //     }
  //   })
  //   .catch(() => {
  //     message.error("删除失败")
  //   })
}

// 导出社团财务报告state
const exportFinanceReportRef = ref()
const exportFinanceReportState = reactive({
  visible: false,
  confirmLoading: false,
  formData: {
    // 社团id
    clubId: ""
  }
})
const initExportFinanceReportForm = () => {
  exportFinanceReportState.formData.clubId = ""
}

const toExportFinanceReport = () => {
  initExportFinanceReportForm()
  listCurrentUserClub()
  exportFinanceReportState.visible = true
}

// 导出社团财务报告
const exportFinanceReport = () => {
  exportFinanceReportRef.value
    .validate()
    .then(() => {
      const params = {
        ...exportFinanceReportState.formData
      }
      clubFinanceApi
        .exportFinanceReport(params)
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
            saveAs(blob, "社团报告.xlsx")
          }
        })
        .catch((err) => {
          console.log(err)
        })
    })
    .catch(() => {
      saveOrUpdateState.confirmLoading = false
      message.error("请检查表单项")
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
