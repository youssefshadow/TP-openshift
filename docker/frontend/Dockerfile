FROM node:18-alpine AS build
WORKDIR /app

ENV NODE_ENV=production

COPY package.json package-lock.json* ./
RUN npm ci --silent --include=dev

COPY . .
RUN npx ng build --output-path=dist --configuration production

FROM nginxinc/nginx-unprivileged:1.25-alpine
COPY docker/frontend/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
USER 101
CMD ["nginx", "-g", "daemon off;"]
