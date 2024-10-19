#!/usr/bin/env bash
# 定义应用组名
group_name='kcaco'
# 定义应用名称
app_name='kcaco-blog-boot-prod'
# 定义应用环境
profile_active='prod'
# 定义应用版本
app_version='latest'

# 停止docker容器
echo '----stop container----'
docker stop ${app_name}

# 删除docker容器
echo '----rm container----'
docker rm ${app_name}

# 删除docker镜像
echo '----rm image----'
docker rmi ${group_name}/${app_name}:${app_version}

# 打包编译docker镜像
echo '----build image----'
docker build -t ${group_name}/${app_name}:${app_version} .

# 启动docker容器
echo '----start container----'
docker run -p 8070:8070 --name ${app_name} \
-e 'spring.profiles.active'=${profile_active} \
-e TZ="Asia/Shanghai" \
-v /etc/localtime:/etc/localtime \
-v /data/app/${app_name}/logs:/var/logs \
-d ${group_name}/${app_name}:${app_version}

echo '----success----'