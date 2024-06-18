<template>
  <!--查询表单-->
  <a-card>
    <a-form
      ref="searchFormRef"
      layout="inline"
      :model="searchFormState.searchForm"
      @finish="searchData"
    >
      <a-form-item label="标题" name="title">
        <a-input v-model:value="searchFormState.searchForm.title" placeholder="请输入标题" />
      </a-form-item>

      <a-form-item label="类别" name="type">
        <a-select
          style="width: 200px"
          v-model:value="searchFormState.searchForm.type"
          :options="enumsConfig.notice.type"
        ></a-select>
      </a-form-item>

      <a-form-item>
        <a-button type="primary" html-type="submit">搜索</a-button>
        <a-button @click="initSearchForm" class="ml-4">重置</a-button>
      </a-form-item>
    </a-form>
  </a-card>

  <div class="mt-4">
    <a-card title="通知列表">
      <div style="display: flex">
        <a-button
          type="primary"
          @click="toAddClubNotice()"
          v-if="userStore.userInfo.role === 'student'"
        >
          新增社团通知
        </a-button>

        <a-button
          type="primary"
          @click="toAddSystemNotice()"
          v-if="userStore.userInfo.role === 'admin'"
        >
          新增系统通知
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
            <!--状态-->
            <template v-if="column.key === 'type'">
              <a-tag :color="filters.getNoticeType(record.type).color">
                {{ filters.getNoticeType(record.type).label }}
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
      <a-form-item
        v-if="saveOrUpdateState.formData.type === enumsConfig.notice.type[0].value"
        label="社团"
        name="clubId"
        :rules="[
          {
            required: saveOrUpdateState.formData.type === enumsConfig.notice.type[0].value,
            message: '请选择社团!'
          }
        ]"
      >
        <a-select
          show-search
          v-model:value="saveOrUpdateState.formData.clubId"
          :field-names="{ label: 'name', value: 'id' }"
          @focus="listCurrentUserClub"
          :options="state.currentUserClubList"
        ></a-select>
      </a-form-item>

      <a-form-item label="标题" name="title" :rules="[{ required: true, message: '请输入标题!' }]">
        <a-input v-model:value="saveOrUpdateState.formData.title" />
      </a-form-item>

      <a-form-item
        label="内容"
        name="content"
        :rules="[{ required: true, message: '请输入内容!' }]"
      >
        <a-textarea
          v-model:value="saveOrUpdateState.formData.content"
          placeholder="通知内容，不超过255字"
          :allowClear="true"
          size="large"
          :showCount="true"
          :maxlength="255"
          :minRows="8"
          :rows="8"
        />
      </a-form-item>
    </a-form>
  </a-modal>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue"
import { message } from "ant-design-vue"
import { filters } from "@/config/filters.js"
import { useUserStore } from "@/store/modules/userInfo.js"
import clubApi from "@/api/club/clubApi.js"
import sysNoticeApi from "@/api/notice/sysNoticeApi.js"
import dayjs from "dayjs"
import enumsConfig from "@/config/enumsConfig.js"

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
    title: "",
    type: ""
  }
})
// 重置查询表单
const initSearchForm = () => {
  searchFormState.searchForm.title = ""
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
      title: "通知类型",
      dataIndex: "type",
      key: "type"
    },
    {
      title: "标题",
      dataIndex: "title",
      key: "title"
    },
    {
      title: "内容",
      dataIndex: "content",
      key: "content"
    },
    {
      title: "发布人",
      dataIndex: "publisherName",
      key: "publisherName"
    },
    {
      title: "发布时间",
      dataIndex: "createTime",
      key: "create_time"
    },
    {
      title: "修改时间",
      dataIndex: "updateTime",
      key: "updateTime"
    }
  ],
  loading: false,
  dataList: []
})

// 新增或更新state
const saveOrUpdateFormRef = ref()
const saveOrUpdateState = reactive({
  title: "新增",
  visible: false,
  confirmLoading: false,
  activeTime: null,
  formData: {
    id: "",
    // 类别
    type: "",
    // 社团id
    clubId: "",
    // 标题
    title: "",
    // 内容
    content: ""
  }
})
const initSaveOrUpdateForm = () => {
  saveOrUpdateState.formData.id = ""
  saveOrUpdateState.formData.type = ""
  saveOrUpdateState.formData.clubId = ""
  saveOrUpdateState.formData.title = ""
  saveOrUpdateState.formData.content = ""
}

// 去添加
const toAddClubNotice = () => {
  initSaveOrUpdateForm()
  listCurrentUserClub()
  saveOrUpdateState.title = "新增社团通知"
  saveOrUpdateState.formData.type = enumsConfig.notice.type[0].value
  saveOrUpdateState.visible = true
}

// 去添加系统通知
const toAddSystemNotice = () => {
  initSaveOrUpdateForm()

  saveOrUpdateState.title = "新增系统通知"
  saveOrUpdateState.formData.type = enumsConfig.notice.type[1].value
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
  sysNoticeApi
    .listSysNoticePage(params)
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
      sysNoticeApi
        .saveOrUpdateNotice(params)
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

// 批量删除
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
