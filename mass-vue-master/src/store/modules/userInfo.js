import { defineStore } from "pinia"
import { lStorage } from "@/utils/cache/index.js"

export const useUserStore = defineStore("user", {
  state: () => {
    return {
      token: null,
      userInfo: {}
    }
  },
  getters: {
    getToken() {
      return this.token
    },
    getUserInfo() {
      return this.userInfo
    }
  },
  actions: {
    setToken(token) {
      this.token = token
      lStorage.set("token", token)
    },
    setUserInfo(userInfo) {
      this.userInfo = userInfo
    }
  },
  persist: true
})
