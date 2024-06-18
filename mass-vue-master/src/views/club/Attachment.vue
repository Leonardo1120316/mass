<template>
  <a-card>
    <a-form
      layout="inline"
      :model="searchFormState"
      autocomplete="off"
      @finish="listAttachmentPage"
    >
      <a-form-item label="关键词" name="searchKey">
        <a-input v-model:value="searchFormState.searchKey" />
      </a-form-item>

      <a-form-item>
        <a-button type="primary" html-type="submit">查询</a-button>
        <a-button @click="initSearchForm" class="ml-4">重置</a-button>
      </a-form-item>
    </a-form>

    <div class="flex mt-4">
      <a-button type="primary" @click="showUpload">
        <template #icon>
          <cloud-upload-outlined />
        </template>
        上传
      </a-button>
      <!--<a-button type="primary" class="ml-4"> 全选</a-button>-->
      <!--<a-button type="primary" danger class="ml-4"> 删除</a-button>-->
      <!--<a-button class="ml-4"> 取消</a-button>-->
    </div>
  </a-card>

  <!-- 数据 -->
  <div class="mt-4 ml-4">
    <a-card>
      <a-list
        :grid="{ gutter: 14, column: 5 }"
        :pagination="paginationState"
        :data-source="state.dataList"
      >
        <template #renderItem="{ item }">
          <a-list-item>
            <a-card :title="item.name" hoverable>
              <template #extra>
                <a-button type="link" @click="downloadAttachment(item)">下载</a-button>
              </template>

              <div class="list-card" @click="toShowAttachmentDetail(item)">
                <img class="list-card-img" :alt="item.name" :src="item.accessUrl" />
              </div>
            </a-card>
          </a-list-item>
        </template>
      </a-list>
    </a-card>
  </div>

  <!-- 上传弹窗 -->
  <a-modal
    title="上传附件"
    v-model:visible="state.showUpload"
    :footer="null"
    :afterClose="closeModal"
  >
    <a-steps :current="attachmentState.currentStep">
      <a-step title="选择社团" />
      <a-step title="上传附件" />
    </a-steps>

    <div v-if="attachmentState.currentStep === 1" class="mt-4" style="margin-bottom: 16px">
      请选择社团：
      <a-select
        style="width: 220px"
        show-search
        v-model:value="attachmentState.clubId"
        :field-names="{ label: 'name', value: 'id' }"
        :options="state.currentUserClubList"
      ></a-select>
    </div>

    <file-pond
      v-else-if="attachmentState.currentStep === 2"
      name="file"
      ref="pondRef"
      label-idle="点击选择文件或将文件拖拽到此处"
      allow-multiple="true"
      allowRevert="false"
      :server="pondOptions.server"
      labelFileLoadError="上传失败"
      labelFileProcessingComplete="上传成功"
      labelFileProcessing="上传中"
      labelFileProcessingError="上传失败"
      labelTapToCancel="点击取消"
      labelTapToRetry="点击重试"
    />

    <div>
      <a-button v-if="attachmentState.currentStep === 1" type="primary" @click="nextStep">
        下一步
      </a-button>
      <a-button
        v-if="attachmentState.currentStep === 2"
        style="margin-left: 8px"
        @click="attachmentState.currentStep--"
      >
        上一步
      </a-button>
    </div>
  </a-modal>

  <!-- 附件详情弹窗 -->
  <a-modal title="附件详情" v-model:visible="state.showAttachmentDetail">
    <a-list item-layout="horizontal" :data-source="state.currentAttachment">
      <template #renderItem="{ item }">
        <a-list-item>
          <a-list-item-meta>
            <template #title>
              附件名：
              <edit-two-tone @click="toEditName" />
            </template>

            <template #description>
              <template v-if="!editFileNameState.editable.editing">
                {{ item.name }}
              </template>
              <a-typography-paragraph
                v-else
                v-model:content="item.name"
                :editable="editFileNameState.editable"
              >
              </a-typography-paragraph>
            </template>
          </a-list-item-meta>
        </a-list-item>

        <a-list-item>
          <a-list-item-meta>
            <template #title>附件类型：</template>
            <template #description>{{ item.mediaType }}</template>
          </a-list-item-meta>
        </a-list-item>

        <a-list-item>
          <a-list-item-meta>
            <template #title>附件大小：</template>
            <template #description>{{ item.size }}</template>
          </a-list-item-meta>
        </a-list-item>

        <a-list-item>
          <a-list-item-meta>
            <template #title>上传日期：</template>
            <template #description>{{ item.createTime }}</template>
          </a-list-item-meta>
        </a-list-item>

        <a-list-item>
          <a-list-item-meta>
            <template #title>
              普通链接：
              <copy-two-tone @click="copyText(item.accessUrl)" />
            </template>
            <template #description>
              <a :href="item.accessUrl" target="_blank">{{ item.accessUrl }}</a>
            </template>
          </a-list-item-meta>
        </a-list-item>
      </template>
    </a-list>

    <template #footer>
      <a-popconfirm
        title="确定删除该附件?"
        ok-text="确定"
        cancel-text="取消"
        @confirm="deleteAttachment(state.currentAttachment[0])"
      >
        <a-button type="primary" danger>删除</a-button>
      </a-popconfirm>
    </template>
  </a-modal>
</template>

