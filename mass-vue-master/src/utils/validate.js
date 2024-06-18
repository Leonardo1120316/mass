/**
 * @description 验证手机号
 * @param value
 * @returns {boolean}
 */
export function isPhone(value) {
  const reg = /^1[3,4,5,6,7,8,9]\d{9}$/
  return reg.test(value)
}

/**
 * @description 验证邮箱
 * @param value
 * @returns {boolean}
 */
export function isEmail(value) {
  const reg = /^\w{3,}(\.\w+)*@[A-z0-9]+(\.[A-z]{2,5}){1,2}$/
  return reg.test(value)
}

/**
 * @description 校验密码  密码(以字母或数字开头，长度在6~18之间)
 * @param value
 * @returns {boolean}
 */
export function isPassWord(value) {
  const reg = /^[A-Za-z0-9]{5,17}$/
  return reg.test(value)
}

/**
 * @description 校验密码  密码(以字母开头，长度在6~18之间，只能包含字母、数字和下划线)
 * @param value
 * @returns {boolean}
 */
export function checkPassWord(value) {
  const reg = /^[a-zA-Z]\w{5,17}$/
  return reg.test(value)
}

/**
 * @description 校验验证码格式
 * @param value
 * @returns {boolean}
 */
export function isCode(value) {
  const reg = /^\d{6}$/
  return reg.test(value)
}

/**
 * @param {string} path
 * @returns {Boolean}
 */
export function isExternal(path) {
  return /^(https?:|mailto:|tel:)/.test(path)
}
