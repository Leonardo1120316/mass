<template>
  <a-breadcrumb>
    <a-breadcrumb-item v-for="(item, index) of breadcrumbList" :key="item.path">
      <span v-if="index === breadcrumbList.length - 1">{{ item.meta.title }}</span>
      <router-link v-else :to="item.path" @click="changeSelect(item)">
        {{ item.meta.title }}
      </router-link>
    </a-breadcrumb-item>
  </a-breadcrumb>
</template>

<script setup>
import { useRoute, useRouter } from "vue-router"
import { computed, reactive } from "vue"
import { useSettingsStore } from "../../store/modules/settings.js"

const route = useRoute()
const router = useRouter()
const routes = router.getRoutes()

const settingsStore = useSettingsStore()

const breadcrumbList = computed(() => {
  let { matched } = route
  console.log("matched----before", matched)
  // 根据item.path去重，为了适配菜单单一目录
  // let matchedMap = new Map()
  // matched = matched.filter(item => !matchedMap.has(item.path) && matchedMap.set(item.path, 1));

  if (matched.length === 2) {
    const matchedMap = new Map()
    matched = matched.filter(
      (item) => !matchedMap.has(item.meta.title) && matchedMap.set(item.meta.title, 1)
    )
  }

  console.log("matched", matched)
  const first = matched[0]
  // 如果不是首页
  if (first && first.path !== "/") {
    matched = [{ path: "/", meta: { title: "首页" }, closable: false }].concat(matched)
  }
  // matched = [{ path: "/", meta: { title: "首页" }, closable: false }].concat(matched)
  // 保存当前页标签
  settingsStore.saveTag(route)
  return reactive(matched)
})

const changeSelect = (item) => {
  let { path } = item
  if (item.redirect) {
    path = getPathByRedirect(item)
  }
  settingsStore.changeSelectedKeys(path)
}

const getPathByRedirect = (preRoute) => {
  const nextRoute = routes.find((item) => item.path === preRoute.redirect)
  if (nextRoute) {
    return getPathByRedirect(nextRoute)
  }
  console.log("返回---", preRoute.path)
  return preRoute.path
}
</script>

<style scoped></style>
