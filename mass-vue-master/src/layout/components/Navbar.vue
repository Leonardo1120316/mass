<template>
  <div class="main">
    <div class="left">
      <slot name="left" />
    </div>

    <div class="center">
      <slot />
      <slot name="center" />
    </div>

    <div class="right">
      <slot name="right" />
    </div>
  </div>
</template>

<script setup></script>

<style scoped>
.main {
  width: 100%;
  height: 100%;
  display: flex;
  box-sizing: border-box;
}

.left {
  height: 100%;
  display: flex;
}

.center {
  height: 100%;
  flex: 1 1 0;
}

.right {
  height: 100%;
  display: flex;
  flex-shrink: 0;
  align-items: center;
  gap: 12px;
  margin-right: 16px;
}
</style>
