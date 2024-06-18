<template>
  <!--查询表单-->
  <a-card>
    <a-form
      ref="searchFormRef"
      layout="inline"
      :model="searchFormState.searchForm"
      @finish="searchData"
    >
      <a-form-item label="名称" name="name">
        <a-input v-model:value="searchFormState.searchForm.name" placeholder="请输入名称" />
      </a-form-item>

      <a-form-item>
        <a-button type="primary" html-type="submit">搜索</a-button>
        <a-button @click="initSearchForm" class="ml-4">重置</a-button>
      </a-form-item>
    </a-form>
  </a-card>

  <div class="mt-4">
    <a-card title="审批设置">
      <div style="display: flex">
        <a-button type="primary" @click="toAdd()">新增设置</a-button>
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
              <a-tag :color="filters.getApproveSettingStatus(record.status).color">
                {{ filters.getApproveSettingStatus(record.status).label }}
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

  <div class="mt-4">
    <a-card title="审批设置详情">
      <div style="display: flex">
        <a-button type="primary" @click="toAddDetail()">新增详情</a-button>
      </div>

      <!--表格-->
      <div style="margin-top: 30px">
        <a-table
          rowKey="id"
          :columns="detailTableState.columns"
          :data-source="detailTableState.dataList"
          :loading="detailTableState.loading"
          :pagination="detailPaginationState"
        >
          <template #bodyCell="{ column, record }">
            <!--状态-->
            <template v-if="column.key === 'status'">
              <a-tag :color="filters.getApproveSettingStatus(record.status).color">
                {{ filters.getApproveSettingStatus(record.status).label }}
              </a-tag>
            </template>

            <!--操作-->
            <template v-if="column.key === 'action'">
              <span>
                <a @click="toUpdateDetail(record)">修改</a>
                <a-divider type="vertical" />
                <a-popconfirm
                  title="确认删除？"
                  ok-text="删除"
                  cancel-text="取消"
                  @confirm="delDetailBatch([record.id])"
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

  <!-- 新增或更新设置 -->
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
      <a-form-item label="名称" name="name" :rules="[{ required: true, message: '请输入名称!' }]">
        <a-input v-model:value="saveOrUpdateState.formData.name" />
      </a-form-item>

      <a-form-item label="代码" name="code" :rules="[{ required: true, message: '请选择代码!' }]">
        <a-select
          show-search
          v-model:value="saveOrUpdateState.formData.code"
          :options="enumsConfig.approveSetting.code"
        ></a-select>
      </a-form-item>

      <a-form-item
        label="审批方式"
        name="method"
        :rules="[{ required: true, message: '请选择审批方式!' }]"
      >
        <a-select
          show-search
          v-model:value="saveOrUpdateState.formData.method"
          :options="enumsConfig.approveSetting.method"
        ></a-select>
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

  <!-- 新增或更新详情 -->
  <a-modal
    :title="saveOrUpdateDetailState.title"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="saveOrUpdateDetailState.visible"
    :confirm-loading="saveOrUpdateDetailState.confirmLoading"
    @ok="saveOrUpdateDetail"
    @cancel="initSaveOrUpdateDetailForm"
  >
    <a-form
      ref="saveOrUpdateDetailFormRef"
      :model="saveOrUpdateDetailState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item
        label="审批人"
        name="approvePerson"
        :rules="[{ required: true, message: '请选择审批人!' }]"
      >
        <a-select
          show-search
          v-model:value="saveOrUpdateDetailState.formData.approvePerson"
          :field-names="{ label: 'nickname', value: 'id' }"
          :options="state.teacherBaseInfoList"
        ></a-select>
      </a-form-item>

      <a-form-item
        label="排序码"
        name="sorted"
        :rules="[{ required: true, message: '请输入排序码!' }]"
      >
        <a-input-number
          v-model:value="saveOrUpdateDetailState.formData.sorted"
          :min="1"
        ></a-input-number>
      </a-form-item>

      <a-form-item label="状态" name="status">
        <a-switch
          v-model:checked="saveOrUpdateDetailState.formData.status"
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
import { computed, onMounted, reactive, ref } from "vue"
import { message } from "ant-design-vue"
import { filters } from "@/config/filters.js"
import enumsConfig from "@/config/enumsConfig.js"
import approveSettingApi from "@/api/approvesetting/approveSettingApi.js"
import approveSettingDetailApi from "@/api/approvesetting/approveSettingDetailApi.js"
import userApi from "@/api/user/userApi.js"

onMounted(() => {
  searchData()
})

const state = reactive({
  teacherBaseInfoList: []
})

