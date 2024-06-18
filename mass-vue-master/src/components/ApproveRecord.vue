<template>
  <div>
    <a-card title="审批记录">
      <div>
        <a-form
          ref="searchFormRef"
          layout="inline"
          :model="searchFormState.searchForm"
          @finish="searchData"
        >
          <a-form-item label="业务id" name="businessId">
            <a-input
              v-model:value="searchFormState.searchForm.businessId"
              placeholder="请输入业务id"
            />
          </a-form-item>

          <a-form-item>
            <a-button type="primary" html-type="submit">搜索</a-button>
            <a-button @click="initSearchForm" class="ml-4">重置</a-button>
          </a-form-item>
        </a-form>
      </div>

      <!--表格-->
      <div class="mt-4">
        <a-tabs
          type="card"
          v-model:activeKey="state.settingTableActiveKey"
          @change="settingTableActiveKeyChange"
        >
          <a-tab-pane key="1" tab="社团申请">
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
                <!--审批方式-->
                <template v-if="column.key === 'approveMethod'">
                  <a-tag>
                    {{ filters.getApproveSettingMethod(record.approveMethod).label }}
                  </a-tag>
                </template>

                <!--状态-->
                <template v-if="column.key === 'status'">
                  <a-tag :color="filters.getApproveRecordStatus(record.status).color">
                    {{ filters.getApproveRecordStatus(record.status).label }}
                  </a-tag>
                </template>

                <!--操作-->
                <template v-if="column.key === 'action'">
                  <span v-if="props.type === 0">
                    <a @click="toApprove(record)">审批</a>
                    <!--<a-divider type="vertical" />-->
                    <!--<a-popconfirm-->
                    <!--  title="确认删除？"-->
                    <!--  ok-text="删除"-->
                    <!--  cancel-text="取消"-->
                    <!--  @confirm="delBatch([record.id])"-->
                    <!--&gt;-->
                    <!--  <a>删除</a>-->
                    <!--</a-popconfirm>-->
                  </span>
                </template>
              </template>
            </a-table>
          </a-tab-pane>
          <a-tab-pane key="2" tab="社团活动申请">
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
                <!--审批方式-->
                <template v-if="column.key === 'approveMethod'">
                  <a-tag>
                    {{ filters.getApproveSettingMethod(record.approveMethod).label }}
                  </a-tag>
                </template>

                <!--状态-->
                <template v-if="column.key === 'status'">
                  <a-tag :color="filters.getApproveRecordStatus(record.status).color">
                    {{ filters.getApproveRecordStatus(record.status).label }}
                  </a-tag>
                </template>

                <!--操作-->
                <template v-if="column.key === 'action'">
                  <span v-if="props.type === 0">
                    <a @click="toApprove(record)">审批</a>
                    <a-divider type="vertical" />
                    <a-popconfirm
                      title="确认驳回？"
                      ok-text="确定"
                      cancel-text="取消"
                      @confirm="revertActivityApply(record.id)"
                    >
                      <a>驳回</a>
                    </a-popconfirm>
                  </span>
                </template>
              </template>
            </a-table>
          </a-tab-pane>
          <a-tab-pane key="3" tab="财务审批">
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
                <!--审批方式-->
                <template v-if="column.key === 'approveMethod'">
                  <a-tag>
                    {{ filters.getApproveSettingMethod(record.approveMethod).label }}
                  </a-tag>
                </template>

                <!--状态-->
                <template v-if="column.key === 'status'">
                  <a-tag :color="filters.getApproveRecordStatus(record.status).color">
                    {{ filters.getApproveRecordStatus(record.status).label }}
                  </a-tag>
                </template>

                <!--操作-->
                <template v-if="column.key === 'action'">
                  <span v-if="props.type === 0">
                    <a @click="toApprove(record)">审批</a>
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
          </a-tab-pane>
          <a-tab-pane key="4" tab="解散社团申请">
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
                <!--审批方式-->
                <template v-if="column.key === 'approveMethod'">
                  <a-tag>
                    {{ filters.getApproveSettingMethod(record.approveMethod).label }}
                  </a-tag>
                </template>

                <!--状态-->
                <template v-if="column.key === 'status'">
                  <a-tag :color="filters.getApproveRecordStatus(record.status).color">
                    {{ filters.getApproveRecordStatus(record.status).label }}
                  </a-tag>
                </template>

                <!--操作-->
                <template v-if="column.key === 'action'">
                  <span v-if="props.type === 0">
                    <a @click="toApprove(record)">审批</a>
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
          </a-tab-pane>
        </a-tabs>
      </div>
    </a-card>
  </div>

  <div class="mt-4">
    <a-card title="审批记录详情">
      <div class="mt-4">
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
              <a-tag :color="filters.getApproveRecordDetailStatus(record.status).color">
                {{ filters.getApproveRecordDetailStatus(record.status).label }}
              </a-tag>
            </template>
          </template>
        </a-table>
      </div>
    </a-card>
  </div>

  <!-- 审批 -->
  <a-modal
    :title="approveState.title"
    ok-text="确认"
    cancel-text="取消"
    v-model:visible="approveState.visible"
    :confirm-loading="approveState.confirmLoading"
    @ok="approve"
    @cancel="initApproveForm"
    :destroyOnClose="true"
  >
    <a-form
      ref="approveFormRef"
      :model="approveState.formData"
      :label-col="{ span: 6 }"
      :wrapper-col="{ span: 16 }"
      autocomplete="off"
    >
      <a-form-item
        label="审批意见"
        name="result"
        :rules="[{ required: true, message: '请选择审批意见!' }]"
      >
        <a-radio-group v-model:value="approveState.formData.result">
          <a-radio :value="enumsConfig.approveRecord.detailStatus[2].value">
            {{ enumsConfig.approveRecord.detailStatus[2].label }}
          </a-radio>
          <a-radio :value="enumsConfig.approveRecord.detailStatus[0].value">
            {{ enumsConfig.approveRecord.detailStatus[0].label }}
          </a-radio>
        </a-radio-group>
      </a-form-item>

      <a-form-item
        label="备注"
        name="remark"
        :rules="[
          {
            required:
              approveState.formData.result === enumsConfig.approveRecord.detailStatus[0].value,
            message: '请填写拒绝原因!'
          }
        ]"
      >
        <a-textarea
          v-model:value="approveState.formData.remark"
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
import { filters } from "@/config/filters.js"
import enumsConfig from "@/config/enumsConfig.js"
import approveRecordApi from "@/api/approverecord/approveRecordApi.js"
import approveRecordDetailApi from "@/api/approverecord/approveRecordDetailApi.js"

