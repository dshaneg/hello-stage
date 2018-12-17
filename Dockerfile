# ---- Base Node ----
FROM node:10.14.2-jessie AS base

# Create app directory
WORKDIR /app

# ----------------------
# ---- Dependencies ----
# ----------------------
FROM base AS dependencies

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN npm install

# ---------------
# ---- Build ----
# ---------------
FROM dependencies AS build
COPY src src/
COPY test test/

COPY .eslintrc.yaml ./
RUN npm run --silent lint

RUN npm run --silent test

RUN npm prune --production

# ----------------
# --- Release ----
# ----------------
FROM node:10.14.2-alpine AS release

# Create app directory
WORKDIR /app

# production dependencies
COPY --from=build /app/node_modules ./node_modules/

# source code
COPY --from=build /app/package.json ./
COPY --from=build /app/src ./src/

ENTRYPOINT ["node", "src/server.js"]
