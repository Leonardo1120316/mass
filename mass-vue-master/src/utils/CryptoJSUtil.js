import CryptoJS from "crypto-js"
import { defaultConfig } from "../config/config.js"

// 16位16进制key.
const key = CryptoJS.enc.Utf8.parse(defaultConfig.AES_CBC.key)
const iv = CryptoJS.enc.Utf8.parse(defaultConfig.AES_CBC.iv)

const crypto = {
  /**
   * 解密方法.
   *
   * @param {String} text 待解密文本
   * @returns 解密结果
   */
  Decrypt(text) {
    const encrypted = CryptoJS.AES.decrypt(text, key, {
      iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.Pkcs7
    })
    return encrypted.toString(CryptoJS.enc.Utf8)
  },

  /**
   * 加密方法.
   *
   * @param {String} text 待加密文本
   * @returns 加密结果
   */
  Encrypt(text) {
    const encrypted = CryptoJS.AES.encrypt(text, key, {
      iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.Pkcs7
    })
    return encrypted.ciphertext.toString(CryptoJS.enc.Base64)
  }
}
export default crypto
