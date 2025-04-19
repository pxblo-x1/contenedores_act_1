# Etapa 1: build de la app
FROM node:22.14.0-bookworm-slim AS builder

WORKDIR /app
COPY . .
RUN npm install && npm run build

# Etapa 2: nginx para servir archivos estáticos
FROM nginx:alpine

# Elimina configuración default
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
