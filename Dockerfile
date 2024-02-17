
# build stage
FROM node:16.17.1 as build

WORKDIR /app
COPY --chown=node:node package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build:dev
# when prod RUN npm run build:prod

# prod stage
FROM node:16.17.1
WORKDIR /app
ARG NODE_ENV=dev
ENV NODE_ENV=${NODE_ENV}
COPY --chown=node:node package.json package-lock.json ./
COPY --chown=node:node tsconfig.json ./
RUN npm install
COPY --chown=node:node --from=build /app/bin ./bin
COPY --chown=node:node --from=build /app/prisma ./prisma
COPY --chown=node:node --from=build /app/secrets ./secrets

EXPOSE 3000

CMD ["npm", "run", "start:dev"]
