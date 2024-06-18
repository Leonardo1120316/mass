<template>
  <!--学生仪表盘-->
  <student-dashboard v-if="userStore.userInfo.role === 'student'" />

  <!--老师仪表盘-->
  <teacher-dashboard v-else-if="userStore.userInfo.role === 'teacher'" />

  <!--管理员仪表盘-->
  <admin-dashboard v-else-if="userStore.userInfo.role === 'admin'" />
</template>

<script setup>
import StudentDashboard from "@/components/StudentDashboard.vue"
import { useUserStore } from "@/store/modules/userInfo.js"
import TeacherDashboard from "@/components/TeacherDashboard.vue"
import AdminDashboard from "@/components/AdminDashboard.vue"

const userStore = useUserStore()
</script>

<style scoped></style>
