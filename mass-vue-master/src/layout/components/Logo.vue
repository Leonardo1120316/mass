<template>
  <div class="logo" @click="toHome()">
    <a-button type="text" style="color: white">
      {{ title }}
    </a-button>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router"
import { computed } from "vue"
import { useSettingsStore } from "@/store/modules/settings.js"
import { defaultConfig } from "@/config/config.js"

const router = useRouter()
const settingsStore = useSettingsStore()

const title = computed(() => {
  if (settingsStore.collapsed) {
    return defaultConfig.shortProjectName
  }
  return defaultConfig.projectName
})

const toHome = () => {
  settingsStore.changeSelectedKeys("/")
  router.push("/")
}
</script>

<style scoped>
.logo {
  margin: 15px;
}
</style>
