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
      <div class="mt-4">
        <a-table
          rowKey="id"
          :columns="tableState.columns"
          :data-source="tableState.dataList"
          :loading="tableState.loading"
          :pagination="paginationState"
        >
          <template #bodyCell="{ column, record }">
            <!--状态-->
            <template v-if="column.key === 'status'">
              <a-tag :color="filters.getClubActivityStatus(record.status).color"
                >{{ filters.getClubActivityStatus(record.status).label }}
              </a-tag>
            </template>

            <!--操作-->
            <template v-if="column.key === 'action'">
              <span>
                <a @click="toSignUp(record)">报名</a>
                <a-divider type="vertical" />
                <a @click="getClubInfo(record)">社团信息</a>
              </span>
            </template>
          </template>
        </a-table>
      </div>
    </a-card>
  </div>

  <!-- 报名 -->
  <a-modal
    :title="saveRecruitmentState.title"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="saveRecruitmentState.visible"
    :confirm-loading="saveRecruitmentState.confirmLoading"
    @ok="saveRecruitment"
    @cancel="initSaveRecruitmentForm"
    :destroy-on-close="true"
  >
    <a-form
      ref="saveRecruitmentFormRef"
      :model="saveRecruitmentState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item
        label="自我介绍"
        name="description"
        :rules="[{ required: true, message: '请输入自我介绍!' }]"
      >
        <a-textarea
          v-model:value="saveRecruitmentState.formData.description"
          :rows="4"
          placeholder="最多220个字符"
          show-count
          :maxlength="220"
        />
      </a-form-item>
    </a-form>
  </a-modal>

  <a-modal
    v-model:visible="clubInfoState.visible"
    width="1000px"
    @ok="clubInfoState.visible = false"
    @cancel="clubInfoState.visible = false"
  >
    <div>
      <a-descriptions :title="clubInfoState.title" bordered>
        <a-descriptions-item label="logo">
          <a-image
            :width="100"
            :height="100"
            :src="clubInfoState.data.logo"
            fallback="data:image/png;base64,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"
          />
        </a-descriptions-item>
        <a-descriptions-item label="社团名称">{{ clubInfoState.data.name }}</a-descriptions-item>
        <a-descriptions-item label="社长">{{ clubInfoState.data.leader }}</a-descriptions-item>
        <a-descriptions-item label="社团类型" :span="3">
          <a-tag>{{ clubInfoState.data.typeName }}</a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="成员数量" :span="3">
          {{ clubInfoState.data.memberCount }}
        </a-descriptions-item>
        <a-descriptions-item label="建立时间" :span="3"
          >{{ clubInfoState.data.createTime }}
        </a-descriptions-item>
        <a-descriptions-item label="Status" :span="3">
          <a-badge
            :status="filters.getClubStatus(clubInfoState.data.status).color"
            :text="filters.getClubStatus(clubInfoState.data.status).label"
          />
        </a-descriptions-item>
        <a-descriptions-item label="社团描述">
          {{ clubInfoState.data.description }}
        </a-descriptions-item>
      </a-descriptions>
    </div>
  </a-modal>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue"
import { message } from "ant-design-vue"
import { filters } from "@/config/filters.js"
import clubActivityApi from "@/api/club/clubActivityApi.js"
import clubRecruitmentApi from "@/api/club/clubRecruitmentApi.js"
import clubApi from "@/api/club/clubApi.js"

onMounted(() => {
  searchData()
})

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
  defaultIcon: "SearchOutlined",
  columns: [
    {
      title: "社团",
      dataIndex: "clubName",
      key: "clubName"
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

// 新增或更新state
const saveRecruitmentFormRef = ref()
const saveRecruitmentState = reactive({
  title: "申请加入",
  visible: false,
  confirmLoading: false,
  activeTime: null,
  formData: {
    // 活动id
    activityId: "",
    // 自我介绍
    description: ""
  }
})
const initSaveRecruitmentForm = () => {
  saveRecruitmentState.formData.activityId = ""
  saveRecruitmentState.formData.description = ""
}

// 申请加入社团
const toSignUp = (record) => {
  initSaveRecruitmentForm()
  saveRecruitmentState.formData.activityId = record.id

  saveRecruitmentState.title = "申请加入"
  saveRecruitmentState.visible = true
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
    .listRecruitmentActivityPage(params)
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

// 报名
const saveRecruitment = () => {
  saveRecruitmentFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...saveRecruitmentState.formData
      }
      clubRecruitmentApi
        .saveRecruitment(params)
        .then(({ data }) => {
          if (data.code === 200) {
            saveRecruitmentState.confirmLoading = false
            saveRecruitmentState.visible = false
            searchData()
            message.success(data.message)
          } else {
            saveRecruitmentState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch(() => {
          saveRecruitmentState.confirmLoading = false
          message.error("请检查表单项")
        })
    })
    .catch((error) => {
      saveRecruitmentState.confirmLoading = false
      message.error("请检查表单项")
    })
}

const clubInfoState = reactive({
  title: "社团信息",
  data: null,
  visible: false
})
// 查看社团信息
const getClubInfo = (record) => {
  const params = {
    clubId: record.clubId
  }
  clubApi
    .getClubInfo(params)
    .then(({ data }) => {
      if (data.code === 200) {
        clubInfoState.data = data.data
        clubInfoState.visible = true
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
