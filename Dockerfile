# Build Stage : Typescript Compilation
FROM node:16-alpine3.14 AS builder

WORKDIR /app

COPY package*.json ./
COPY tsconfig*.json ./
COPY ./src ./
RUN npm ci --cache .npm --prefer-offline && \
 npm run build

# Build Production Stage : Node Modules
FROM node:16-alpine3.14 as production-builder

WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
COPY --from=builder /app/.npm .npm
RUN npm ci --cache .npm --prefer-offline --quiet --only=production

# Production Stage
FROM node:16-alpine3.14 as production

USER node
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=8080
EXPOSE ${PORT}

COPY package*.json ./
COPY --from=builder --chown=node:node /app/dist ./dist
COPY --from=production-builder --chown=node:node /app/node_modules ./node_modules

CMD [ "node", "dist/main" ]
