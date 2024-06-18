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
    <a-card title="审批列表">
      <!--表格-->
      <div>
        <a-table
          rowKey="id"
          :columns="tableState.columns"
          :data-source="tableState.dataList"
          :loading="tableState.loading"
          :pagination="paginationState"
        >
          <template #bodyCell="{ column, record }">
            <!--状态-->
            <template v-if="column.key === 'sex'">
              {{ filters.getSex(record.sex).label }}
            </template>

            <!--状态-->
            <template v-if="column.key === 'status'">
              <a-tag :color="filters.getClubRecruitmentStatus(record.status).color">
                {{ filters.getClubRecruitmentStatus(record.status).label }}
              </a-tag>
            </template>

            <!--操作-->
            <template v-if="column.key === 'action'">
              <span v-if="props.type === 'apply'">
                <span v-if="userStore.userInfo.role === 'student'">
                  <a-popconfirm
                    title="确定取消申请?"
                    ok-text="是"
                    cancel-text="否"
                    @confirm="cancelApply(record)"
                  >
                    <a>取消申请</a>
                  </a-popconfirm>
                </span>
              </span>

              <span v-else-if="props.type === 'approve'">
                <a @click="toApprove(record)">审核</a>
              </span>
            </template>
          </template>
        </a-table>
      </div>
    </a-card>
  </div>

  <!-- 审核 -->
  <a-modal
    :title="approveState.title"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="approveState.visible"
    :confirm-loading="approveState.confirmLoading"
    @ok="approve"
    @cancel="initApproveForm"
  >
    <a-form
      ref="approveFormRef"
      :model="approveState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item
        label="审核意见"
        name="status"
        :rules="[{ required: true, message: '请选择审批意见!' }]"
      >
        <a-radio-group v-model:value="approveState.formData.status">
          <a-radio :value="enumsConfig.clubRecruitment.status[1].value">
            {{ enumsConfig.clubRecruitment.status[1].label }}
          </a-radio>
          <a-radio :value="enumsConfig.clubRecruitment.status[2].value">
            {{ enumsConfig.clubRecruitment.status[2].label }}
          </a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item
        label="拒绝原因"
        name="reason"
        :rules="[
          {
            required: approveState.formData.status === enumsConfig.clubRecruitment.status[2].value,
            message: '请填写拒绝原因!'
          }
        ]"
      >
        <a-textarea
          v-model:value="approveState.formData.reason"
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
import { onMounted, reactive, ref } from "vue"
import { message } from "ant-design-vue"
import { filters } from "@/config/filters.js"
import enumsConfig from "@/config/enumsConfig.js"
import { useUserStore } from "@/store/modules/userInfo.js"
import clubRecruitmentApi from "@/api/club/clubRecruitmentApi.js"

onMounted(() => {
  searchData()
})

const props = defineProps({
  type: {
    type: String,
    default: "apply"
  }
})

const userStore = useUserStore()

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
  searchData()
}

// 查询数据
const searchData = () => {
  tableState.loading = true
  const params = {
    pageNum: paginationState.current,
    pageSize: paginationState.pageSize,
    type: props.type,
    ...searchFormState.searchForm
  }
  clubRecruitmentApi
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

// table state
const tableState = reactive({
  columns: [
    {
      title: "社团名称",
      dataIndex: "clubName",
      key: "clubName"
    },
    {
      title: "申请人",
      dataIndex: "applyUserNickName",
      key: "applyUserNickName"
    },
    {
      title: "性别",
      dataIndex: "sex",
      key: "sex"
    },
    {
      title: "邮箱",
      dataIndex: "email",
      key: "email"
    },
    {
      title: "手机号",
      dataIndex: "phone",
      key: "phone"
    },
    {
      title: "自我介绍",
      dataIndex: "description",
      key: "description"
    },
    {
      title: "申请时间",
      dataIndex: "createTime",
      key: "createTime"
    },
    {
      title: "状态",
      dataIndex: "status",
      key: "status"
    },
    {
      title: "审批人",
      dataIndex: "approvePersonNickName",
      key: "approvePersonNickName"
    },
    {
      title: "审批时间",
      dataIndex: "approveTime",
      key: "approveTime"
    },
    {
      title: "拒绝原因",
      dataIndex: "reason",
      key: "reason"
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
const approveFormRef = ref()
const approveState = reactive({
  title: "审批",
  visible: false,
  confirmLoading: false,
  formData: {
    id: "",
    // 拒绝原因
    reason: "",
    // 状态，见枚举
    status: 1,
    clubId: ""
  }
})
const initApproveForm = () => {
  approveState.formData.id = ""
  approveState.formData.reason = ""
  approveState.formData.status = 1
  approveState.formData.clubId = ""
}

// 去审批
const toApprove = (record) => {
  if (record.status !== enumsConfig.clubRecruitment.status[0].value) {
    message.error("只有待审核状态的数据才可审批！")
    return
  }
  if (userStore.getUserInfo.id !== record.clubLeaderId) {
    message.error("无审批权限！")
    return
  }

  approveState.formData.id = record.id
  approveState.formData.clubId = record.clubId
  approveState.title = "审批"
  approveState.visible = true
}

// 审批
const approve = () => {
  approveFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...approveState.formData
      }
      clubRecruitmentApi
        .approve(params)
        .then(({ data }) => {
          if (data.code === 200) {
            approveState.confirmLoading = false
            approveState.visible = false
            searchData()
            message.success(data.message)
          } else {
            approveState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch(() => {
          approveState.confirmLoading = false
          message.error("请检查表单项")
        })
    })
    .catch(() => {
      approveState.confirmLoading = false
      message.error("请检查表单项")
    })
}

// 取消申请
const cancelApply = (record) => {
  const params = {
    id: record.id
  }
  clubRecruitmentApi
    .cancelRecruitment(params)
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
