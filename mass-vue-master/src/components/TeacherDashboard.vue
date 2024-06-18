<template>
  <div class="m-4">
    <div>
      <a-row :gutter="18">
        <a-col :span="8" v-for="item of dataList" :key="item.id">
          <a-card>
            <a-statistic :value="item.value">
              <template #title>
                <span>{{ item.title }}</span>

                <a-tooltip>
                  <template #title>
                    <span>{{ item.tooltip }}</span>
                  </template>
                  <info-circle-outlined style="margin-left: 3px" />
                </a-tooltip>
              </template>
            </a-statistic>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <div class="mt-4">
      <a-row :gutter="20">
        <a-col :span="8">
          <a-card>
            <template #title>
              <span>通知</span>
            </template>

            <a-timeline mode="left">
              <template v-if="state.recentlySystemNotice.length > 0">
                <a-timeline-item v-for="notice in state.recentlySystemNotice" :key="notice.id">
                  <p>{{ notice.createTime }}</p>
                  <a-card size="small" hoverable>
                    <template #title>
                      <span>{{ notice.title }}</span>
                    </template>
                    {{ notice.content }}
                  </a-card>
                </a-timeline-item>
              </template>

              <template v-else>
                <a-empty />
              </template>
            </a-timeline>
          </a-card>
        </a-col>

        <a-col :span="8">
          <a-card>
            <a-card title="社团经费">
              <div ref="main" style="width: 100%; height: 400px"></div>
            </a-card>
          </a-card>
        </a-col>

        <a-col :span="8">
          <a-card>
            <template #title>
              <span>发布通知</span>
            </template>

            <a-form ref="noticeFormRef" :model="noticeFormState.formData" @finish="saveClubNotice">
              <a-form-item
                label="社团"
                name="clubId"
                :rules="[{ required: true, message: '请选择社团!' }]"
              >
                <a-select
                  show-search
                  v-model:value="noticeFormState.formData.clubId"
                  :field-names="{ label: 'name', value: 'id' }"
                  @focus="listAllClub"
                  :options="state.clubDataList"
                ></a-select>
              </a-form-item>

              <a-form-item
                label="标题"
                name="title"
                :rules="[{ required: true, message: '请输入标题!' }]"
              >
                <a-input v-model:value="noticeFormState.formData.title" />
              </a-form-item>

              <a-form-item
                label="内容"
                name="content"
                :rules="[{ required: true, message: '请输入内容!' }]"
              >
                <a-textarea
                  v-model:value="noticeFormState.formData.content"
                  placeholder="通知内容，不超过255字"
                  :allowClear="true"
                  size="large"
                  :showCount="true"
                  :maxlength="255"
                  :minRows="8"
                  :rows="8"
                />
              </a-form-item>

              <a-form-item>
                <a-button type="primary" html-type="submit">发布</a-button>
                <a-button @click="initNoticeForm" class="ml-4">重置</a-button>
              </a-form-item>
            </a-form>
          </a-card>
        </a-col>
      </a-row>
    </div>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue"
import { InfoCircleOutlined } from "@ant-design/icons-vue"
import { message } from "ant-design-vue"
import * as echarts from "echarts"
import clubNoticeApi from "@/api/notice/sysNoticeApi.js"
import clubApi from "@/api/club/clubApi.js"
import dashboardApi from "@/api/dashboard/dashboardApi.js"
import clubUserApi from "@/api/club/clubUserApi.js"
import clubFinanceApi from "@/api/club/clubFinanceApi.js"

onMounted(() => {
  getTeacherDashboard()
  listRecentlySystemNotice()
  initEcharts()
})

const state = reactive({
  recentlySystemNotice: [],
  clubDataList: []
})

// 查询老师仪表盘数据
const getTeacherDashboard = () => {
  dashboardApi
    .getTeacherDashboard()
    .then(({ data }) => {
      if (data.code === 200) {
        dataList[0].value = data.data.clubCount
        dataList[1].value = data.data.activityCount
        dataList[2].value = data.data.waitApproveCount
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("查询仪表盘数据失败")
    })
}

// 获取最近五条系统通知
const listRecentlySystemNotice = () => {
  dashboardApi
    .listRecentlySystemNotice()
    .then(({ data }) => {
      if (data.code === 200) {
        state.recentlySystemNotice = data.data
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("查询最近五条系统通知失败")
    })
}

// 查询所有正常社团列表
const listAllClub = () => {
  const params = {
    status: enumsConfig.club.status[0].value
  }

  clubApi
    .listAllClub(params)
    .then(({ data }) => {
      if (data.code === 200) {
        state.clubDataList = data.data
      } else {
        message.error(data.message)
      }
    })
    .catch(() => {
      message.error("查询当前用户所在社团列表失败")
    })
}

// 发布通知表单state
const noticeFormRef = ref()
const noticeFormState = reactive({
  confirmLoading: false,
  formData: {
    clubId: "",
    type: "club",
    title: "",
    content: ""
  }
})
// 重置通知表单
const initNoticeForm = () => {
  noticeFormRef.value?.clearValidate()
  noticeFormState.formData.clubId = ""
  noticeFormState.formData.type = "club"
  noticeFormState.formData.title = ""
  noticeFormState.formData.content = ""
}
// 保存通知
const saveClubNotice = () => {
  noticeFormRef.value
    .validate()
    .then(() => {
      const params = {
        ...noticeFormState.formData
      }

      clubNoticeApi
        .saveOrUpdateNotice(params)
        .then(({ data }) => {
          if (data.code === 200) {
            message.success(data.message)
            initNoticeForm()
            listRecentlySystemNotice()
          } else {
            message.error(data.message)
          }
          noticeFormState.confirmLoading = false
        })
        .catch(() => {
          noticeFormState.confirmLoading = false
          message.error("发布失败")
        })
    })
    .catch(() => {
      noticeFormState.confirmLoading = false
      message.error("请检查表单项")
    })
}

const dataList = reactive([
  {
    id: 1,
    value: 0,
    title: "社团数量",
    tooltip: "社团数量"
  },
  {
    id: 2,
    value: 0,
    title: "活动数量",
    tooltip: "活动数量"
  },
  {
    id: 3,
    value: 0,
    title: "待审批",
    tooltip: "待审批数量"
  }
])

const main = ref()
const initEcharts = () => {
  const myChart = echarts.init(main.value)

  clubFinanceApi
    .getClubFinanceEcharts()
    .then(({ data }) => {
      if (data.code === 200) {
        const option = {
          title: {
            text: "社团经费",
            left: "center"
          },
          tooltip: {
            trigger: "item"
          },
          legend: {
            orient: "vertical",
            left: "left"
          },
          series: [
            {
              name: "审批通过的经费",
              type: "pie",
              radius: "50%",
              data: data.data,
              emphasis: {
                itemStyle: {
                  shadowBlur: 10,
                  shadowOffsetX: 0,
                  shadowColor: "rgba(0, 0, 0, 0.5)"
                }
              }
            }
          ]
        }
        myChart.hideLoading()
        myChart.setOption(option)
      } else {
        message.error(data.message)
      }
    })
    .catch((err) => {
      console.log(err)
    })
}
</script>

<style scoped></style>
