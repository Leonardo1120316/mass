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

      <a-form-item label="社团类型" name="clubType">
        <a-select
          style="width: 200px"
          v-model:value="searchFormState.searchForm.clubType"
          :field-names="{ label: 'name', value: 'code' }"
          @focus="listAllClubType"
          :options="state.clubTypeList"
        />
      </a-form-item>

      <a-form-item>
        <a-button type="primary" html-type="submit">搜索</a-button>
        <a-button @click="initSearchForm" class="ml-4">重置</a-button>
      </a-form-item>
    </a-form>
  </a-card>

  <div class="mt-4">
    <a-card title="活动列表">
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
            <template v-if="column.key === 'status'">
              <a-tag :color="filters.getClubStatus(record.status).color">
                {{ filters.getClubStatus(record.status).label }}
              </a-tag>
            </template>

            <!--操作-->
            <template v-if="column.key === 'action'">
              <span>
                <!--<a @click="toUpdate(record)">审核</a>-->
              </span>
            </template>
          </template>
        </a-table>
      </div>
    </a-card>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue"
import { message } from "ant-design-vue"
import { filters } from "@/config/filters.js"
import clubApi from "@/api/club/clubApi.js"
import clubTypeApi from "@/api/club/clubTypeApi.js"

onMounted(() => {
  searchData()
})

const state = reactive({
  clubTypeList: []
})

// 查询所有社团类型
const listAllClubType = () => {
  clubTypeApi
    .listAllClubType()
    .then(({ data }) => {
      if (data.code === 200) {
        state.clubTypeList = data.data
      } else {
        message.error(data.message)
      }
    })
    .catch((err) => {
      console.log(err)
    })
}

// 查询表单state
const searchFormRef = ref()
const searchFormState = reactive({
  searchForm: {
    clubName: "",
    clubType: ""
  }
})
// 重置查询表单
const initSearchForm = () => {
  searchFormState.searchForm.clubName = ""
  searchFormState.searchForm.clubType = ""
  searchData()
}

// table state
const tableState = reactive({
  columns: [
    {
      title: "社团类型",
      dataIndex: "typeName",
      key: "typeName"
    },
    {
      title: "社团名称",
      dataIndex: "name",
      key: "name"
    },
    {
      title: "社长",
      dataIndex: "leader",
      key: "leader"
    },
    {
      title: "社团描述",
      dataIndex: "description",
      key: "description"
    },
    {
      title: "创建时间",
      dataIndex: "createTime",
      key: "createTime"
    },
    {
      title: "社团人数",
      dataIndex: "memberCount",
      key: "memberCount"
    },
    {
      title: "状态",
      dataIndex: "status",
      key: "status"
    }
  ],
  loading: false,
  dataList: []
})

// 查询数据
const searchData = () => {
  tableState.loading = true
  const params = {
    pageNum: paginationState.current,
    pageSize: paginationState.pageSize,
    ...searchFormState.searchForm
  }
  clubApi
    .listClubInfoPage(params)
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
