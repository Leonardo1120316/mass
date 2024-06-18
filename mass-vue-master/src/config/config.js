// 获取环境变量
const ENV = import.meta.env
// 配置文件
let config = {}

// 默认配置文件
const defaultConfig = {
  // 项目名
  projectName: ENV.VITE_APP_TITLE,
  // 项目名简称
  shortProjectName: ENV.VITE_SHORT_APP_TITLE,
  // Aes
  AES_CBC: {
    key: "ZXW0vV2gHgkAPAh0",
    iv: "d65MdZ67A9L3Rm0P"
  },
  BASE_URL: ENV.VITE_APP_BASE_URL
}

/**
 * @Author isboyjc
 * @Date 2022-09-17 14:35:02
 * @description 设置全局配置
 * @param {Object} cfg 配置项
 * @return {Object} 新的全局配置 config
 */
const setConfig = (cfg) => {
  config = Object.assign(config, cfg)
  return config
}

/**
 * @Author isboyjc
 * @Date 2022-09-17 14:35:02
 * @description 重置全局配置
 * @param {*}
 * @return {Object} 全局默认配置 configSource
 */
const resetConfig = () => {
  config = { ...defaultConfig }
  return config
}
resetConfig()

/**
 * @Author isboyjc
 * @Date 2022-09-17 14:35:02
 * @description 获取全局配置
 * @param {String} key 配置项，支持 'a.b.c' 的方式获取
 * @return {Object} 新的全局配置 config
 */
const getConfig = (key) => {
  if (typeof key === "string") {
    const arr = key.split(".")
    if (arr && arr.length) {
      let data = config
      arr.forEach((v) => {
        if (data && typeof data[v] !== "undefined") {
          data = data[v]
        } else {
          data = null
        }
      })
      return data
    }
  }
  if (Array.isArray(key)) {
    const data = config
    if (key && key.length > 1) {
      const res = {}
      key.forEach((v) => {
        if (data && typeof data[v] !== "undefined") {
          res[v] = data[v]
        } else {
          res[v] = null
        }
      })
      return res
    }
    return data[key]
  }
  return { ...config }
}

export { defaultConfig, getConfig, setConfig, resetConfig }