<script setup>
import { onMounted, reactive, ref } from "vue"
import { CloudUploadOutlined, EditTwoTone, CopyTwoTone } from "@ant-design/icons-vue"
import { useClipboard } from "@vueuse/core"
import { message } from "ant-design-vue"
import { saveAs } from "file-saver"
import { useUserStore } from "@/store/modules/userInfo.js"
import clubAttachmentApi from "@/api/club/clubAttachmentApi.js"

import vueFilePond from "vue-filepond"
// Import image preview and file type validation plugins
import FilePondPluginFileValidateType from "filepond-plugin-file-validate-type"
import FilePondPluginImagePreview from "filepond-plugin-image-preview"
// Import styles
import "filepond/dist/filepond.min.css"
import "filepond-plugin-image-preview/dist/filepond-plugin-image-preview.min.css"
import clubApi from "@/api/club/clubApi.js"
// Create FilePond component
const FilePond = vueFilePond(FilePondPluginFileValidateType, FilePondPluginImagePreview)

onMounted(() => {
  listAttachmentPage()
})

const { copy } = useClipboard()

const userStore = useUserStore()

const state = reactive({
  showUpload: false,
  showAttachmentDetail: false,
  dataList: [],
  // 当前附件
  currentAttachment: [],
  currentUserClubList: []
})

// 编辑文件名state
const editFileNameState = reactive({
  editable: {
    editing: false,
    triggerType: ["text"],
    onEnd() {
      console.log("更新文件名")
      editFileNameState.editable.editing = false
    }
  }
})

const searchFormState = reactive({
  searchKey: ""
})

const initSearchFormData = () => {
  searchFormState.searchKey = ""
}

// 初始化查询表达
const initSearchForm = () => {
  initSearchFormData()
  listAttachmentPage()
}

// 分页查询附件
const listAttachmentPage = () => {
  const params = {
    pageNum: paginationState.current,
    pageSize: paginationState.pageSize,
    ...searchFormState
  }

  clubAttachmentApi
    .listClubAttachmentPage(params)
    .then(({ data }) => {
      if (data.code === 200) {
        state.dataList = data.data.records

        paginationState.current = data.data.current
        paginationState.pageSize = data.data.size
        paginationState.total = data.data.total
      } else {
        message.error(data.message)
      }
    })
    .catch((err) => {
      console.log(err)
    })
}

const attachmentState = reactive({
  currentStep: 1,
  clubId: ""
})

const nextStep = () => {
  if (!attachmentState.clubId) {
    message.error("请选择社团！")
  } else {
    attachmentState.currentStep += 1
  }
}

const pondRef = ref()
const pondOptions = reactive({
  server: {
    url: import.meta.env.VITE_APP_BASE_URL,
    timeout: 7000,
    process: {
      url: "/clubAttachment/uploadAttachment",
      method: "POST",
      headers: {
        Authorization: `Bearer ${userStore.getToken}`
      },
      onload: (response) => {
        const resData = JSON.parse(response)
        // if (resData.code !== 200) {
        // }
      },
      onerror: (response) => {
        const resData = JSON.parse(response)
        message.error(resData.message)
      },
      ondata: (formData) => {
        formData.append("clubId", attachmentState.clubId)
        return formData
      }
    },
    load: {}
  }
})

const showUpload = () => {
  listCurrentUserClub()

  state.showUpload = true
}

const closeModal = () => {
  pondRef.value?.removeFiles()
  attachmentState.currentStep = 1
  listAttachmentPage()
}

const toEditName = () => {
  editFileNameState.editable.editing = true
}

const copyText = (text) => {
  copy(text)
  message.success("复制成功")
}

const toShowAttachmentDetail = (attachment) => {
  state.currentAttachment[0] = attachment
  state.showAttachmentDetail = true
}

// 下载附件
const downloadAttachment = (item) => {
  let params = {
    fileName: item.originalName,
    filePath: item.filePath
  }
  clubAttachmentApi
    .downloadAttachment(params)
    .then((res) => {
      const blob = res.data
      console.log("blob", blob)
      if (blob.type === "application/json;charset=utf-8" || blob.type === "application/json") {
        blob.text().then((text) => {
          // 将字符串转换为 JSON
          const data = JSON.parse(text)
          message.error(data.message)
        })
      } else {
        saveAs(blob, item.originalName)
      }
    })
    .catch((err) => {
      console.log(err)
    })
}
const deleteAttachment = (item) => {
  clubAttachmentApi
    .deleteAttachment(item.id)
    .then((res) => {
      const { data } = res
      if (data.code === 200) {
        state.showAttachmentDetail = false
        listAttachmentPage()
        message.success("删除成功")
      } else {
        message.success("失败成功")
      }
    })
    .catch((err) => {
      console.log(err)
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

// 分页
const paginationState = reactive({
  // 当前页数
  current: 1,
  // 默认每页条数 默认10
  defaultPageSize: 20,
  // 禁用分页
  // disabled: true,
  // 每页条数
  pageSize: 10,
  // 指定每页可以显示多少条
  pageSizeOptions: ["10", "20", "30", "40"],
  // 数据总数
  total: 20,
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
    listAttachmentPage()
  }
})
</script>

<style scoped>
.list-card {
  height: 120px;
  overflow: hidden;
}

.list-card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
