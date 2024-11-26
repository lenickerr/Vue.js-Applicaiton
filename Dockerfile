# build stage
FROM node:lts-alpine AS build-stage
WORKDIR /chart-project
COPY package*.json ./
RUN npm config set registry https://registry.npmjs.org/ && npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine AS production-stage
COPY --from=build-stage /chart-project/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