// 查询所有老师基本信息
const listTeachersBaseInfo = () => {
  userApi
    .listTeachersBaseInfo()
    .then(({ data }) => {
      if (data.code === 200) {
        state.teacherBaseInfoList = data.data
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("查询失败")
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
  cleanDetailData()
  searchData()
}

// table state
const tableState = reactive({
  defaultIcon: "SearchOutlined",
  selectedSettingIds: [],
  columns: [
    {
      title: "名称",
      dataIndex: "name",
      key: "name"
    },
    {
      title: "审批类型代码",
      dataIndex: "code",
      key: "code"
    },
    {
      title: "审批方式",
      dataIndex: "methodName",
      key: "methodName"
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
  title: "新增审批设置",
  visible: false,
  confirmLoading: false,
  formData: {
    id: "",
    // 名称
    name: "",
    // 代码
    code: "",
    // 审批方式
    method: "",
    // 状态
    status: 0
  }
})
const initSaveOrUpdateForm = () => {
  saveOrUpdateState.formData.id = ""
  saveOrUpdateState.formData.name = ""
  saveOrUpdateState.formData.code = ""
  saveOrUpdateState.formData.method = ""
  saveOrUpdateState.formData.status = 0
}

const selectSetting = computed(() => {
  return {
    selectedRowKeys: tableState.selectedSettingIds,
    type: "radio",
    onChange: (selectedRowKeys) => {
      tableState.selectedSettingIds = selectedRowKeys
    }
  }
})
const selectRow = (record) => {
  // 单选不可取消
  tableState.selectedSettingIds = [record.id]

  // 单选可取消
  // const selectedRowKeys = [...tableState.selectedSettingIds]
  // if (selectedRowKeys[0] === record.id) {
  //   tableState.selectedSettingIds = []
  // } else {
  //   tableState.selectedSettingIds = [record.id]
  // }

  // 多选
  // const selectedRowKeys = [...tableState.selectedSettingIds]
  // if (selectedRowKeys.indexOf(record.id) >= 0) {
  //   selectedRowKeys.splice(selectedRowKeys.indexOf(record.id), 1)
  // } else {
  //   selectedRowKeys.push(record.id)
  // }
  // tableState.selectedSettingIds = selectedRowKeys
  searchDetailData()
}
const customRow = (record) => {
  return {
    onClick: () => {
      selectRow(record)
    }
  }
}

// 去添加
const toAdd = () => {
  initSaveOrUpdateForm()
  saveOrUpdateState.title = "新增审批设置"
  saveOrUpdateState.visible = true
}

// 去更新
const toUpdate = (record) => {
  saveOrUpdateState.formData = { ...record }
  saveOrUpdateState.title = "修改审批设置"
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
  approveSettingApi
    .listApproveSettingPage(params)
    .then(({ data }) => {
      if (data.code === 200) {
        cleanDetailData()

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
      approveSettingApi
        .saveOrUpdateApproveSetting(params)
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

  // userApi
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

// 详情table
const detailTableState = reactive({
  defaultIcon: "SearchOutlined",
  columns: [
    {
      title: "审批人",
      dataIndex: "approvePersonName",
      key: "approvePersonName"
    },
    {
      title: "排序",
      dataIndex: "sorted",
      key: "sorted"
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

// 新增或更新详情state
const saveOrUpdateDetailFormRef = ref()
const saveOrUpdateDetailState = reactive({
  title: "新增审批设置详情",
  visible: false,
  confirmLoading: false,
  formData: {
    id: "",
    // 审批设置id
    approveSettingId: "",
    // 审批人id
    approvePerson: "",
    // 排序码
    sorted: 1,
    // 状态
    status: 0
  }
})
const initSaveOrUpdateDetailForm = () => {
  saveOrUpdateDetailState.formData.id = ""
  saveOrUpdateDetailState.formData.approveSettingId = ""
  saveOrUpdateDetailState.formData.approvePerson = ""
  saveOrUpdateDetailState.formData.sorted = 1
  saveOrUpdateDetailState.formData.status = 0
}
const cleanDetailData = () => {
  tableState.selectedSettingIds = []
  detailTableState.dataList = []
}

// 去添加详情
const toAddDetail = () => {
  initSaveOrUpdateDetailForm()
  if (!tableState.selectedSettingIds[0]) {
    message.warning("请选择一条审批设置数据")
    return
  }

  listTeachersBaseInfo()
  // eslint-disable-next-line prefer-destructuring
  saveOrUpdateDetailState.formData.approveSettingId = tableState.selectedSettingIds[0]
  saveOrUpdateDetailState.visible = true
}

// 去更新详情
const toUpdateDetail = (record) => {
  saveOrUpdateDetailState.formData = { ...record }
  saveOrUpdateDetailState.title = "修改审批设置详情"
  saveOrUpdateDetailState.visible = true
}

// 查询详情数据
const searchDetailData = () => {
  detailTableState.loading = true
  const params = {
    pageNum: detailPaginationState.current,
    pageSize: detailPaginationState.pageSize,
    approveSettingId: tableState.selectedSettingIds[0]
  }
  approveSettingDetailApi
    .listApproveSettingDetailPage(params)
    .then(({ data }) => {
      if (data.code === 200) {
        detailTableState.dataList = data.data.records
        detailTableState.loading = false
      } else {
        detailTableState.loading = false
        message.error(data.message)
      }
    })
    .catch((err) => {
      detailTableState.loading = false
      message.error(err.message)
    })
}

// 新增或修改详情
const saveOrUpdateDetail = () => {
  saveOrUpdateDetailFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...saveOrUpdateDetailState.formData
      }
      approveSettingDetailApi
        .saveOrUpdateApproveSettingDetail(params)
        .then(({ data }) => {
          if (data.code === 200) {
            saveOrUpdateDetailState.confirmLoading = false
            saveOrUpdateDetailState.visible = false
            searchDetailData()
            message.success(data.message)
          } else {
            saveOrUpdateDetailState.confirmLoading = false
            message.error(data.message)
          }
        })
        .catch(() => {
          saveOrUpdateDetailState.confirmLoading = false
          message.error("请检查表单项")
        })
    })
    .catch(() => {
      saveOrUpdateDetailState.confirmLoading = false
      message.error("请检查表单项")
    })
}

// 批量删除详情
const delDetailBatch = (idList) => {
  const params = []
  idList.forEach((item) => {
    params.push(item)
  })

  // userApi
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

// 详情分页配置
const detailPaginationState = reactive({
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
    detailPaginationState.current = page
    detailPaginationState.pageSize = pageSize
    searchDetailData()
  }
})
</script>

<style scoped></style>
