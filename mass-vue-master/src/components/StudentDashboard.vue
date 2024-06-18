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

        <a-col :span="8" v-if="state.isLeader">
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
                  @focus="listCurrentUserClub"
                  :options="state.currentUserClubList"
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

        <a-col :span="8">
          <a-card title="日历">
            <a-calendar v-model:value="state.calendarValue" :fullscreen="false" />
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
import clubNoticeApi from "@/api/notice/sysNoticeApi.js"
import clubApi from "@/api/club/clubApi.js"
import dashboardApi from "@/api/dashboard/dashboardApi.js"

onMounted(() => {
  isClubLeader()
  getStudentDashboard()
  listRecentlySystemNotice()
  listCurrentUserClub()
})

const state = reactive({
  isLeader: false,
  recentlySystemNotice: [],
  currentUserClubList: [],
  calendarValue: ""
})

// 查询学生仪表盘数据
const getStudentDashboard = () => {
  dashboardApi
    .getStudentDashboard()
    .then(({ data }) => {
      if (data.code === 200) {
        dataList[0].value = data.data.clubCount
        dataList[1].value = data.data.activityCount
        dataList[2].value = data.data.joinActivityCount
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
    tooltip: "已加入的社团数量"
  },
  {
    id: 2,
    value: 0,
    title: "活动数量",
    tooltip: "已加入的社团活动数量"
  },
  {
    id: 3,
    value: 0,
    title: "参加活动数量",
    tooltip: "已参加的社团活动数量"
  }
])
</script>

<style scoped></style>
