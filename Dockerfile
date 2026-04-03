# 构建阶段
FROM node:10-alpine as build-stage

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install --registry=https://registry.npmjs.org

# 复制项目文件
COPY . .

# 构建项目（生产环境）
RUN npm run build:prod

# 生产阶段
FROM nginx:alpine as production-stage

# 复制自定义 nginx 配置（覆盖默认配置）
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 复制构建产物到 nginx 目录
COPY --from=build-stage /app/web /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]