<template>
  <a-popover :trigger="trigger" v-model:visible="visible">
    <template #title>
      <a-input-search
        v-model:value="searchValue"
        placeholder="输入英文关键词进行搜索"
        @change="filterIcon"
      />
    </template>

    <template #content>
      <div class="icon-box">
        <div
          v-for="(item, index) in iconArr"
          :key="index"
          @click="handleClick(item)"
          class="icon-content"
          :style="{ background: icon === item ? '#268961' : '' }"
        >
          <AntIcon :icon="item" />
        </div>
      </div>
    </template>
    <slot name="iconSelect"></slot>
  </a-popover>
</template>

<script>
import { ref, watch } from "vue"
import icons from "../utils/icons.json"
import { AntIcon } from "../utils/AntIcon.js"

export default {
  name: "IconPicker",
  components: { AntIcon },
  props: {
    icon: {
      type: String,
      required: true
    },
    trigger: {
      type: String,
      default: "click",
      validator(value) {
        return ["click", "hover", "focus"].indexOf(value) !== -1
      }
    }
  },
  setup(props, context) {
    const iconArr = ref(icons)
    const visible = ref(false)
    const searchValue = ref("")

    const handleClick = (icon) => {
      context.emit("update:icon", icon)
      visible.value = false
    }

    /**
     * 进行搜索过滤
     */
    const filterIcon = () => {
      if (searchValue.value) {
        iconArr.value = icons.filter((item) =>
          item.toLowerCase().includes(searchValue.value.toLowerCase())
        )
      } else {
        iconArr.value = icons
      }
    }

    watch(visible, () => {
      searchValue.value = ""
      iconArr.value = icons
    })

    return {
      visible,
      iconArr,
      handleClick,
      searchValue,
      filterIcon
    }
  }
}
</script>

<style scoped>
.icon-box {
  overflow: auto;
  font-size: 20px;
  width: 250px;
  height: 230px;
  display: flex;
  flex-wrap: wrap;
  flex-direction: row;
  align-content: flex-start;
  justify-content: center;
}

.icon-content {
  width: 45px;
  height: 40px;
  margin: 5px;
  cursor: pointer;
  text-align: center;
  border-radius: 6px;
  border: 1px solid #ccc;
}

.icon-content:hover {
  background: #1890ff;
}
</style>
