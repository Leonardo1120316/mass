<template>
  <div class="main">
    <div class="left">
      <a-card :title="formState.title">
        <a-form
          layout="vertical"
          :model="formState.formData"
          autocomplete="off"
          @finish="saveOrUpdate"
        >
          <a-form-item
            label="代码:"
            name="code"
            extra="* 一般为单个分类的标识，英文"
            :rules="[{ required: true, message: '请输入代码!' }]"
          >
            <a-input v-model:value="formState.formData.code"></a-input>
          </a-form-item>

          <a-form-item
            label="名称:"
            name="name"
            :rules="[{ required: true, message: '请输入名称!' }]"
          >
            <a-input v-model:value="formState.formData.name"></a-input>
          </a-form-item>

          <a-form-item
            label="描述:"
            name="description"
            :rules="[{ required: true, message: '请输入类型描述!' }]"
          >
            <a-textarea
              v-model:value="formState.formData.description"
              :rows="4"
              placeholder="最多200个字符"
              show-count
              :maxlength="200"
            />
          </a-form-item>

          <a-form-item>
            <a-button
              v-if="!formState.formData.id"
              :loading="formState.confirmLoading"
              type="primary"
              html-type="submit"
            >
              保存
            </a-button>
            <div v-else class="button">
              <div>
                <a-button type="primary" html-type="submit">更新</a-button>
                <a-button type="dashed" @click="backAdd">返回添加</a-button>
              </div>

              <div>
                <a-button type="primary" danger @click="deleteType(formState.id)">删除</a-button>
              </div>
            </div>
          </a-form-item>
        </a-form>
      </a-card>
    </div>

    <div class="right">
      <a-card title="所有社团类型">
        <template #extra>
          <a-button type="primary" @click="clearUnusedType" :loading="state.clearUnusedTypeLoading">
            清理未使用社团类型
          </a-button>
        </template>

        <a-tag v-for="type in state.data" :key="type.id" @click="toUpdate(type)">
          <a>{{ type.name }}({{ type.clubCount }}) </a>
        </a-tag>
      </a-card>
    </div>
  </div>
</template>

<script setup>
import { onMounted, reactive } from "vue"
import { message } from "ant-design-vue"
import clubTypeApi from "@/api/club/clubTypeApi.js"

onMounted(() => {
  searchData()
})

const state = reactive({
  data: [],
  clearUnusedTypeLoading: false
})

const formState = reactive({
  title: "添加社团类型",
  confirmLoading: false,
  formData: {
    id: "",
    code: "",
    name: "",
    description: ""
  }
})

const initFormData = () => {
  formState.formData.id = ""
  formState.formData.code = ""
  formState.formData.name = ""
  formState.formData.description = ""
}

// 查询所有
const searchData = () => {
  clubTypeApi
    .listAllClubType()
    .then(({ data }) => {
      if (data.code === 200) {
        state.data = data.data
      } else {
        message.error(data.message)
      }
    })
    .catch((err) => {
      console.log(err)
    })
}

// 保存或更新社团类型
const saveOrUpdate = () => {
  formState.confirmLoading = true

  const params = {
    ...formState.formData
  }
  clubTypeApi
    .saveOrUpdateClubType(params)
    .then(({ data }) => {
      if (data.code === 200) {
        formState.confirmLoading = false
        initFormData()
        searchData()
        message.success(data.message)
      } else {
        formState.confirmLoading = false
        message.error(data.message)
      }
    })
    .catch((err) => {
      formState.confirmLoading = false
      console.log(err)
    })
}

const toUpdate = (type) => {
  formState.title = "修改社团类型"

  formState.formData.id = type.id
  formState.formData.code = type.code
  formState.formData.name = type.name
  formState.formData.description = type.description
}

const backAdd = () => {
  formState.title = "添加社团类型"

  initFormData()
}

const deleteType = (id) => {
  console.log("删除tag")
}

const clearUnusedType = () => {
  state.clearUnusedTypeLoading = true

  clubTypeApi
    .clearUnusedType()
    .then(({ data }) => {
      if (data.code === 200) {
        state.clearUnusedTypeLoading = false
        message.success(data.message)
      } else {
        state.clearUnusedTypeLoading = false
        message.error(data.message)
      }
    })
    .catch((err) => {
      state.clearUnusedTypeLoading = false
    })

  searchData()
}
</script>

<style scoped>
.main {
  display: flex;
  margin-top: 16px;
  --tw-space-x-reverse: 0;
  margin-right: calc(1rem * var(--tw-space-x-reverse));
  margin-left: calc(1rem * calc(1 - var(--tw-space-x-reverse)));
}

.left {
  flex-basis: 33.333333%;
}

.right {
  margin-left: 16px;
  flex-basis: 66.666667%;
}

.button {
  display: flex;
  justify-content: space-between;
}
</style>
