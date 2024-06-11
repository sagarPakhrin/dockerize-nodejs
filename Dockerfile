FROM node:16-alpine as dev
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD [ "npm","run", "dev"]

# Stage 1: Development and Build
FROM node:16-alpine AS build

WORKDIR /app



COPY package.json package-lock.json ./
COPY prisma ./prisma

RUN npm install

RUN npx prisma generate

COPY . .

RUN npm run build

FROM node:16-alpine AS prod

WORKDIR /app

COPY package.json package-lock.json ./

COPY prisma ./prisma

RUN npm install --only=production

RUN npx prisma generate
COPY --from=build /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main.js"]
