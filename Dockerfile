FROM node:22 AS builder
WORKDIR /app
COPY package*.json ./
 RUN npm ci
COPY src ./src
RUN npm run build

# Estágio 2: imagem de execução enxuta, sem código-fonte de desenvolvimento
FROM node:22-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /apps
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=builder --chown=node:node /app/dist ./dist
USER node
EXPOSE 3000
CMD ["node", "dist/server.js"]