onMounted(() => {
  searchData()
})

const props = defineProps({
  // 标题
  title: {
    type: String,
    default: ""
  },
  // 类型 0：待审批 1：已审批
  type: {
    type: Number,
    default: 0
  }
})

const state = reactive({
  settingTableActiveKey: "1",
  tableColumns: {
    clubApply: [
      {
        title: "审批类型",
        dataIndex: "approveTypeName",
        key: "approveTypeName"
      },
      {
        title: "社团名称",
        dataIndex: ["club", "name"],
        key: ["club", "name"]
      },
      {
        title: "社团类型",
        dataIndex: ["club", "typeName"],
        key: ["club", "typeName"]
      },
      {
        title: "社长",
        dataIndex: ["club", "leader"],
        key: ["club", "leader"]
      },
      {
        title: "社团描述",
        dataIndex: ["club", "description"],
        key: ["club", "description"]
      },
      {
        title: "申请人",
        dataIndex: "applyPersonName",
        key: "applyPersonName"
      },
      {
        title: "审批方式",
        dataIndex: "approveMethod",
        key: "approveMethod"
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
    clubActivityApply: [
      {
        title: "审批类型",
        dataIndex: "approveTypeName",
        key: "approveTypeName"
      },
      {
        title: "社团",
        dataIndex: ["clubActivity", "clubName"],
        key: ["clubActivity", "clubName"]
      },
      {
        title: "活动名称",
        dataIndex: ["clubActivity", "name"],
        key: ["clubActivity", "name"]
      },
      {
        title: "活动类型",
        dataIndex: ["clubActivity", "type"],
        key: ["clubActivity", "type"]
      },
      {
        title: "活动地点",
        dataIndex: ["clubActivity", "location"],
        key: ["clubActivity", "location"]
      },
      {
        title: "活动开始时间",
        dataIndex: ["clubActivity", "startTime"],
        key: ["clubActivity", "startTime"]
      },
      {
        title: "活动结束时间",
        dataIndex: ["clubActivity", "endTime"],
        key: ["clubActivity", "endTime"]
      },
      {
        title: "活动描述",
        dataIndex: ["clubActivity", "description"],
        key: ["clubActivity", "description"]
      },
      {
        title: "活动状态",
        dataIndex: ["clubActivity", "status"],
        key: ["clubActivity", "status"]
      },
      {
        title: "申请人",
        dataIndex: "applyPersonName",
        key: "applyPersonName"
      },
      {
        title: "审批方式",
        dataIndex: "approveMethod",
        key: "approveMethod"
      },
      {
        title: "审批状态",
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
    clubFinance: [
      {
        title: "审批类型",
        dataIndex: "approveTypeName",
        key: "approveTypeName"
      },
      {
        title: "社团",
        dataIndex: ["clubFinance", "clubName"],
        key: ["clubFinance", "clubName"]
      },
      {
        title: "标题",
        dataIndex: ["clubFinance", "title"],
        key: ["clubFinance", "title"]
      },
      {
        title: "费用类型",
        dataIndex: ["clubFinance", "type"],
        key: ["clubFinance", "type"]
      },
      {
        title: "金额",
        dataIndex: ["clubFinance", "amount"],
        key: ["clubFinance", "amount"]
      },
      {
        title: "备注",
        dataIndex: ["clubFinance", "description"],
        key: ["clubFinance", "description"]
      },
      {
        title: "状态",
        dataIndex: ["clubFinance", "status"],
        key: ["clubFinance", "status"]
      },
      {
        title: "申请人",
        dataIndex: "applyPersonName",
        key: "applyPersonName"
      },
      {
        title: "审批方式",
        dataIndex: "approveMethod",
        key: "approveMethod"
      },
      {
        title: "审批状态",
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
    dissolveClubApply: [
      {
        title: "审批类型",
        dataIndex: "approveTypeName",
        key: "approveTypeName"
      },
      {
        title: "社团",
        dataIndex: ["clubFinance", "clubName"],
        key: ["clubFinance", "clubName"]
      },
      {
        title: "申请人",
        dataIndex: "applyPersonName",
        key: "applyPersonName"
      },
      {
        title: "审批方式",
        dataIndex: "approveMethod",
        key: "approveMethod"
      },
      {
        title: "审批状态",
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
    ]
  }
})

// 查询表单state
const searchFormRef = ref()
const searchFormState = reactive({
  searchForm: {
    businessId: ""
  }
})
// 重置查询表单
const initSearchForm = () => {
  searchFormState.searchForm.businessId = ""
  cleanDetailData()
  searchData()
}

const settingTableActiveKeyChange = (activityKey) => {
  switch (activityKey) {
    case "1":
      // 社团申请
      tableState.code = enumsConfig.approveSetting.code[0].value
      tableState.columns = state.tableColumns.clubApply
      break
    case "2":
      // 社团活动申请
      tableState.code = enumsConfig.approveSetting.code[1].value
      tableState.columns = state.tableColumns.clubActivityApply
      break
    case "3":
      // 社团活动经费申请
      tableState.code = enumsConfig.approveSetting.code[2].value
      tableState.columns = state.tableColumns.clubFinance
      break
    case "4":
      // 社团活动经费申请
      tableState.code = enumsConfig.approveSetting.code[3].value
      tableState.columns = state.tableColumns.dissolveClubApply
      break
    default:
  }
  searchData()
}

// table state
const tableState = reactive({
  code: enumsConfig.approveSetting.code[0].value,
  selectedIds: [],
  columns: state.tableColumns.clubApply,
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

  // 查询数据
  searchDetailData()
}
const customRow = (record) => {
  return {
    onClick: () => {
      selectRow(record)
    }
  }
}

// 查询数据
const searchData = () => {
  tableState.loading = true
  const params = {
    pageNum: paginationState.current,
    pageSize: paginationState.pageSize,
    type: props.type,
    code: tableState.code,
    ...searchFormState.searchForm
  }
  approveRecordApi
    .listApproveRecordPage(params)
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

// 批量删除
const delBatch = (idList) => {
  const params = []
  idList.forEach((item) => {
    params.push(item)
  })

  approveRecordApi
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

// 驳回活动
const revertActivityApply = (approveRecordId) => {
  const params = {
    approveRecordId
  }
  approveRecordApi
    .revertActivityApply(params)
    .then(({ data }) => {
      if (data.code === 200) {
        searchData()
        message.success(data.message)
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("驳回失败")
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

// 查询详情数据
const searchDetailData = () => {
  detailTableState.loading = true
  const params = {
    pageNum: detailPaginationState.current,
    pageSize: detailPaginationState.pageSize,
    approveRecordId: tableState.selectedIds[0]
  }
  approveRecordDetailApi
    .listApproveRecordDetailPage(params)
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
      title: "审批状态",
      dataIndex: "status",
      key: "status"
    },
    {
      title: "备注",
      dataIndex: "remark",
      key: "remark"
    },
    {
      title: "创建时间",
      dataIndex: "createTime",
      key: "createTime"
    }
  ],
  loading: false,
  dataList: []
})

const cleanDetailData = () => {
  tableState.selectedIds = []
  detailTableState.dataList = []
}

// 审批state
const approveFormRef = ref()
const approveState = reactive({
  title: "审批",
  visible: false,
  confirmLoading: false,
  formData: {
    // 审批记录id
    approveRecordId: "",
    // 审批意见
    result: 1,
    // 备注，拒绝时必填拒绝原因
    remark: ""
  }
})
const initApproveForm = () => {
  approveState.formData.approveRecordId = ""
  approveState.formData.result = 1
  approveState.formData.remark = ""
}

// 去审批
const toApprove = (record) => {
  initApproveForm()
  approveState.formData.approveRecordId = record.id
  approveState.visible = true
}

// 新增或修改
const approve = () => {
  approveFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...approveState.formData
      }
      approveRecordApi
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
