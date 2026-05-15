# 階段 1: 建置環境 (Build Stage)
FROM node:22-alpine as build-stage

WORKDIR /app

# 先複製 package.json 以安裝相依套件
COPY package*.json ./
RUN npm install

# 複製所有程式碼並開始編譯
COPY . .
RUN npm run build

# 階段 2: 生產環境 (Production Stage)
FROM nginx:stable-alpine as production-stage

# 從第一階段複製編譯好的 dist 資料夾到 Nginx 的預設目錄
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 複製自定義 Nginx 設定
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
