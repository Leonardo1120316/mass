import { defineStore } from "pinia"

export const useSettingsStore = defineStore("settings", {
  state: () => {
    return {
      // 是否折叠菜单栏
      collapsed: false,
      // 菜单选中项
      selectedKeys: ["/"],
      openKeys: ["/"],
      tagList: [{ name: "仪表盘", path: "/", closable: false }]
    }
  },
  getters: {
    getSelectedKeys() {
      return this.selectedKeys
    }
  },
  actions: {
    saveTag(tab) {
      if (this.tagList.findIndex((item) => item.path === tab.path) === -1) {
        this.tagList.push({
          name: tab.name,
          path: tab.path,
          closable: tab.meta.closable
        })
      }
    },
    changeSelectedKeys(selectedKeys) {
      this.selectedKeys = [selectedKeys]
    },
    checkCollapsed() {
      this.collapsed = !this.collapsed
    }
  },
  persist: true
})
