FROM node:16-alpine as builder

WORKDIR /server

COPY src src
COPY .yarn/releases .yarn/releases
COPY .yarn/plugins .yarn/plugins
COPY .yarnrc.yml package.json yarn.lock tsconfig.json ./

RUN yarn && yarn build

FROM node:16-alpine

WORKDIR /server

COPY .yarn/releases .yarn/releases
COPY .yarn/plugins .yarn/plugins
COPY .yarnrc.yml package.json yarn.lock ./

RUN yarn workspaces focus --production

COPY --from=builder /server/dist dist

EXPOSE $PORT

ENTRYPOINT ["yarn", "start"]
CMD ["start"]
