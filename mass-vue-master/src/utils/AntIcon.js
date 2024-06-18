// Icon.js
import { createVNode } from "vue"
import * as $Icon from "@ant-design/icons-vue"

export const AntIcon = (props) => {
  const { icon } = props
  return createVNode($Icon[icon])
}
