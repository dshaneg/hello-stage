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
COPY auto auto/
COPY src src/
COPY test test/

COPY .eslintrc.yaml ./

ENTRYPOINT ["./auto/build.sh"]

# ----------------
# -- Prerelease --
# ----------------
FROM build as prerelease

# don't want to prune the build image, because I need to run tests in it.
# don't want to prune the release image, since alpine is missing some tools to do it with (namely python)
RUN npm prune --production

# ----------------
# --- Release ----
# ----------------
FROM node:10.14.2-alpine AS release

# Create app directory
WORKDIR /app

# production dependencies
COPY --from=prerelease /app/node_modules ./node_modules/

COPY --from=dependencies /app/package*.json ./
COPY --from=build /app/src ./src/

ENTRYPOINT ["node", "src/server.js"]
