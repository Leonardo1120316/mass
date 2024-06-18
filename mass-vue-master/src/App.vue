<template>
  <a-config-provider :locale="zhCN">
    <router-view />
  </a-config-provider>
</template>

<script setup>
import zhCN from "ant-design-vue/es/locale/zh_CN"
import dayjs from "dayjs"
import "dayjs/locale/zh-cn"

dayjs.locale("zh-cn")
</script>

<style>
.search-button-group {
  display: flex;
  margin-left: 8px;
}

.ml-4 {
  margin-left: 16px;
}

.mt-4 {
  margin-top: 16px;
}

.m-4 {
  margin: 16px;
}

.flex {
  display: flex;
}
</style>
